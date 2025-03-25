extends Area2D

var damage: int = 1
var damage_type: String = "fire"
var time:int = 1


func _ready():
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(time).timeout
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") or body.is_in_group("player"): # If its an enemy or player damages it
		body.take_damage(damage, damage_type)
