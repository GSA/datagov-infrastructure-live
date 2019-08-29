#!/bin/bash
# Generates temporary credentials for MFA users
# Make sure you set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY before running
# Set your AWS_MFA_DEVICE_ARN
# the script.
#
#     $ eval "$(./bin/aws_temp_credentials.sh)"

set -o errexit
set -o pipefail
set -o nounset

credentials_file="$(mktemp)"

function cleanup () {
  rm -rf "$credentials_file"
}

function get_credentials () {

  # Prompt for the multi-factor authentication code
  read -p "MFA token code: " mfa_token_code

  # Write the temporary credentials to file
  aws sts get-session-token --serial-number "$AWS_MFA_DEVICE_ARN"  --token-code "$mfa_token_code" > "$credentials_file"

  # Echo the environment variables for eval
  cat <<EOF
export AWS_ACCESS_KEY_ID="$(jq -r '.Credentials.AccessKeyId' "$credentials_file")"
export AWS_SECRET_ACCESS_KEY="$(jq -r '.Credentials.SecretAccessKey' "$credentials_file")"
export AWS_SESSION_TOKEN="$(jq -r '.Credentials.SessionToken' "$credentials_file")"
EOF
}

trap cleanup EXIT
get_credentials
