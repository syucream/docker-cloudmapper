#!/bin/sh

# Author: https://github.com/sebastientaggart/
#
# This file initializes the cloudmapper container by:
# - configure aws cli with vars from .env file
# - update the config.json cloudmapper config file
# - run "collect", "prepare", and "webserver" scripts
# - serve the application on :8000

# TODO: Support demo mode
# DEMO_MODE = false/true
# Check if:
#  -- demo mode is false
#  AND -- all 4 AWS vars are set
#  THEN do prod setup
#  ELSE demo mode all the way :)

# Configure the AWS CLI inside the container
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure set region ${AWS_DEFAULT_REGION}
aws configure set output json

if grep -q "${ACCOUNT}" config.json
then
    echo "${ACCOUNT} already exists in config.json, skipping 'configure add-account'"
else
    # Generate config.json with our account settings
    pipenv run python cloudmapper.py configure add-account --config-file config.json --name ${ACCOUNT} --name ${ACCOUNT} --id ${ACCOUNT} --default true
fi

# Collect info about our AWS infrastructure, store this in /account-data, which
# is volumed to the host.
pipenv run python cloudmapper.py collect --account ${ACCOUNT}

# Prepare the collected data for serving
pipenv run python cloudmapper.py prepare --account ${ACCOUNT}

# Start serving on :8000 (by default), --public means bind to 0.0.0.0
pipenv run python cloudmapper.py webserver --public
