
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

@app.route('/getGroups', methods=['POST'])
def parse_groups():
    if request.method == 'POST':
        json = request.get_json()
        cursor.execute("SELECT * FROM Groups;")
        data = cursor.fetchall()
        if data is None:
            returnDict = {"status": "ok"}
        else:
            groupsDict = []
            for group in data:
                id_group = group[0]
                user_id = group[1]
                file_id = group[2]
                group_name = group[3]
                phone_id = group[4]
                cursor.execute("SELECT * FROM Phones WHERE id=%s", phone_id)
                phone = cursor.fetchone()[1]
                email_id = group[5]
                cursor.execute("SELECT * FROM Emails WHERE id=%s", email_id)
                email = cursor.fetchone()[1]
                group_type_id = group[6]
                cursor.execute("SELECT * FROM Group_Types WHERE id=%s;", group_type)
                data = cursor.fetchone()
                group_type_name = cursor.fetchone()[1]
                
                groupDict = {"id_group": id_group, "user_id": user_id, "file_id": file_id,
                             "group_name": group_name, "phone": phone, "email", email,
                             "group_type_name": group_type_name}
                groupDicts.append(groupDict)
            returnDict = {"status": "ok", "data": groupDicts}
        return jsonify(returnDict)
    pass

def parse_events():
    data = cursor.fetchall()
    if data is None:
        returnDict = {"status": "ok"}
    else:
        dicts = []
        for event in data:
            id_event = event[0]
            start_date = event[1]
            end_date = event[2]
            title = event[3]
            info_file = event[4]
            location = event[5]
            
            cursor.execute("SELECT * FROM Groups WHERE id=%s;", group_id)
            group_id = cursor.fetchone()[3]
            
            eventDict = {"id": id_event, "start_date": start_date, "end_date": end_date, "title": title,
                           "info_file": info_file, "location": location, "group_id": group_id}
            dicts.append(eventDict)
        returnDict = {"status": "ok", "data": dicts}
    return jsonify(returnDict)
# app.run(debug = True)

port = int(os.environ.get('PORT', 5000))
app.run(debug=True, host="0.0.0.0", port=port)

