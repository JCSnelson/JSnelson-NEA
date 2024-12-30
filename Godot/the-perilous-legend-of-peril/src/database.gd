extends Node

var db = SQLite.new()

var create_table_users = """
CREATE TABLE IF NOT EXISTS users (
	user_id INTEGER PRIMARY KEY AUTOINCREMENT,
	username VARCHAR(15) NOT NULL,
	password VARCHAR(64) NOT NULL,
	salt VARCHAR(64) NOT NULL,
	answer VARCHAR(64) NOT NULL
);
"""

var get_user_data = """
SELECT * FROM users
WHERE username = ?;
"""

var add_new_user = """
--Assume hashed password and answer
INSERT INTO
users(username,password,answer,salt)
VALUES (?,?,?,?);
"""

var reset_password = """
--Assume hashed password and answer
UPDATE TABLE users
SET invalidCount = 0
WHERE username = ?
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Open or Create a database
	db.path = "res://game_data.db"
	db.open_db()
	db.drop_table("users")
	if db.query(create_table_users):
		print("success")
	
	if db.query_with_bindings(add_new_user,["user","pass","ans","salt"]):
		print("success")
		
	db.query_with_bindings(get_user_data,["user"])
	print(db.query_result)
	db.close_db()
	
	
