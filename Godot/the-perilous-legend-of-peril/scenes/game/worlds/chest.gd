extends StaticBody2D

@export var item_pool: Dictionary
@export var item_number: int
@export var key_path: String
@export var locked: bool
var item_list: Array



func _ready() -> void:
	for item in item_pool:
		var add_list = []
		for x in item_pool[item]:
			add_list.append(item)
		item_list.append_array(add_list)

func _input(event):
	if event.is_action_pressed("interact"):
		for i in $Area2D.get_overlapping_bodies():
			if i.name == "Player": # Check the player is within range
				if not(locked) or Inventory.remove_item(key_path,1) is bool: # Check if the player has the key and removes it if the door isnt locked
					for j in range(item_number):
						Inventory.add_item(item_list[randi_range(0,len(item_list)-1)],1)
				print(item_list)
				queue_free()
