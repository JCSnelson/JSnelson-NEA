extends StaticBody2D

@export var change_scene: bool
@export var scene_path: String
@export var key_path: String
@export var locked: bool
@export var level: int

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"): # Check pressed button
		for x in $Area2D.get_overlapping_bodies():
			if x.name == "Player": # Check the player is within range
				if not(locked) or Inventory.remove_item(key_path,1) is bool: # Check if the player has the key and removes it if the door isnt locked
					if change_scene:
						if Database.get_save_data()[0]["level"] < level:
							Database.set_level_value(level)
						get_tree().change_scene_to_file(scene_path) # Change Scene
					else:
						queue_free()
