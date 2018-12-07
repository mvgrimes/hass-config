    bash -c "cd ../../home-assistant && . bin/activate && cd ../config && ../home-assistant/lovelace-gen.py"

    watchman -- trigger /srv/app/hass/config/lovelace compile-ui '*.yaml' '*/*.js' -- bash -c "cd ../../home-assistant && . bin/activate && cd ../config && ../home-assistant/lovelace-gen.py"
    watchman -- trigger /Users/mgrimes/src/hass/config/lovelace compile-ui '*.yaml' '*/*.js' -- bash -c "cd ../../home-assistant && . bin/activate && cd ../config && ../home-assistant/lovelace-gen.py"
