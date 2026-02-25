#!/bin/bash
set -e

exec bundle exec unicorn \
  -c unicorn.rb \
  -E development