extends CharacterBody2D


const SPEED = 100
var last_direction = Vector2(1,0)
var animating = false

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
	#Mocing/Idling if its not already animating
	if not animating:
		if direction:
			last_direction = direction
			$AnimatedSprite2D.play(get_animation("walk"))
		else:
			$AnimatedSprite2D.play(get_animation("idle"))
		move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()


func attack():
	if not animating:
		animating = true
		$AnimatedSprite2D.play(get_animation("melee"))
		load(Database.get_slot_value("weapon")).attack(self, last_direction)
		await $AnimatedSprite2D.animation_finished
		animating = false
		
