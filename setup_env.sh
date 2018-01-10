#!/bin/bash

source /home/postgres/councilmatic/bin/activate
pip install -U Django==1.11.8

pip install -r /home/postgres/scripts/requirements.txt

# add unit testing
pip install -U pytest
pip install -U pytest-cov
pip install -U pytest-django

# sqlalchemy
pip install psycopg2
pip install SQLAlchemy

# elasticsearch
pip install elasticsearch

# jupyter notebook
pip install jupyter

python -m ipykernel install --user --name councilmatic --display-name "councilmatic"


