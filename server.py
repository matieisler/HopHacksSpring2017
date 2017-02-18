
from flask import Flask, request, jsonify
from flaskext.mysql import MySQL

app = Flask(__name__)
mysql = MySQL()

file = open('notpasswords', 'r')
user = file.readline()
password = file.readline()
database = file.readline()
host = file.readline()

app.config['MYSQL_DATABASE_USER'] = user
app.config['MYSQL_DATABASE_PASSWORD'] = password
app.config['MYSQL_DATABASE_DB'] = database
app.config['MYSQL_DATABASE_HOST'] = host


mysql.init_app(app)
conn = mysql.connect()
cursor = conn.cursor()

@app.route('/', methods=['POST'])
def index():
    if request.method == 'POST':
        json = request.get_json()
        returnDict = {"status": "ok", "data": "Server is working"}
        return jsonify(returnDict)

app.run(debug = True)


