extends Area2D

var damage: int
var damage_type: String
var range: int


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"): # If its an enemy damages it
		body.take_damage(damage, damage_type)
