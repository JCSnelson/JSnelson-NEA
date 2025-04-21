extends Node2D


func _ready():
	#Set current level
	Global.current_level = 1
	#Level graph setup
	var graph = load("res://scenes/game/worlds/rooms/graph/dungeon_graph.tscn").instantiate()
	add_child(graph)
	graph.add_node(0, 'east', 'corridor_along')
	graph.add_node(1, 'south', 'monster')
	graph.add_node(2, 'east', 'corridor_corner')
	graph.add_node(3, 'north', 'corridor_up')
	graph.add_node(4, 'north', 'monster')
	graph.add_node(3, 'east', 'monster')
	graph.add_node(2, 'south', 'corridor_corner')
	graph.add_node(7, 'south', 'monster')
	graph.add_node(6, 'south', 'corridor')
	graph.add_node(9, 'south', 'monster')
	graph.add_node(10, "east", 'corridor_along')
	graph.add_node(11, "east", "monster")
	graph.add_node(12, 'east', 'corridor_corner')
	graph.add_node(13, 'east', 'monster')
	graph.add_node(14, 'north', 'corridor_corner')
	graph.add_node(14, 'east', 'corridor_corner')
	graph.add_node(14, 'south', 'corridor_corner')
	graph.add_node(15, 'north', 'monster')
	graph.add_node(16, 'east', 'monster')
	graph.add_node(17, 'south', 'monster')
	graph.add_node(19, 'east', 'corridor_along')
	graph.add_node(21, "east", "monster")
	graph.add_node(22, 'north', 'corridor_corner')
	graph.add_node(23, 'east', 'corridor_corner')
	graph.add_node(24, 'east', 'corridor_corner')
	graph.add_node(25, 'east', 'corridor_corner')
	graph.add_node(23, 'north', 'monster')
	graph.add_node(24, 'north', 'monster')
	graph.add_node(24, 'south', 'monster')
	graph.add_node(25, 'north', 'monster')
	graph.add_node(25, 'south', 'monster')
	graph.add_node(26, 'north', 'monster')
	graph.add_node(26, 'south', 'monster')
	graph.add_node(33, 'east', 'corridor_corner')
	graph.add_node(34, 'south', 'monster')
	graph.add_node(34, 'east', 'corridor_up')
	graph.add_node(36, 'north', 'end')
	
	await graph.gen_dungeon()
	#Used for shrinking dungeon to view generation
	#self.scale = Vector2(0.25,0.25)
	#self.position = Vector2(0,1080/8)
	#Used for loading player in
	var player = load("res://scenes/game/player/player.tscn").instantiate()
	add_child(player)
