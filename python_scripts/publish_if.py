phone = data.get( 'phone', 'n/a' );
logger.info( "Checking for {} in database".format( phone ) )

# result = subprocess.check_output( ['echo',phone] )
topic = 'hass/callerid/say'
message = 'Call from {}'.format( phone )

### python_scripts in hass are very restricted. Doesn't appear to be any way to
### call out
pipe = os.popen("sqlite phones.sqlite 'select name from phones where phone like \"4157025008\"'", mode='r')
result = pipe.readline();
pipe.close()
logger.info( "... {}".format( result) )

hass.services.call( 'mqtt', 'publish', { "topic": topic, "payload": message } )
