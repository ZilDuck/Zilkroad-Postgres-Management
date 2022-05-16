# Postgres manager

This is a simple application/script that will manage deployments for our Postgres instances. It has three functionalities;
- Create
- Deployment
- Manual Deployment

# Building locally

1. CD into directory
```
$ cd postgres-management
```

2. Set up virtual environment & activate virtual env
```
$ virtualenv venv
$ ./venv/Scripts/activate
```

3. Install dependencies
```
$ (venv) python3 setup.py install
# If that fails
$ (venv) pip install -r requirements.txt
```

## Create

Use of this is intended for **new** instances of Postgres. Running the application is as follows;
```
$ ./application.py --postgres-dsn postgresql://postgres:postgres@localhost:5432/postgres --function create
```

This will run through all the sub directories under `create/` and perform them in order.

## Deployment

Use of this is for **existing** postgres instances. This is to deploy new features / alter existing structures on a given instance. Running the application is as follows;
```
$ ./application.py --postgres-dsn postgresql://postgres:postgres@localhost:5432/postgres --function deployment
```

This will run through all files found under the `deployment/` directory.  

**NB**: This will do verification checks to make sure the `deployment/` directory contents meet the criteria (see Appendix B)

## Manual Deployment

If you need to do a manual deployment (i.e. something in create failed) you can pop files into the `manual-deployment` directory and run the application as follows;
```
$ ./application.py --postgres-dsn postgresql://postgres:postgres@localhost:5432/postgres --function deployment --manual-deployment
```

This will run any files found under the `manual-deployment/` directory

**NB**: Whilst this does do verification checks also, one is skipped (see Appendix B)

# Appendix A - Creating a PR

From this point onwards, there is a strict structure in place to add new features to our Postgres infrastructure, below are a couple of examples.

### Example 1 - A new table

**Use case**: We want to add a new table to our schema

1. Create the table definition under `create/1-tables/`

```sql
-- create/1-tables/tbl_new_table.sql
CREATE TABLE "tbl_new_table" (
    id int8 PRIMARY KEY,
    name text
);
```

2. Add the order in `create/1-tables/order.json`
```diff
   ...
   "14": "tbl_deployments.sql",
+  "15": "tbl_new_table.sql"
}
```

3. Add the deployment
```sql
-- deployment/00000-add-new-table.sql
CREATE TABLE "tbl_new_table" (
    id int8 PRIMARY KEY,
    name text
);
```

4. Run the application in **DEPLOYMENT MODE**

### Example 2 - Altering an existing table

**Use case**: We want to add a new column to a table

1. Edit the existing table definition under `create/1-tables/`

```diff
 -- create/1-tables/tbl_calendar_event.sql
   CREATE TABLE "tbl_calendar_event" (
   	calendar_id SERIAL PRIMARY KEY,
   	calendar_unixtime int8 NOT NULL,
   	calendar_description text NOT NULL,
   	calendar_website text NOT NULL,
   	calendar_image text NOT NULL
+	calendar_something text DEFAULT "lol" NOT NULL
   );
   ALTER SEQUENCE tbl_calendar_event_calendar_id_seq RESTART WITH 1;
```

2. Add the deployment
```sql
-- deployment/00000-add-calendar-something-to-tbl-calendar-event.sql
ALTER TABLE tbl_calendar_event
	ADD calendar_something text DEFAULT "lol" NOT NULL;
```

3. Run the application in **DEPLOYMENT MODE**

# Appendix B - Verification checks

When it comes to deployment files, they should be named in the following way `<ordinal>-<rest-of-file-name>.sql`. When the deployment is ran, the following checks are initiated;
- Are the files formatted as `<ordinal>-<rest-of-file-name>.sql`
- Are there any gaps in the ordinals
- Are there any duplicate ordinals

### Examples of vialations

**Are the files formatted**

```
00000-valid-file-name.sql	  # This is valid
00001-another-valid-file-name.sql # This is valid
fix-tbl-calendar-events.sql	  # This is invalid, and will fail
```

---

**Are there any gaps in the ordinals**

```
00000-file-name-a.sql
00001-file-name-b.sql
00040-file-name-c.sql # 40 does not come after 1, this will fail
```
vs.
```
00000-file-name-a.sql
00001-file-name-b.sql
00002-file-name-c.sql # 2 comes after 1, this is valid
```
**NB**: For manual deployments, this check is skipped.

---

**Are there any duplicate ordinals**

```
00000-file-name-a.sql
00001-file-name-b.sql
00000-file-name-c.sql # This has the same ordinal as another file, this will fail
```

