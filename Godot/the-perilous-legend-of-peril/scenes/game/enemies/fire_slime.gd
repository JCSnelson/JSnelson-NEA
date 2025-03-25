extends CharacterBody2D



var direction = Vector2(0,1)
@export var speed:int = 20
@export var health: int = 10
@export var damage: int = 1
@export var damage_type: String = "fire"
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
	$HealthBar.max_value = health
	$HealthBar.value=health

func _physics_process(delta: float) -> void:
	var player_detected = false
	for body in $Area2D.get_overlapping_bodies():
		if body.name == "Player":
			player_detected = true
	if not animating:
		$AnimatedSprite2D.play(get_animation("idle"))
		if player_detected and can_attack:
			direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
			var projectile = load("res://scenes/game/projectiles/fire_projectile.tscn").instantiate()
			projectile.rotation_degrees = rad_to_deg(direction.angle())
			projectile.position = position + 20*direction
			projectile.damage = damage
			get_parent().add_child(projectile)
			can_attack=false
			$AttackTimer.start()
	
	
func take_damage(damage, damage_type):
	var player = get_tree().get_first_node_in_group("player")
	animating = true
	if damage_type in weaknesses:
		health -= 2*damage
	else:
		health -= damage
	velocity = - 25 * to_local(player.global_position).normalized()
	$HealthBar.value = health
	$HealthBar.visible = true
	if health <= 0:
		queue_free()
	else:
		$AnimatedSprite2D.play(get_animation("hurt"))
	await $AnimatedSprite2D.animation_finished
	velocity = Vector2(0,0)
	animating = false
	$HealthBar.visible = false
	


func _on_navigation_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	$NavigationAgent2D.set_target_position(player.global_position)


func _on_attack_timer_timeout() -> void:
	can_attack = true
