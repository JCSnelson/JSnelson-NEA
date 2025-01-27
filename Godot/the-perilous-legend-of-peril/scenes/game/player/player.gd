extends CharacterBody2D


const SPEED = 300.0
var last_direction = Vector2(1,0)

func get_animation(animation_type: String):
	var anim = animation_type + "_"
	if last_direction.x:
		if last_direction.x == 1:
			anim += 'r'
		else:
			anim += 'l'
	if last_direction.y:
		if last_direction.y == 1:
			anim += 'd'
		else:
			anim += 'u'
	return anim


func _physics_process(delta: float) -> void:
	# Get the direction
	var direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("up","down"))
	# Velocity
	velocity = direction.normalized() * SPEED
	
	#Sprite
	if direction:
		last_direction = direction
		$AnimatedSprite2D.play(get_animation("walk"))
	else:
		$AnimatedSprite2D.play(get_animation("idle"))
		
	
	#move_and_slide()
