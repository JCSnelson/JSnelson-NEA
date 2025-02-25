extends StaticBody2D

func _ready() -> void:
	add_to_group("enemies")

func take_damage(damage, damage_type):
	print(damage)
	print(damage_type)
