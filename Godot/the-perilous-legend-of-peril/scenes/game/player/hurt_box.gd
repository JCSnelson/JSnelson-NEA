extends Area2D

var damage: int
var damage_type: String
var range: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bodies = get_overlapping_bodies() # Get bodies in area
	for body in bodies:
		print(body)
		if body.is_in_group("enemies"): # If its an enemy damages it
			body.take_damage(damage, damage_type)
