#!/usr/bin/env python3

from setuptools import find_packages, setup

setup(
    name='postgres-management',
    version='0.0.1',
    description='Simple management tool for postgres, handling creation and deployments',
    author='Richard Goodman',
    url='https://github.com/ZilDuck/mono-zilkroad',
    scripts=['application.py']
    packages=find_packages(),
    install_requires=[
        'psycopg2==2.9.3'
    ]
)
