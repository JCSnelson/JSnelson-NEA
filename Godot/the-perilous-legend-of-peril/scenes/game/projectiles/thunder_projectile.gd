extends CharacterBody2D

var damage: int = 1
var damage_type: String = "thunder"
var speed = 120
var attacking = false


func _physics_process(delta: float) -> void:
	velocity.x = speed * cos(rotation)
	velocity.y = speed * sin(rotation)
	if not attacking:
		move_and_slide()
	#Collisions
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
