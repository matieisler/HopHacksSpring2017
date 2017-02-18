
from flask import Flask, request, jsonify
from flaskext.mysql import MySQL

app = Flask(__name__)
mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'root'
app.config['MYSQL_DATABASE_DB'] = 'sys'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'


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


