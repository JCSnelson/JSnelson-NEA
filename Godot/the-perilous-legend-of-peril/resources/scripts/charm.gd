extends Equipable

class_name Charm

@export var charm_type: String # "ice", "fire", "cursed", "divine","poison"

func display_string():
	return "Weapon\nName: %s\nType: %s\n Description: %s" % [resource_name, charm_type.capitalize(), description]
