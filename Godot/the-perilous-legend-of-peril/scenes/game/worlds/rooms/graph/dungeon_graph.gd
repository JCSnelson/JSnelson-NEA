extends Node

class_name DungeonGraph

var root: DungeonGraphNode
var nodes: Array
var rooms: Dictionary = {'chest':["res://scenes/game/worlds/rooms/monster/room.tscn"], 
'end':["res://scenes/game/worlds/rooms/end/end.tscn"], 
'start':["res://scenes/game/worlds/rooms/start/start.tscn"], 
'monster':["res://scenes/game/worlds/rooms/monster/m_room_1.tscn","res://scenes/game/worlds/rooms/monster/m_room_2.tscn","res://scenes/game/worlds/rooms/monster/m_room_3.tscn","res://scenes/game/worlds/rooms/monster/m_room_4.tscn","res://scenes/game/worlds/rooms/monster/m_room_5.tscn"], 
'corridor':["res://scenes/game/worlds/rooms/corridors/corridor_1.tscn","res://scenes/game/worlds/rooms/corridors/corridor_2.tscn","res://scenes/game/worlds/rooms/corridors/corridor_3.tscn","res://scenes/game/worlds/rooms/corridors/corridor_4.tscn","res://scenes/game/worlds/rooms/corridors/corridor_5.tscn","res://scenes/game/worlds/rooms/corridors/corridor_6.tscn","res://scenes/game/worlds/rooms/corridors/corridor_7.tscn","res://scenes/game/worlds/rooms/corridors/corridor_8.tscn","res://scenes/game/worlds/rooms/corridors/corridor_9.tscn","res://scenes/game/worlds/rooms/corridors/corridor_10.tscn","res://scenes/game/worlds/rooms/corridors/corridor_11.tscn","res://scenes/game/worlds/rooms/corridors/corridor_12.tscn"],
'corridor_along':["res://scenes/game/worlds/rooms/corridors/corridor_1.tscn","res://scenes/game/worlds/rooms/corridors/corridor_7.tscn"],
'corridor_up':["res://scenes/game/worlds/rooms/corridors/corridor_2.tscn","res://scenes/game/worlds/rooms/corridors/corridor_8.tscn"],
'corridor_corner':["res://scenes/game/worlds/rooms/corridors/corridor_3.tscn","res://scenes/game/worlds/rooms/corridors/corridor_4.tscn","res://scenes/game/worlds/rooms/corridors/corridor_5.tscn","res://scenes/game/worlds/rooms/corridors/corridor_6.tscn","res://scenes/game/worlds/rooms/corridors/corridor_9.tscn","res://scenes/game/worlds/rooms/corridors/corridor_10.tscn","res://scenes/game/worlds/rooms/corridors/corridor_11.tscn","res://scenes/game/worlds/rooms/corridors/corridor_12.tscn"]}
var opposite_direction = {'north':'south', 'south':'north', 'east':'west', 'west':'east'}


func unordered_equal(list_1, list_2):
	for i in list_1:
		if not(i in list_2):
			return false
	for i in list_2:
		if not(i in list_1):
			return false
	return true

func _init() -> void:
	root = DungeonGraphNode.new()
	root.room_type = "start"
	nodes.append(root)

func add_node(onto_index, direction, room_type):
	var onto = nodes[onto_index]
	if onto[direction]:
		return false
	var new_node = DungeonGraphNode.new()
	new_node.room_type = room_type
	onto[direction] = new_node
	match direction:
		'north':
			new_node.south = onto
		'south':
			new_node.north = onto
		'east':
			new_node.west = onto
		'west':
			new_node.east = onto
	nodes.append(new_node)
	return true


func gen_room(node,previous_direction = null, previous = null):
	var room = load(rooms[node.room_type].pick_random()).instantiate()
	add_child(room)
	if previous_direction:
		room.set_pos(previous_direction,previous.get_pos(opposite_direction[previous_direction]))
	else:
		room.position = Vector2(0,0)
	for i in ['north', 'south', 'east', 'west']:
		if node[i] == null:
			room.cap(i)
	return room


func gen_dungeon(node=root, previous_direction = null, previous = null, generated = []):
	var room = await gen_room(node,previous_direction,previous)
	generated.append(node)
	for i in ['north', 'south', 'east', 'west']:
		if node[i] and node[i] not in generated:
			generated = await gen_dungeon(node[i], opposite_direction[i], room, generated)
	return generated
	
	




	
