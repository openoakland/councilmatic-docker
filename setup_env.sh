#!/bin/bash

source /home/postgres/councilmatic/bin/activate
pip3 install -U Django==1.11.8

pip3 install -r /home/postgres/scripts/requirements.txt

# add unit testing
pip install -U pytest
pip install -U pytest-cov
pip install -U pytest-django

# sqlalchemy
pip3 install psycopg2
pip3 install SQLAlchemy

