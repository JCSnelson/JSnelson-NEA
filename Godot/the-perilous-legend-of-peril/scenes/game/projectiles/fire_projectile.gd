extends CharacterBody2D

var damage: int = 1
var damage_type: String = "fire"
var speed = 120
var attacking = false


func _physics_process(delta: float) -> void:
	#Gets movement vector
	velocity.x = speed * cos(rotation)
	velocity.y = speed * sin(rotation)
	if not attacking:
		move_and_slide()
	#Damages player or enemy if collides with them
	for i in range(get_slide_collision_count()):
		if not attacking:
			attacking = true
			var collision = get_slide_collision(i)
			print(collision)
			var collider = collision.get_collider()
			print(collider)
			if collider.is_in_group("player") or collider.is_in_group("enemies"):
				collider.take_damage(damage, damage_type)
			$CollisionShape2D.disabled = true
			$AnimatedSprite2D.play("impact")
			await $AnimatedSprite2D.animation_finished
			queue_free()
