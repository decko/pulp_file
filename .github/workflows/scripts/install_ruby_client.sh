#!/bin/bash

# WARNING: DO NOT EDIT!
#
# This file was generated by plugin_template, and is managed by it. Please use
# './plugin-template --github pulp_file' to update this file.
#
# For more info visit https://github.com/pulp/plugin_template

set -euv

# make sure this script runs at the repo root
cd "$(dirname "$(realpath -e "$0")")"/../../..

export PULP_URL="${PULP_URL:-https://pulp}"

export REPORTED_VERSION=$(http $PULP_URL/pulp/api/v3/status/ | jq --arg plugin file --arg legacy_plugin pulp_file -r '.versions[] | select(.component == $plugin or .component == $legacy_plugin) | .version')
export DESCRIPTION="$(git describe --all --exact-match `git rev-parse HEAD`)"
if [[ $DESCRIPTION == 'tags/'$REPORTED_VERSION ]]; then
  export VERSION=${REPORTED_VERSION}
else
  export EPOCH="$(date +%s)"
  export VERSION=${REPORTED_VERSION}${EPOCH}
fi

export response=$(curl --write-out %{http_code} --silent --output /dev/null https://rubygems.org/gems/pulp_file_client/versions/$VERSION)

if [ "$response" == "200" ];
then
  echo "pulp_file client $VERSION has already been released. Installing from RubyGems.org."
  gem install pulp_file_client -v $VERSION
  touch pulp_file_client-$VERSION.gem
  tar cvf ruby-client.tar ./pulp_file_client-$VERSION.gem
  exit
fi

cd ../pulp-openapi-generator
rm -rf pulp_file-client
./generate.sh pulp_file ruby $VERSION
cd pulp_file-client
gem build pulp_file_client
gem install --both ./pulp_file_client-$VERSION.gem
tar cvf ../../pulp_file/ruby-client.tar ./pulp_file_client-$VERSION.gem
