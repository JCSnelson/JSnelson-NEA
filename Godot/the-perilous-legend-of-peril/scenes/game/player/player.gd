extends CharacterBody2D


var speed = 100
var health = 100
var mana = 100
var last_direction = Vector2(1,0)
var animating = false
var weapon
var can_dash = true
var ui = preload("res://scenes/game/player/ui.tscn")
func _ready():
	add_to_group("player")
	add_child(ui.instantiate())

#Function to return the directional name of the animation in the direction player ois facing
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
	#Moving or Idling if its not already animating
	if not animating:
		if direction:
			last_direction = direction
			$AnimatedSprite2D.play(get_animation("walk"))
		else:
			$AnimatedSprite2D.play(get_animation("idle"))
		move_and_slide()

#Handles different input types
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()
	elif event.is_action_pressed("dash"):
		if can_dash: # Increases speed momentarily if you can dash
			speed = 8*speed
			can_dash = false
			await get_tree().create_timer(0.05).timeout
			speed = speed/8
			await get_tree().create_timer(0.5).timeout
			can_dash = true
	if event.is_action_pressed("help"): #Loads help emnu and pauses till key pressed again
		var help_menu = load("res://scenes/menu/help_menu.tscn").instantiate()
		add_child(help_menu)
		get_tree().paused = true
		await get_tree().create_timer(0.2).timeout
		while not Input.is_action_just_pressed("help"):
			await get_tree().process_frame
		help_menu.queue_free()
		get_tree().paused = false
	elif event.is_action_pressed("inventory"): #Loads Inventory and pauses till key pressed again
		var inventory_ui = load("res://scenes/game/player/inventory_ui.tscn").instantiate()
		$UI.visible = false
		add_child(inventory_ui)
		get_tree().paused = true
		await get_tree().create_timer(0.2).timeout
		while not Input.is_action_just_pressed("inventory"):
			await get_tree().process_frame
		inventory_ui.queue_free()
		$UI.visible = true
		get_tree().paused = false

			


func attack():
	#Gets weapon and attacks if it isnt animating and you have the mana
	if Database.get_slot_value("weapon"):
		weapon = load(Database.get_slot_value("weapon"))
		if not animating and mana >= weapon.mana_cost:
			animating = true
			mana -= weapon.mana_cost
			if weapon.weapon_type == "melee":
				$AnimatedSprite2D.play(get_animation("melee"))
				await get_tree().create_timer(0.5).timeout # Account for animation delay
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
			elif weapon.weapon_type == "ranged_magic":
				$AnimatedSprite2D.play(get_animation("melee")) #Change later
				await get_tree().create_timer(0.5).timeout # Account for animation delay
				#Load the projectile scene
				var projectile = load("res://scenes/game/projectiles/%s_projectile.tscn"%weapon.damage_type).instantiate()
				var projectile_direction = (get_viewport().get_mouse_position()-Vector2(1920/2,1080/2)).normalized()
				projectile.rotation_degrees = rad_to_deg(projectile_direction.angle())
				projectile.position = position + 20 * projectile_direction
				projectile.damage = weapon.attack_power
				get_parent().add_child(projectile)
			elif weapon.weapon_type == "area_magic":
				$AnimatedSprite2D.play(get_animation("melee")) #Change later
				await get_tree().create_timer(0.5).timeout # Account for animation delay
				#Load the projectile scene
				var area_direction = (get_viewport().get_mouse_position()-Vector2(1920/2,1080/2)).normalized()
				var area = load("res://scenes/game/projectiles/%s_area.tscn"%weapon.damage_type).instantiate()
				area.position = position + 25 * area_direction
				area.damage = weapon.attack_power
				get_parent().add_child(area)
			await $AnimatedSprite2D.animation_finished
			animating = false



func take_damage(damage, damage_type): #Removes the amount of health for the damage
	health -= damage
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/menu/save_menu.tscn")
