extends CharacterBody2D


var speed = 100
var health = 100
var last_direction = Vector2(1,0)
var animating = false
var weapon

func _ready():
	add_to_group("player")

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
	velocity = direction.normalized() * speed
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
		await get_tree().create_timer(0.5).timeout
		weapon = load(Database.get_slot_value("weapon"))
		if weapon.weapon_type == "melee":
			#Load the hurtbox scene
			var hurtbox_scene = load(weapon.hurtbox_scene_path)
			var hurtbox_instance = hurtbox_scene.instantiate()
			hurtbox_instance.range = weapon.attack_range
			hurtbox_instance.damage = weapon.attack_power
			hurtbox_instance.damage_type = weapon.damage_type
			hurtbox_instance.rotation = last_direction.angle()
			#Add child
			add_child(hurtbox_instance)
			#Hitbox lasts for a tenth of a second
			await get_tree().create_timer(0.1).timeout
			print("yes")
			hurtbox_instance.queue_free()
		await $AnimatedSprite2D.animation_finished
		animating = false


func take_damage(damage, damage_type):
	health = health-damage
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/menu/save_menu.tscn")
	print(health)
