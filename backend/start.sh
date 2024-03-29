#!/bin/bash

source /home/e19co227/anaconda3/etc/profile.d/conda.sh

conda activate leaf_env 

cd /home/e19co227/e19-co227-Leaf-Colour-Quantifier/backend

gunicorn rest_api.api:app --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:5000
