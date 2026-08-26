#!/usr/bin/env bash
set -o errexit

bundle install
npm install
bin/rails assets:precompile
bin/rails assets:clean
bin/rails db:migrate
