extends Node

var db = SQLite.new()
var current_user_id: int
var current_save_id: int

#region Prepared Statements

var _create_table_users = """
CREATE TABLE IF NOT EXISTS users (
	user_id INTEGER PRIMARY KEY AUTOINCREMENT,
	username VARCHAR(15) UNIQUE NOT NULL,
	password VARCHAR(64) NOT NULL,
	salt VARCHAR(64) NOT NULL,
	answer VARCHAR(64) NOT NULL
);
"""

var _get_user_data = """
SELECT * FROM users
WHERE username = ?;
"""

var _add_new_user = """
--Assume hashed password and answer
INSERT INTO
users(username,password,answer,salt)
VALUES (?,?,?,?);
"""

var _reset_password = """
--Assume hashed password and answer
UPDATE users
SET password = ?
WHERE username = ?
"""

var _create_table_save_data = """
CREATE TABLE IF NOT EXISTS save_data (
save_id INTEGER PRIMARY KEY AUTOINCREMENT,
user_id INTEGER,
difficulty INTEGER,
hardcore INTEGER,
level INTEGER,
head VARCHAR(32),
chest VARCHAR(32),
legs VARCHAR(32),
charm_1 VARCHAR(32),
charm_2 VARCHAR(32),
FOREIGN KEY(user_id) REFERENCES users(user_id)
);
"""

var _add_new_save_data = """
INSERT INTO
save_data(user_id,difficulty,hardcore,level)
VALUES (?,?,?,?);
"""

var _get_save_data = """
SELECT * FROM save_data
WHERE user_id = ?
AND save_id = ?;
"""

var _get_user_save_data = """
SELECT level, hardcore, save_id FROM save_data
WHERE user_id = ?;
"""

var _update_save_data = """
UPDATE save_data
SET
head = ?,
chest = ?,
legs = ?,
charm_1 = ?,
charm_2 = ?,
level = ?
WHERE
user_id = ?
AND save_id = ?;
"""

var _create_table_stored_items = """
CREATE TABLE IF NOT EXISTS stored_items (
item_id INTEGER NOT NULL,
save_id INTEGER NOT NULL,
PRIMARY KEY(item_id,save_id),
FOREIGN KEY(save_id) REFERENCES save_data(save_id)
);
"""

var _update_stored_item_amount = """
UPDATE stored_items
SET amount = amount + ?
WHERE item_id = ?
AND save_id = ?;
"""

var _get_stored_item_amount = """
SELECT amount FROM stored_items
WHERE save_id = ?
AND item_id = ?;
"""

var _add_stored_item = """
INSERT INTO
stored_items(save_id,item_id,amount)
VALUES (?,?,?);
"""


#endregion



#test
func test() -> void:
	
	#Open or Create a database
	db.path = "res://game_data.db"
	db.open_db()
	db.drop_table("users")
	if not db.query(_create_table_users):
		print("Error: users table unable to be created")
		return
		
		
	
	if db.query_with_bindings(_add_new_user,["user","pass","ans","salt"]):
		print("success")
		
	db.query_with_bindings(_get_user_data,["user"])
	print(db.query_result)
	db.close_db()

#Function for generating salt
func gen_salt() -> String:
	var salt = "string"
	var x = randi_range(5,10)
	for i in range(2**x):
		salt = j_hash(salt,str(i*randi_range(1,10)))
	return salt

#Function for hashing a password or challenge answer
func j_hash(string, salt):
	var hashedString = string
	#Repeating a consistent but unpredictable amount of times
	#On even rounds the password is sandwidged on odd rounds the salt is sandwidged
	#Alternating the use of sha256 and md5 but making sure to end on sha256 so the hash is a predictable length.
	for x in range(1,6*len(string)+1):
		if x % 2 == 0:
			hashedString = (salt.substr(x,hashedString.length()-x)+hashedString+salt.substr(0,x)).md5_text().sha256_text()
		else:
			hashedString = (hashedString.substr(0,x)+salt+hashedString.substr(x,hashedString.length()-x)).sha256_text().md5_text()
	return hashedString

#Function for creating a user
func add_user(username, password, answer):
	var salt = gen_salt() #Generating new salt
	var hashedPassword = j_hash(password, salt)
	var hashedAnswer = j_hash(answer, salt)
	if not db.query_with_bindings(_add_new_user,[username,hashedPassword,hashedAnswer,salt]): #Tries to add user with hashed password and answer
		return "InvalidUsernameError" #If user cannot be added then the username must be invalid
	return true
#Function for logging in
func login(username,password):
	db.query_with_bindings(_get_user_data,[username]) # Getting user data
	if len(db.query_result) == 0: # If user doesnt exist
		return "InvalidUsernameError"
	var user_data = db.query_result[0]
	var hashed_password = j_hash(password,user_data["salt"])
	if hashed_password == user_data["password"]: # Checking password hash against stored hash
		current_user_id = user_data["user_id"]
		return true
	return "IncorrectPasswordError" # If password doesnt match
#Function for resetting the password
func reset_password(username, answer, password):
	db.query_with_bindings(_get_user_data,[username]) # Getting user data
	if len(db.query_result) == 0: # If user doesnt exist
		return "InvalidUsernameError"
	var user_data = db.query_result[0]
	var hashed_answer = j_hash(answer,user_data["salt"])
	var hashed_password = j_hash(password, user_data["salt"])
	if hashed_answer == user_data["answer"]: # Checking the answer hash against the stored hash
		db.query_with_bindings(_reset_password,[hashed_password,username])
		return true
	return "IncorrectAnswerError" # If answer doesnt match

func _ready() -> void:
	
	db.path = "res://game_data.db"
	db.open_db()
	if not db.query(_create_table_users):
		print("Error: users table unable to be created")
		return
	
	if not db.query(_create_table_save_data):
		print("Error: save_data table unable to be created")
		return
	
	if not db.query(_create_table_stored_items):
		print("Error: stored_items table unable to be created")
		return
	print("DONE")
	
	if not add_user("Hyrule","password","oxford"):
		print("non unique")
		
	print(db.query_result)
	add_user("Hyrule","password","oxford")
	print(db.query_result)


func _exit_tree() -> void:
	db.close_db()
