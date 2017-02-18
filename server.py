
from flask import Flask, request, jsonify
from flaskext.mysql import MySQL

from article import Article

import os
app = Flask(__name__)
mysql = MySQL()

file = open('notpasswords.txt', 'r')
user = file.readline()
password = file.readline()
database = file.readline()
host = file.readline()

file.close()
app.config['MYSQL_DATABASE_USER'] = user.strip()
app.config['MYSQL_DATABASE_PASSWORD'] = password.strip()
app.config['MYSQL_DATABASE_DB'] = database.strip()
app.config['MYSQL_DATABASE_HOST'] = host.strip()

mysql.init_app(app)
conn = mysql.connect()
cursor = conn.cursor()

@app.route('/getMainFeed', methods=['POST'])
def index():
    if request.method == 'POST':
        json = request.get_json()
        id = json["id"]
        cursor.execute("SELECT title, info_file, publisher_id from Article WHERE id=%s;", (id,))
        data = cursor.fetchone()

        if data is None:
            data = {"exists": "false"}
        else:
            data = {"exists": "true"}
        article = Article(data[0], data[1], data[2])
        print(article.title)        
        returnDict = {"status": "ok", "data": "Server is working"}
        return jsonify(returnDict)

app.run(debug = True)

#port = int(os.environ.get('PORT', 5000))
#app.run(debug=True, host="0.0.0.0", port=port)

