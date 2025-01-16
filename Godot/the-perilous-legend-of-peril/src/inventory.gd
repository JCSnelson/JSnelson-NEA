extends Node

var max_inventory_size = 100

func add_item (item_id: String, amount ) :
	var item = load(item_id)
	if Database.count_stored_items() > max_inventory_size : # Full Inventory
		return "FullInventoryError"
	else :
		# Checks if you can stack the item and either adds a new entry or stacks it
		if len(Database.get_stored_item_amount(item_id)) != 0 and item.stackable : # If the item is in the database and stackable
			Database.update_stored_item_amount(amount, item_id)
		else :
			Database.add_stored_item(item_id, amount)
		return true


func remove_item(item_id, amount: int = 1) :
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
