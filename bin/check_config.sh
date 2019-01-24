#!/bin/bash

docker-compose -f docker-testing.yaml run web python \
  -m homeassistant --script check_config --config /config
