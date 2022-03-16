#!/bin/bash

set -eu
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

terraform init
terraform workspace select "$ENVIRONMENT"

terraform apply --auto-approve  \
        -var="do_token=$DO_TOKEN" -var="docker-tag=$DOCKER_TAG"
sleep 20

