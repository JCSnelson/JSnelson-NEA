extends Node2D

func get_pos(direction):
	match direction:
		'north':
			return $North.global_position
		'south':
			return $South.global_position 
		'east':
			return $East.global_position 
		'west':
			return $West.global_position 

func set_pos(direction, global_pos):
	match direction:
		'north':
			position += global_pos - $North.global_position
		'south':
			position += global_pos - $South.global_position 
		'east':
			position += global_pos - $East.global_position 
		'west':
			position += global_pos - $West.global_position 

func cap(direction):
	match direction:
		'north':
			var north_cap = load("res://scenes/game/worlds/rooms/north_cap.tscn").instantiate()
			$North.add_child(north_cap)
		'south':
			var south_cap = load("res://scenes/game/worlds/rooms/south_cap.tscn").instantiate()
			$South.add_child(south_cap)
		'east':
			var east_cap = load("res://scenes/game/worlds/rooms/east_cap.tscn").instantiate()
			$East.add_child(east_cap)
		'west':
			var west_cap = load("res://scenes/game/worlds/rooms/west_cap.tscn").instantiate()
			$West.add_child(west_cap)
	
func _ready() -> void:
	if $Slimes:
		for slime in $Slimes.get_children():
			slime.health = floor(2*Global.current_level*log(3*Global.difficulty))
			slime.damage = floor(Global.current_level*log(3*Global.difficulty))
			print(slime.health,slime.damage)
	if $Labels:
		for label in $Labels.get_children():
			var k:String = "level 1"
			label.text = label.text.replace("0", str(Global.current_level))
			print(label.text)
		
