@tool
extends EditorScript




func _run() -> void:
	var path = "res://utils/test.db"
	var dir  = DirAccess.open("res://utils")
	
	if dir.file_exists("test.db"):
		var err = dir.remove("test.db")
	var db = load("res://src/database.gd").new()
	db.setup(path)
	
	#Criteria 6.
	print("6.1:")
	print((len(db.gen_salt()) == 64) and (db.gen_salt() != db.gen_salt())) # Test 6.1.1
	print(len(db.j_hash("password", "salt")) == 64) # Test 6.1.2
	print(db.j_hash("password", "salt") == db.j_hash("password", "salt")) # Test 6.1.3
	print(db.j_hash("password", "salt") != db.j_hash("Password", "salt")) # Test 6.1.4
	
	print("6.3:")
	print(db.add_user("Hyrule", "Password", "Answer")) # Test 6.3.1
	print(db.add_user("Hyrule", "Password", "Answer") == "InvalidUsernameError") # Test 6.3.2
	print(db.login("Hyru1e", "Password") == "InvalidUsernameError") # Test 6.7.1
	print(db.login("Hyrule", "Password")) # Test 6.7.2
	print(db.reset_password("Hyru1e", "Answer", "password") == "InvalidUsernameError") # Test 6.8.1
	print(db.reset_password("Hyrule", "answer", "password") == "IncorrectAnswerError") # Test 6.8.2
	print(db.reset_password("Hyrule", "Answer", "password")) # Test 6.8.3
	print(db.login("Hyrule", "Password") == "IncorrectPaswordError") # Test 6.7.3
	
	print("hi")
	db.db.close_db()
