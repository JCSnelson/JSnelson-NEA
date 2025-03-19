extends Equipable

class_name Weapon

@export var weapon_type: String # "ranged_magic", "aoe_magic", "melee"
@export var attack_power: int
@export var attack_range: int
@export var damage_type: String # "normal", "ice", "fire", "thunder", "divine","poison"
var hurtbox_scene_path = "res://scenes/game/player/hurt_box.tscn"
