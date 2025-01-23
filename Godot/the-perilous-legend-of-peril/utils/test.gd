extends Node2D


var db = preload("res://src/database.gd").new()

func _ready() -> void:
	if Engine.is_editor_hint():
		print("yay")
	print(Engine.get_singleton_list())
	var path = "res://utils/test.db"
	var dir  = DirAccess.open("res://utils")
	
	if dir.file_exists("test.db"):
		var err = dir.remove("test.db")
	
	db.setup(path)
	test_database()
	db.db.close_db()
	test_inventory()
	Database.db.close_db()

func test_database():
	#Criteria 6.
	print("6.1:")
	print((len(db.gen_salt()) == 64) and (db.gen_salt() != db.gen_salt())) # Test 6.1.1
	print(len(db.j_hash("password", "salt")) == 64) # Test 6.1.2
	print(db.j_hash("password", "salt") == db.j_hash("password", "salt")) # Test 6.1.3
	print(db.j_hash("password", "salt") != db.j_hash("Password", "salt")) # Test 6.1.4
	
	print("6.3")
	print(db.add_user("Hyrule", "Password", "Answer")) # Test 6.3.1
	print(db.add_user("Hyrule", "Password", "Answer") == "InvalidUsernameError") # Test 6.3.2
	
	print("6.7,6.8,6.10")
	print(db.login("Hyru1e", "Password") == "InvalidUsernameError") # Test 6.7.1
	print(db.login("Hyrule", "Password")) # Test 6.7.2
	print(db.reset_password("Hyru1e", "Answer", "password") == "InvalidUsernameError") # Test 6.8.1
	print(db.reset_password("Hyrule", "answer", "password") == "IncorrectAnswerError") # Test 6.8.2
	print(db.reset_password("Hyrule", "Answer", "password")) # Test 6.8.3
	print(db.login("Hyrule", "Password") == "IncorrectPasswordError") # Test 6.7.3
	
	print(db.delete_user("Hyrule", "Password") == "IncorrectPasswordError") # Test 6.10.1
	print(db.delete_user("Hyrule", "password")) # Test 6.10.2
	print(db.reset_password("Hyrule", "Answer", "password") == "InvalidUsernameError") # Test 6.7.4


func test_inventory():
	Database.add_user("test", "password", "answer")
	Database.login("test", "password")
	Database.add_new_save_data(1,true)
	Database.current_save_id = Database.get_user_save_data()[0]["save_id"]
	Inventory.max_inventory_size = 1
	#Criteria 12
	print(Inventory.add_item("res://utils/test_item.tres", 2)) # Test 12.5.1
	print(Inventory.item_amount("res://utils/test_item.tres") == 2)
	print(Inventory.add_item("res://utils/test_item.tres", 3)) # Test 12.5.2
	print(Inventory.add_item("res://utils/test_weapon.tres", 1) == "FullInventoryError") # Test 12.5.3
	print(Inventory.item_amount("res://utils/test_item.tres") == 5)
	print(Inventory.remove_item("res://utils/test_item.tres",2)) # Test 12.5.4
	print(Inventory.item_amount("res://utils/test_item.tres") == 3)
	print(Inventory.remove_item("res://utils/test_item.tres",10) == "ItemQuantityError") # Test 12.5.5
	print(Inventory.remove_item("res://utils/test_item.tres",3)) # Test 12.5.6
	print(Inventory.item_amount("res://utils/test_item.tres") == 0)
	print(Inventory.remove_item("res://utils/test_item.tres",2) == "ItemQuantityError") # Test 12.5.7
	print(Inventory.unequip_item("head")) # Test 12.4.1
	Inventory.add_item("res://utils/test_helmet.tres",1) #Test 12.4.2
	print(Inventory.equip_item("res://utils/test_helmet.tres"))
	print(Database.get_slot_value("head") == "res://utils/test_helmet.tres")
	print(Inventory.item_amount("res://utils/test_helmet.tres") == 0)
	Inventory.add_item("res://utils/test_helmet2.tres",1) # Test 12.4.3
	print(Inventory.equip_item("res://utils/test_helmet2.tres"))
	print(Inventory.item_amount("res://utils/test_helmet.tres") == 1)
	print(Inventory.unequip_item("head") == "FullInventoryError") # Test 12.4.4
	Inventory.remove_item("res://utils/test_helmet.tres",1) # Test 12.4.5
	print(Inventory.unequip_item("head"))
	
	
	Database.delete_user("test", "password")
	
