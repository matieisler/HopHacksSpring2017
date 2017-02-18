
from flask import Flask, request, jsonify
from flaskext.mysql import MySQL

import os
app = Flask(__name__)
mysql = MySQL()

file = open('notpasswords.txt', 'r')
user = file.readline().strip()
password = file.readline().strip()
database = file.readline().strip()
host = file.readline().strip()

file.close()
app.config['MYSQL_DATABASE_USER'] = user
app.config['MYSQL_DATABASE_PASSWORD'] = password
app.config['MYSQL_DATABASE_DB'] = database
app.config['MYSQL_DATABASE_HOST'] = host

mysql.init_app(app)
conn = mysql.connect()
cursor = conn.cursor()

@app.route('/getMainFeed', methods=['POST'])
def index():
    if request.method == 'POST':
        json = request.get_json()
        cursor.execute("SELECT * FROM Article;")
        data = cursor.fetchall()
        if data is None:
            returnDict = {"status": "ok"}
        else:
            articleDicts = []
            for article in data:
                id_article = article[0]
                file_id = article[1]
                title = article[2]
                publisher_id = article[3]

                cursor.execute("SELECT * FROM Groups WHERE id=%s;", publisher_id)
                data = cursor.fetchone()
                
                publisher_name = data[3]
                
                content = article[4]
                article_type = article[5]
                articleDict = {"id": id_article, "file_id": file_id, "title": title, "publisher_name": publisher_name,
                               "content": content, "article_type": article_type}
                articleDicts.append(articleDict)
            returnDict = {"status": "ok", "data": articleDicts}
        return jsonify(returnDict)

def parse_articles():
    pass

def parse_users():
    pass

def parse_groups():
    pass

def parse_events():
    pass
# app.run(debug = True)

port = int(os.environ.get('PORT', 5000))
app.run(debug=True, host="0.0.0.0", port=port)

