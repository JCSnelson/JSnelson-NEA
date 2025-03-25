extends Equipable

class_name Armour

@export var defense: int
@export var armour_type: String # "light", "heavy"
@export var body_part: String # "head", "chest", "legs"
@export var set_id: int

func display_string():
	return "Armour\nName: %s\nType: %s\nDefense: %s\n Description: %s" % [resource_name, armour_type.capitalize(), defense, description]
