#!/bin/bash

# https://github.com/ciotlosm/custom-lovelace/blob/master/monster-card/monster-card.js
mkdir -p monster-card
curl https://raw.githubusercontent.com/ciotlosm/custom-lovelace/master/monster-card/monster-card.js \
    > monster-card/monster-card.js

# https://github.com/ciotlosm/custom-lovelace/blob/master/entity-attributes-card/entity-attributes-card.js
mkdir -p entity-attributes-card
curl https://raw.githubusercontent.com/ciotlosm/custom-lovelace/master/entity-attributes-card/entity-attributes-card.js \
    > entity-attributes-card/entity-attributes-card.js
