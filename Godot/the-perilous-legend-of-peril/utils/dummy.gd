extends StaticBody2D
var damage_taken = 0

func _ready() -> void:
	add_to_group("enemies")

func take_damage(damage, damage_type):
	print("AAAAAAAAAAAA")
	print(damage)
	print(damage_type)
	damage_taken -= damage
	print(damage_taken)
