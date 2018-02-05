#!/bin/bash

source /home/postgres/councilmatic/bin/activate
pip install -r /home/postgres/scripts/requirements.txt

python -m ipykernel install --user --name councilmatic --display-name "councilmatic"




