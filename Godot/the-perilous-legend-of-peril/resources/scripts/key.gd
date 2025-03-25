extends Item

class_name Key

@export var key_id: String


func display_string():
	return "Key\nName: %s\n Description: %s" % [resource_name, description]
