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

var _delete_user = """
DELETE FROM users
WHERE username = ?;
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
weapon VARCHAR(32),
charm_1 VARCHAR(32),
charm_2 VARCHAR(32),
FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE
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
SELECT level, hardcore, save_id, difficulty FROM save_data
WHERE user_id = ?;
"""

var _update_save_data = """
UPDATE save_data
SET
head = ?,
chest = ?,
legs = ?,
weapon = ?
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
amount INTEGER NOT NULL,
PRIMARY KEY(item_id,save_id),
FOREIGN KEY(save_id) REFERENCES save_data(save_id) ON DELETE CASCADE
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

var _count_stored_items = """
SELECT COUNT(*)
FROM stored_items
WHERE save_id = ?;
"""

var _remove_stored_item = """
DELETE FROM stored_items
WHERE save_id = ?
AND item_id = ?;
"""

var _get_slot_values = """
SELECT * FROM save_data
WHERE save_id = ?;
"""

var _set_head_value = """
UPDATE save_data
SET head = ?
WHERE save_id = ?;
"""

var _set_chest_value = """
UPDATE save_data
SET chest = ?
WHERE save_id = ?;
"""

var _set_legs_value = """
UPDATE save_data
SET legs = ?
WHERE save_id = ?;
"""

var _set_weapon_value = """
UPDATE save_data
SET weapon = ?
WHERE save_id = ?;
"""

var _set_charm_1_value = """
UPDATE save_data
SET charm_1 = ?
WHERE save_id = ?;
"""

var _set_charm_2_value = """
UPDATE save_data
SET charm_2 = ?
WHERE save_id = ?;
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
#Function for deleting a user
func delete_user(username, password):
	db.query_with_bindings(_get_user_data,[username])
	if len(db.query_result) == 0: # If user doesnt exist
		return "InvalidUsernameError"
	var user_data = db.query_result[0]
	var hashed_password = j_hash(password,user_data["salt"])
	if hashed_password == user_data["password"]: # Checking password hash against stored hash
		db.query_with_bindings(_delete_user,[username]) # Deleting User
		return true
	return "IncorrectPasswordError" # If password doesnt match
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
#Function for counting the stored_items in the save
func count_stored_items():
	db.query_with_bindings(_count_stored_items,[current_save_id])
	return db.query_result[0]["COUNT(*)"]
#Function for getting the amount of a stored item in the save
func get_stored_item_amount(item_id):
	db.query_with_bindings(_get_stored_item_amount,[current_save_id, item_id])
	return db.query_result
#Function for updating the amount of a stored item in the save by adding an amount
func update_stored_item_amount(amount, item_id):
	db.query_with_bindings(_update_stored_item_amount, [amount, item_id, current_save_id])
	return db.query_result
#Function for adding a stored item into the save
func add_stored_item(item_id, amount):
	db.query_with_bindings(_add_stored_item, [current_save_id, item_id, amount])
	return db.query_result
#Function for removing a stored item from the save
func remove_stored_item(item_id):
	db.query_with_bindings(_remove_stored_item, [current_save_id, item_id])
	return db.query_result
#Function for getting a slot value from the save
func get_slot_value(slot):
	return "res://resources/equipable/weapon/test_weapon.tres"
	db.query_with_bindings(_get_slot_values,[current_save_id])
	if len(db.query_result) == 0:
		return null
	return db.query_result[0][slot]
#Function for setting a slot value in the save
func set_slot_value(slot, item_id):
	match slot:
		"head":
			db.query_with_bindings(_set_head_value, [item_id, current_save_id])
		"chest":
			db.query_with_bindings(_set_chest_value, [item_id, current_save_id])
		"legs":
			db.query_with_bindings(_set_legs_value, [item_id, current_save_id])
		"weapon":
			db.query_with_bindings(_set_weapon_value, [item_id, current_save_id])
		"charm_1":
			db.query_with_bindings(_set_charm_1_value, [item_id, current_save_id])
		"charm_2":
			db.query_with_bindings(_set_charm_2_value, [item_id, current_save_id])
	return db.query_result
#Function for getting the save data entries for the current user
func get_user_save_data():
	db.query_with_bindings(_get_user_save_data,[current_user_id])
	return db.query_result[0]
#Function to add a new save file for the current user
func add_new_save_data(difficulty, hardcore):
	db.query_with_bindings(_add_new_save_data,[current_user_id, difficulty, hardcore, 1])
	return db.query_result




#Function for setting up the database
func setup(path):
	db.path = path
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
	
	db.query("PRAGMA foreign_keys = ON;")

func _ready() -> void:
	setup("res://game_data.db")


func _exit_tree() -> void:
	db.close_db()
