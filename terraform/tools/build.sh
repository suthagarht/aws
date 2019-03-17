#!/bin/bash

# This is a wrapper script that will help build terraform projects.

set -ex

while getopts "c:d:e:p:h" option
do
  case $option in
    c ) CMD=$OPTARG ;;
    d ) DATA_DIR=$OPTARG ;;
    e ) ENVIRONMENT=$OPTARG ;;
    p ) PROJECT=$OPTARG ;;
    h ) HELP=1 ;;
  esac
done



function usage() {
    cat <<EOM
usage: $0 -c -e -p -s
     -c   The Terraform command (CMD) to run, eg "init", "plan" or "apply".
     -d   The root of the data directory (DATA_DIR) to take .tfvars files from.
     -e   The ENVIRONMENT to deploy to eg "aws-integration".
     -p   Specify which project to create, eg "jenkins".
     -h   Display this message.
Any remaining arguments are passed to Terraform
e.g. $0 -c plan -e foo -p bar -s baz -- -var further=override
     will pass "-var further=override" to terraform
Tip: these arguments can be passed by environment variable as well
     using the upper case version of their name.
EOM
}

function log_error() {
  echo -e "ERROR: $*\n"
  HELP=1
}

if [[ $HELP = '1' ]]; then
  usage
  exit
fi

# un-shift all the parsed arguments
shift $(expr $OPTIND - 1)

# Set up our locations
TERRAFORM_DIR='./terraform'
PROJECT_DIR="${TERRAFORM_DIR}/projects/${PROJECT}"
# BACKEND_FILE="${TERRAFORM_DIR}/modules/${MODULE}/remote_state.tf"
# BACKEND_FILE="remote_state.tf"
BACKEND_FILE="../../environment/${PROJECT}/${ENVIRONMENT}/${PROJECT}.backend"

# We're going to CD into $PROJECT so make paths relative to that.
echo "data dir is " $DATA_DIR
DATA_DIR="../../environment/${PROJECT}/${ENVIRONMENT}"
COMMON_DATA="${DATA_DIR}/common.tfvars"
SECRET_DATA="../../../secrets/${PROJECT}/secret.tfvars"

# Run everything from the appropriate project
cd "$PROJECT_DIR"

function init() {
  rm -rf .terraform && \
  rm -rf terraform.tfstate.backup && \
  terraform init \
            -backend-config="$BACKEND_FILE"
}


# Build the command to run
TO_RUN="init && terraform $CMD"
# Append which ever tfvar files exist


for TFVAR_FILE in "$COMMON_DATA" \
                  "$SECRET_DATA"
do
  if [[ -f $TFVAR_FILE ]] && [[ "$TFVAR_FILE" == "$SECRET_DATA" ]] ; then
    TO_RUN="$TO_RUN -var-file <(sops -d $TFVAR_FILE)"
  elif [[ -f $TFVAR_FILE ]]; then
    TO_RUN="$TO_RUN -var-file $TFVAR_FILE"
  fi
done

eval "$TO_RUN $*"
