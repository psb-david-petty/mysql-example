#!/usr/bin/env python3
#
# testmysql.py
#
# pip3 install mysql-connector-python
#

import mysql.connector

config = {
    'user': 'mysql', 
    'password': 'mysql', 
    'host': '127.0.0.1', 
    'database': 'test', 
}
cnx = mysql.connector.connect(**config)
cursor = cnx.cursor()
cursor.execute('SELECT * FROM pioneers WHERE sex = "F";')
for record in cursor:
    print(record)
cnx.close()
