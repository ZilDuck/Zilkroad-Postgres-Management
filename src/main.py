#!/usr/bin/env python3
import json
import os
import re
import sys
import time

from collections import Counter, defaultdict
from os import listdir, scandir
from os.path import dirname, join

import psycopg2

ROOT_DIR = dirname(dirname(__file__))
CREATE_DIR = join(ROOT_DIR, "create")
DEPLOYMENT_DIR = join(ROOT_DIR, "deployment")
MANUAL_DEPLOYMENT_DIR = join(ROOT_DIR, "manual-deployment")

KEY_LENGTH = 5
PREFIX_REGEX = re.compile("^[0-9]{" + str(KEY_LENGTH) + "}-")


#pylint: disable=consider-using-with, consider-using-f-string
def main():
    postgres_dsn = None
    function = None
    dry_run = False
    manual_deployment = False
    try:
        postgres_dsn = os.environ['POSTGRES_DSN']
        function = os.environ['FUNCTION']
    except KeyError as exception:
        print(f"One of the following env vars is not set [POSTGRES_DSN, FUNCTION]: {exception}")
        sys.exit(1)
    try:
        dry_run = bool(os.environ['DRY_RUN'])
        manual_deployment = bool(os.environ['MANUAL_DEPLOY'])
    except KeyError:
        pass

    _verify_connection(postgres_dsn)
    if function.lower() == "create":
        create(postgres_dsn, dry_run)
    else:
        deploy(postgres_dsn, dry_run, manual_deployment)


def create(postgres_dsn, dry_run):
    """Creates all the tables/functions etc., under the create directory. Should any fail (hopefully not),
    then this is recorded and printed at the end of execution, in which these can be corrected via manual
    deployments. This is designed in a way that assumes this will only be ran once per Postgres instance
    setup.

    Args:
        postgres_dsn (str): Connection information for postgres
        dry_run (bool): Determines whether to print what it would do or not
    """
    directories = sorted([
        directory.path
        for directory in scandir(CREATE_DIR)
        if directory.is_dir()
    ])
    failed_creates = defaultdict(list)
    print(f"Found the following subdirectories {directories}")
    for directory in directories:
        print(f"Starting {directory}")
        directory_path = join(CREATE_DIR, directory)
        original_files = _get_sql_files(directory_path)
        files = None

        order_file = _get_order_file(directory_path)
        if order_file:
            files_from_order_file = list(order_file.values())
            if len(files_from_order_file) != len(original_files):
                raise AssertionError(
                    f"\tThe number of files vs order.json differs! {len(original_files)} vs {len(files_from_order_file)}" # pylint: disable=line-too-long
                )
            files = files_from_order_file
        else:
            files = original_files

        for file in files:
            if dry_run:
                print(f"\tDry run: [{directory}]\n\t\t{open(join(CREATE_DIR, directory, file), encoding='utf-8').read()}") # pylint: disable=line-too-long
                continue
            try:
                print(f"\tRunning file {file} ... ", end="")
                _execute_query(
                    postgres_dsn,
                    open(join(CREATE_DIR, directory, file), encoding='utf-8').read()
                )
            except Exception as exception: # pylint: disable=broad-except
                print(f"Error trying to execute {directory}/{file}: {exception}")
                failed_creates[directory].append(file)
                continue
            print("Complete")
        print(f"Finished {directory}")
    if failed_creates:
        print("The following files failed, you can fix these via MANUAL deployments:")
        for directory, failing_files in failed_creates.items():
            print(f"\t{directory}\n\t\t{failing_files}")


def deploy(postgres_dsn, dry_run, manual_deployment):
    """Deploys all files under the [manual-]deployment directory and then saves a record of each
    deployment ran in the deployments table. Filtering is done prior to executing the deployments
    to make sure no deployment gets ran twice i.e.;
        run_1:
            tbl_deployments: EMPTY
            deployments: [00001-add-foo-to-table-bar.sql]
                00001-add-foo-to-table-bar.sql gets executed
        run_2:
            tbl_deployments: [(00001-add-foo-to-table-bar.sql, False)]
            deployments: [00001-add-foo-to-table-bar.sql, 00002-add-baz-function.sql]
                00002-add-baz-function.sql gets executed

    Args:
        postgres_dsn (str): Connection information for postgres
        dry_run (bool): Determines whether to print what it would do or not
        manual_deployment (bool): Triggers whether it's doing a manual deploy or not
    """
    existing_deployments = _get_existing_deployments(postgres_dsn)
    all_deployments = _get_deployments(manual_deployment)
    _verify_deployments(all_deployments, manual_deployment)

    new_deployments = all_deployments.difference(existing_deployments)
    if len(new_deployments) == 0:
        print("No deployments to run")
        return

    print(f"{len(new_deployments)} deployments to run")
    for deployment in new_deployments:
        if dry_run:
            print(f"Dry run:\n\t{open(join(DEPLOYMENT_DIR, deployment), encoding='utf-8').read()}")
            continue

        print(f"Running deployment {deployment} ... ", end="")
        try:
            _execute_query(
                postgres_dsn,
                open(join(DEPLOYMENT_DIR, deployment), encoding='utf-8').read()
            )
        except psycopg2.IntegrityError as exception:
            print(f"Error trying to execute {deployment}: {exception}")
            raise
        print("Completed, now inserting record into tbl_deployments")
        try:
            _execute_query(
                postgres_dsn,
                "INSERT INTO tbl_deployments (file_name, manual_deployment) VALUES (%s, %s)",
                (deployment, manual_deployment)
            )
        except psycopg2.IntegrityError as exception:
            print(f"Error trying to add {deployment} to deployments table: {exception}")


