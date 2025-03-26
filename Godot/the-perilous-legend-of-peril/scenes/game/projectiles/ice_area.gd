extends Area2D

var damage: int = 1
var damage_type: String = "ice"


func _ready():
	await $AnimatedSprite2D.animation_finished
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") or body.is_in_group("player"): # If its an enemy or player damages it
		body.take_damage(damage, damage_type)
