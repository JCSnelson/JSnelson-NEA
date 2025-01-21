extends Node

var max_inventory_size = 100


func item_amount(item_id: String):
	return Database.get_stored_item_amount(item_id)



func add_item (item_id, amount):
	var item = load(item_id) # Loads the item
	if Database.count_stored_items() > max_inventory_size : # Full Inventory
		return "FullInventoryError"
	else :
		# Checks if you can stack the item and either adds a new entry or stacks it
		if len(Database.get_stored_item_amount(item_id)) != 0 and item.stackable : # If the item is in the database and stackable
			Database.update_stored_item_amount(amount, item_id)
		else :
			Database.add_stored_item(item_id, amount)
		return true


func remove_item(item_id, amount):
	var amount_stored = Database.get_stored_item_amount(item_id)
	if len(amount_stored) != 0: # If the item is in the database
		amount_stored = amount_stored[0]["amount"]
		if amount_stored < amount: # Not enough items
			return "ItemQuantityError"
		elif amount_stored == amount: # Exactly enough items
			Database.remove_stored_item(item_id)
		else :
			Database.update_stored_item_amount(-amount, item_id) # Removes the ammount of that item
		return true # Indicates that it was successful
	return "ItemQuantityError"
	

func unequip_item(slot):
	# Gets the slot value
	var value = Database.get_slot_value(slot)
	# Checks if there is an item to unequip
	if value != null:
		if (add_item(value, 1) == "FullInventoryError"): # Adds the item back to the stored_items/checks if the inventory is full
			return "FullInventoryError"
		Database.set_slot_value(slot, null) # Sets the slot back to null
		return true
	return true # If there is no item to unequip we have succeeded


func equip_item(item_id):
	var slot: String
	var item = load(item_id) # Loads the item
	# Checks if the item is Equipable
	if not(item is Equipable):
		return false
	# Gets the slot to equip it into
	if item is Armour:
		slot = item.body_part
	elif item is Weapon:
		slot = "weapon"
	else:
		if Database.get_slot_value("charm_1") == null:
			slot = "charm_1"
		else:
			slot = "charm_2"
	
	remove_item(item_id,1)
	var success = unequip_item(slot)
	if not(success is bool) and success == "FullInventoryError":
		add_item(item_id,1)
		return "FullInventoryError"
	Database.set_slot_value(slot, item_id)
	
	
