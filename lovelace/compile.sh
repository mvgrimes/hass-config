#!/bin/bash

cd ../../home-assistant
source bin/activate
cd ../config
../home-assistant/lovelace-gen.py
