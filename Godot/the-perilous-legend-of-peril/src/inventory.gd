extends Node

var max_inventory_size = 100

func add_item ( item_id : String , amount ) :
	var item = load(item_id)
	if Database.count_stored_items() > max_inventory_size : # Full Inventory
		return " FullInventoryError "
	else :
		# Checks if you can stack the item and either adds a new entry or stacks it
		if Database.get_stored_item_amount(item_id) and item.stackable : # If the item is in the database and stackable
			Database.update_stored_item_amount(amount, item_id)
		else :
			Database.add_stored_item(item_id, amount )
		return True
