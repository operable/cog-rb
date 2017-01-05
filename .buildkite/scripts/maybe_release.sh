#!/bin/bash

# Generates pipeline steps for releasing to Rubygems (or not) based on
# meta-data added by a previous blocking step.
#
# See https://building.buildkite.com/new-in-buildkite-block-step-input-fields-f0a955b1d9ab

set -euo pipefail

RESPONSE=$(buildkite-agent meta-data get rubygems-release-confirmation)
if [ "$RESPONSE" == "yes" ]
then
    echo "--- :thumbsup: Setting up a RubyGems release!"
    buildkite-agent pipeline upload <<EOF
steps:
  - label: "Releasing to :rubygems:"
    command: echo "Yup, we're totally generating a release"
EOF
else
    echo "--- :thumbsdown: No RubyGems release right now"
fi
