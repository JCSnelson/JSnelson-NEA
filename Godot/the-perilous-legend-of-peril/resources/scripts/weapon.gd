extends Equipable

class_name Weapon

@export var weapon_type: String # "ranged", "magic", "melee"
@export var attack_power: int
@export var attack_range: int
@export var damage_type: String # "ice", "fire", "cursed", "divine","poison"
var hurtbox_scene_path = "res://scenes/game/player/hurt_box.tscn"

func attack(owner, direction: Vector2):
	#Load the hurtbox scene
	var hurtbox_scene = load(hurtbox_scene_path)
	var hurtbox_instance = hurtbox_scene.instantiate()
	hurtbox_instance.range = attack_range
	hurtbox_instance.damage = attack_power
	hurtbox_instance.rotation = direction.angle()
	#Add child
	owner.add_child(hurtbox_instance)
	#Hitbox lasts for a tenth of a second
	await owner.get_tree().create_timer(0.1).timeout
	hurtbox_instance.queue_free()