def _verify_connection(postgres_dsn):
    """Tests connection to postgres. If it fails, then it raises an exception
    Raises:
        psycopg2.OperationalError: If the connection fails
    """
    count = 1
    max_count = 6
    interval = 3
    while count < max_count:
        try:
            with psycopg2.connect(postgres_dsn) as open_connection:
                with open_connection.cursor() as cursor:
                    cursor.execute("select 1;")
                    print("Connection to postgres is successful")
                    break
        except psycopg2.OperationalError as exception:
            print(f"Could not establish connection to postgres: {exception}")
            print(f"Attempt {count} of {max_count} sleeping for {count * interval}...")
            time.sleep(count * interval)
            if count == max_count:
                raise


def _execute_query(postgres_dsn, query, params=None):
    """Executes a query on Postgres
    Args:
        postgres_dsn (str): Connection information
        query (str): Query to execute
        params (tuple:optional): Parameters for query (default is None)

    Raises:
        psycopg2.IntegrityError: If any issue with the execution
    """
    with psycopg2.connect(postgres_dsn) as open_connection:
        with open_connection.cursor() as cursor:
            try:
                cursor.execute(query, params)
            except psycopg2.IntegrityError: # pylint: disable=try-except-raise
                raise


def _get_existing_deployments(postgres_dsn):
    """Queries postgres to get the existing deployments that may exist albeit manual_deployment files
    Returns:
        set(str): Set of all filenames
    """
    with psycopg2.connect(postgres_dsn) as open_connection:
        with open_connection.cursor() as cursor:
            cursor.execute("SELECT file_name FROM tbl_deployments WHERE manual_deployment = 'False';")
            return {result[0] for result in cursor.fetchall()}


def _get_deployments(manual_deployment):
    """Get a set of all deployments by listing the deployment directory
    Args:
        manual_deployment (bool): Determines whether to get deployments from the manual
            deployment directory or not

    Returns:
        set(str): Set of file names under the deployment directory
    """
    the_directory = MANUAL_DEPLOYMENT_DIR if manual_deployment else DEPLOYMENT_DIR
    return _get_sql_files(the_directory)


def _get_sql_files(the_directory):
    return {
        file_name
        for file_name in listdir(the_directory)
        if file_name.endswith(".sql")
    }


def _get_order_file(the_directory):
    try:
        with open(join(the_directory, "order.json"), encoding="utf-8") as open_file:
            return json.loads(open_file.read())
    except FileNotFoundError:
        return None


def _verify_deployments(all_deployments, manual_deployment):
    """Checks the names of the deployments by doing the following:
        - Checks the name is formatted as XXXXX-rest-of-file-name.sql
        - Checks that no gaps in ordinal numbers (i.e. [00001-a.sql, 00003-b.sql] would fail)
        - Checks no files have no duplicate ordinals (i.e. [00001-a.sql, 00001-b.sql] would fail)
    Note:
        if manual_deployment, then the gaps check is skipped

    Raises:
        AssertionError - If any of the above criteria isn't met
    """
    for deployment in all_deployments:
        if not re.match(PREFIX_REGEX, deployment):
            raise AssertionError(
                "Invalid deployment name: {deployment} - Must be formatted as {ordinal}-rest-of-filename.sql".format( # pylint: disable=line-too-long
                    deployment=deployment,
                    ordinal=_get_next_ordinal(all_deployments),
                )
            )

    ordinals = sorted(_get_ordinals(all_deployments))
    if not manual_deployment and ordinals and len(ordinals) - 1 < int(ordinals[-1]):
        raise AssertionError(
            f"Seems there are deployment files missing? Last ordinal: {ordinals[-1]} vs {len(ordinals)} number of files" # pylint: disable=line-too-long
        )

    ordinal_count = Counter(ordinals)
    duplicate_deployment_ordinals = [
        ordinal
        for ordinal, count in ordinal_count.items()
        if count > 1
    ]
    if duplicate_deployment_ordinals:
        raise AssertionError(
            f"An ordinal(s) has been used more than once {duplicate_deployment_ordinals}, these have to be unique" # pylint: disable=line-too-long
        )


def _get_next_ordinal(all_deployments):
    """Loop through all the files and acquire their ordinal (00001, 00002, etc.,)
    and return the next number formatted;
        [00001, 00002] -> "00003"
        [] -> "00000"
    Args:
        all_deployments set(str): Set of all the deployment file names

    Returns:
        str: Next ordinal as a string
    """
    ordinals = _get_ordinals(all_deployments)
    next_ordinal = int(max(ordinals)) + 1 if ordinals else 0
    return str(next_ordinal).rjust(KEY_LENGTH, "0")


def _get_ordinals(deployments):
    """Get the ordinals from a set of filenames;
        {00001-example-file.sql, 00002-another-file.sql} -> {00001, 00002}
    Returns:
        list(str): List of ordinals
    """
    return [
        deployment_file[0:KEY_LENGTH]
        for deployment_file in deployments
        if re.match(PREFIX_REGEX, deployment_file)
    ]
