extends CanvasLayer

var selected: String = ""
var hbox: HBoxContainer
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	#var inventory = [{"item_id": "res://resources/equipable/weapon/test_weapon_magic_area.tres","amount":1},{"item_id": "res://resources/equipable/weapon/test_weapon_magic_ranged.tres","amount":1},{"item_id": "res://resources/equipable/weapon/test_weapon_melee.tres","amount":1},{"item_id": "res://resources/key/test_key.tres","amount":1},{"item_id": "res://resources/equipable/armour/test_armour.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1},{"item_id": "res://resources/key/test_key_2.tres","amount":1}]
	refresh()

func refresh():
	var inventory = Database.get_stored_items()
	var item_count = 0
	#Gets rid of existing children
	for child in $ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	for item in inventory: #Creates a button to select an item that displays key info about the item
		var button = Button.new()
		if item_count % 4 == 0:
			hbox = HBoxContainer.new()
			$ScrollContainer/VBoxContainer.add_child(hbox)
			print(hbox)
		button.text = load(item["item_id"]).display_string() + "\nAmount: %d" % item["amount"]
		button.connect("pressed",_select.bind(item["item_id"]))
		button.custom_minimum_size = Vector2(250,200)
		hbox.add_child(button)
		item_count += 1
	#Creates labels for all the equipped items
	if Database.get_slot_value("weapon"):
		$WeaponLabel.text = load(Database.get_slot_value("weapon")).display_string()
	if Database.get_slot_value("head"):
		$HeadLabel.text = load(Database.get_slot_value("head")).display_string()
	if Database.get_slot_value("chest"):
		$ChestLabel.text = load(Database.get_slot_value("chest")).display_string()
	if Database.get_slot_value("legs"):
		$LegsLabel.text = load(Database.get_slot_value("legs")).display_string()
	if Database.get_slot_value("charm_1"):
		$Charm1Label.text = load(Database.get_slot_value("charm_1")).display_string()
	if Database.get_slot_value("charm_2"):
		$Charm2Label.text = load(Database.get_slot_value("charm_2")).display_string()

#Changes selected item
func _select(item_id):
	selected = item_id

#Equips selected item if selected
func _on_equip_button_pressed() -> void:
	if selected != "":
		Inventory.equip_item(selected)
		refresh()

#Removes selected item if selected
func _on_bin_button_pressed() -> void:
	if selected != "":
		Database.remove_stored_item(selected)


func _on_log_out_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/login_form.tscn")
