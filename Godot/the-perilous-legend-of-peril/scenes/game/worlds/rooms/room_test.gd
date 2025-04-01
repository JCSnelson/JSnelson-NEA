extends Node2D


func _ready():
	await dungeon_1()
	#self.scale = Vector2(0.5,0.5)
	#self.position = Vector2(1920/4,1080/4)
	var player = load("res://scenes/game/player/player.tscn").instantiate()
	player.position = Vector2(1920/2,1080/2)
	add_child(player)
	
	
func dungeon_1():
	var graph = load("res://scenes/game/worlds/rooms/graph/dungeon_graph.tscn").instantiate()
	add_child(graph)
	graph.add_node(0, 'north', 'corridor_along')
	graph.add_node(0, 'east', 'corridor_corner')
	graph.add_node(1, 'west', 'monster')
	graph.add_node(2, 'north', 'corridor_up')
	graph.add_node(4, 'north', 'monster')
	graph.add_node(2, 'east', 'monster')
	graph.add_node(0, 'south', 'corridor_corner')
	graph.add_node(7, 'south', 'monster')
	graph.add_node(6, 'south', 'corridor')
	graph.add_node(9, 'south', 'monster')
	await graph.gen_dungeon()

func dungeon_2():
	var graph  = load("res://scenes/game/worlds/rooms/graph/dungeon_graph.tscn").instantiate()
	add_child(graph)
	graph.add_node(0, 'north', 'corridor_corner')
	graph.add_node(1, 'east', 'corridor_corner')
	graph.add_node(2, 'east', 'corridor_corner')
	graph.add_node(3, 'east', 'corridor_corner')
	graph.add_node(1, 'north', 'monster')
	graph.add_node(2, 'north', 'monster')
	graph.add_node(2, 'south', 'monster')
	graph.add_node(3, 'north', 'monster')
	graph.add_node(3, 'south', 'monster')
	graph.add_node(4, 'north', 'monster')
	graph.add_node(4, 'south', 'monster')
	graph.add_node(11, 'east', 'corridor_corner')
	graph.add_node(12, 'south', 'monster')
	graph.add_node(12, 'east', 'corridor_up')
	graph.add_node(14, 'north', 'boss')
	await graph.gen_dungeon()
	
func dungeon_3():
	var graph  = load("res://scenes/game/worlds/rooms/graph/dungeon_graph.tscn").instantiate()
	add_child(graph)
	graph.add_node(0, 'north', 'corridor_corner')
	graph.add_node(0, 'east', 'corridor_corner')
	graph.add_node(0, 'south', 'corridor_corner')
	graph.add_node(0, 'west', 'corridor_corner')
	graph.add_node(1, 'north', 'monster')
	graph.add_node(2, 'east', 'monster')
	graph.add_node(3, 'south', 'monster')
	graph.add_node(4, 'west', 'monster')
	
	await graph.gen_dungeon()
	
