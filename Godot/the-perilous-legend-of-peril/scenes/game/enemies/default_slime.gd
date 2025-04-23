extends CharacterBody2D



var direction = Vector2(0,1)
@export var speed:int = 20
@export var health: int = 10
@export var damage: int = 1
@export var damage_type: String = "normal"
@export var weaknesses: Array
var animating: bool
var can_attack = true

func get_animation(animation_type: String):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			return animation_type + "_r"
		else:
			return animation_type + "_l"
	else:
		if direction.y > 0:
			return animation_type + "_d"
		else:
			return animation_type + "_u"

func _ready():
	add_to_group("enemies")
	$HealthBar.max_value=health
	$HealthBar.value=health

func _physics_process(delta: float) -> void:
	# If player in range sets move to true
	var move = false
	for body in $Area2D.get_overlapping_bodies(): 
		if body.name == "Player":
			move = true
	#Moves or idles if not animating
	if not animating:
		if move:
			direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
			velocity = direction * speed
			$AnimatedSprite2D.play(get_animation("walk"))
			move_and_slide()
		else:
			$AnimatedSprite2D.play(get_animation("idle"))
	else:
		move_and_slide()
	
	#Attacks player if collides with them and can attack
	if can_attack:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_in_group("player"):
				collider.take_damage(damage, damage_type)
				can_attack=false
				$AttackTimer.start()

func take_damage(damage, damage_type):
	var player = get_tree().get_first_node_in_group("player")
	animating = true
	if damage_type in weaknesses: #Takes more damage from weaknesses
		health -= 2*damage
	else:
		health -= damage
	velocity = - 25 * to_local(player.global_position).normalized() #takes knockback by changing velocity
	$HealthBar.value=health
	$HealthBar.visible = true
	if health <= 0: #dies if health is low
		queue_free()
	else:
		$AnimatedSprite2D.play(get_animation("hurt"))
	await $AnimatedSprite2D.animation_finished
	animating = false
	velocity = Vector2(0,0) #Removes knockback velocity
	$HealthBar.visible = false

func _on_navigation_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		$NavigationAgent2D.set_target_position(player.global_position)

func _on_attack_timer_timeout() -> void:
	can_attack = true
