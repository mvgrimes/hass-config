#!/usr/bin/env python3

# We don't have access to sqlite in the home-assistant docker container, but
# we have access to pythons sqlite3. We could rewrite notify-if-known in 
# python, but for now this hack will work.

import sqlite3
import sys

database = sys.argv[1]
number = sys.argv[2]

conn = sqlite3.connect(database)
c = conn.cursor()

n = (number,)
c.execute('SELECT name FROM phones WHERE phone LIKE ?', n)
result = c.fetchone()

if result:
    print( result[0] )
