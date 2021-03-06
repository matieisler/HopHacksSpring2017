
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
def parse_articles():
    if request.method == 'POST':
        json = request.get_json()
        cursor.execute("SELECT * FROM Article;")
        data = cursor.fetchall()
        if data is None:
            returnDict = {"status": "ok"}
        else:
            articleDicts = []
            returnDict = articles_format(data)
        return jsonify(returnDict)

def articles_format(data):
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
        date_published = str(article[6])
        articleDict = {"id": id_article, "image_url": file_id, "title": title, "publisher_name": publisher_name,
                       "content": content, "article_type": article_type, "date_published": date_published}
        articleDicts.append(articleDict)
    returnDict = {"status": "ok", "data": articleDicts}
    return returnDict


def groups_format(data):
    groupDicts = []
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
        cursor.execute("SELECT * FROM Group_Types WHERE id=%s;", group_type_id)
        data = cursor.fetchone()
        description = group[7]
        group_type_name = data[1]
        
        groupDict = {"group_id": id_group, "user_id": user_id, "image_url": file_id,
                     "group_name": group_name, "phone": phone, "email": email,
                     "group_type_name": group_type_name, "description": description}
        groupDicts.append(groupDict)
    returnDict = {"status": "ok", "data": groupDicts}
    return returnDict


@app.route('/getUsers', methods=['POST'])
def parse_users():
    userDicts = []
    if request.method == 'POST':
        json = request.get_json()
        user_id = json["id"]
        cursor.execute("SELECT * FROM Users WHERE id=%s;", user_id)
        data = cursor.fetchone()
        if data is None:
            returnDict = {"status": "ok"}
        else:
            usersDict = []
            for user in data:
                info = user[1]
                name = user[2]
                last_name = user[3]
                gender = user[4]
                email_id = user[5]
                phone_id = user[6]
                user_type = user[7]
                file_id = user[8]
                
                userDict = {"user_id": user_id, "info": info, "name": name,
                             "last_name": last_name, "gender": gender, "email": email_id,
                             "phone": phone_id, "user_type": user_type, "image_url": file_id}
                userDicts.append(userDict)
            returnDict = {"status": "ok", "data": userDicts}
        return jsonify(returnDict)
    pass

def get_user(user_id):
    if request.method == 'POST':
        json = request.get_json()
        cursor.execute("SELECT * FROM Users WHERE id=%s;", user_id)
        user = cursor.fetchone()
        if user is None:
            returnDict = {"status": "ok"}
        else:
            info = user[1]
            name = user[2]
            last_name = user[3]
            gender = user[4]
            email_id = user[5]
            phone_id = user[6]
            user_type = user[7]
            file_id = user[8]
                
            userDict = {"user_id": user_id, "info": info, "name": name,
                "last_name": last_name, "gender": gender, "email": email_id,
                "phone": phone_id, "user_type": user_type, "image_url": file_id}
        return userDict
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
            returnDict = groups_format(data)
        return jsonify(returnDict)
    pass

@app.route('/getEvents', methods=['POST'])
def parse_events():
    if request.method == 'POST':
        json = request.get_json()
        startDate = json["start_date"]
        endDate = json["end_date"]
        if startDate is None and endDate is None:
            cursor.execute("SELECT * FROM Events;")
        else:
            cursor.execute("SELECT * FROM Events WHERE start_date >= %s AND end_date <= %s;", (startDate, endDate))
        data = cursor.fetchall()
    if data is None:
        returnDict = {"status": "ok"}
    else:
        dicts = []
        for event in data:
            id_event = event[0]
            start_date = str(event[1])
            end_date = str(event[2])
            title = event[3]
            info_file = event[4]
            location = event[5]
            file_url = event[7]
            
            cursor.execute("SELECT * FROM Groups WHERE id=%s;", event[6])
            group_id = cursor.fetchone()[3]
            
            eventDict = {"id": id_event, "start_date": start_date, "end_date": end_date, "title": title,
                           "info_file": info_file, "location": location, "host_name": group_id, "image_url": file_url}
            dicts.append(eventDict)
        returnDict = {"status": "ok", "data": dicts}
    return jsonify(returnDict)

@app.route('/filterByType', methods=['POST'])
def filterByType():
    returnDicts = []
    if request.method == 'POST':
        json = request.get_json()
        table = json["table"]
        type_ids = json["type_ids"]
        for type_id in type_ids:
            cursor.execute("SELECT * FROM %s WHERE %s_type = %s;", (table.title(), table, type_id))
            data = cursor.fetchall()

            if data is None:
                returnDict = {"status": "ok"}
            else:
                if table is 'groups':
                    returnDict = groups_format(data)
                else:
                    returnDict = article_format(data)
                returnDicts.append(returnDict)
        return returnDicts

@app.route('/getMisc', methods=['POST'])
def getMisc():
    returnDicts = []
    if request.method == 'POST':
        json = request.get_json()
        types = json["types"]
        for type in types:
            cursor.execute("SELECT * FROM Misc_Types WHERE type=%s;", (str(type),))
            type_id = cursor.fetchone()[0]
            cursor.execute("SELECT * FROM Misc WHERE type_id=%s;", (type_id,))
            miscs = cursor.fetchall()
            for misc in miscs:
                id = misc[0]
                title = misc[1]
                content = misc[2]
                image_url = misc[3]
                user_id = misc[5]
                date_posted = misc[6]
                #cursor.execute("SELECT * FROM Users WHERE id=%s;", (user_id,))
                #user = cursor.fetchone()
                user = get_user(user_id)
                miscDict = {"id": id, "title": title, "content": content, "image_url": image_url, "user_id": user_id, "date_posted": str(date_posted), "post_type": type, "user": user}
                returnDicts.append(miscDict)
    return jsonify({"status": "ok", "data": returnDicts})
   
@app.route('/uploadEvent', methods=['POST'])             
def uploadEvent():
    json = request.get_json()
    start_date = json["start_date"]
    end_date = json["end_date"]
    title = json["title"]
    event_info = json["event_info"]
    location = json["location"]
    group_id = json["group_id"]
    values = [start_date, end_date, title, event_info, location, group_id]
    cursor.execute("INSERT INTO Events (start_date, end_date, title, event_info, location, group_id) VALUES (? ? ? ? ? ?)",  values)
    conn.commit()

@app.route('/uploadPost', methods=['POST'])         
def uploadPost():
    json = request.get_json()
    title = json["title"]
    content = json["content"]
    type = json["type"]
    values = [title, content, type]
    cursor.execute("INSERT INTO Misc (title, content, type) VALUES (? ? ?)", values)
    conn.commit()

@app.route('/uploadArticle', methods=['POST'])         
def uploadArticle():
    json = request.get_json()
    title = json["title"]
    publisher_id = json["publisher_id"]
    content = json["content"]
    article_type = json["article_type"]
    date_published = json["date_published"]
    values = [title, publisher_id, content, article_type, date_published]
    cursor.execute("INSERT INTO Article (title, publisher_id, content, article_type, date_published) VALUES (? ? ? ? ?)", values)
    conn.commit()

# app.run(debug = True)

port = int(os.environ.get('PORT', 5000))
app.run(debug=True, host="0.0.0.0", port=port)

