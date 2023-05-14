#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails webpacker:install
bundle exec rails webpacker:compile
# Fetch output to see of any errors...
./bin/webpack
# bundle exec rake assets:precompile
# bundle exec rake assets:clean
bundle exec rake db:migrate
