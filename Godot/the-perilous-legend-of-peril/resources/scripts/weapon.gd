extends Equipable

class_name Weapon

@export var weapon_type: String # "ranged_magic", "area_magic", "melee"
@export var attack_power: int
@export var attack_range: int
@export var damage_type: String # "normal", "ice", "fire", "thunder", "divine","poison"
@export var mana_cost: int
var hurtbox_scene_path = "res://scenes/game/player/hurt_box.tscn"

func display_string():
	return "Weapon\nName: %s\nType: %s\nDamage: %s\nDamage Type: %s\n Description: %s" % [resource_name, weapon_type.replace("_"," ").capitalize(), attack_power, damage_type.capitalize(), description]
