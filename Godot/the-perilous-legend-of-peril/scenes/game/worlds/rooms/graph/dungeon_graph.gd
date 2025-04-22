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



func _init():
	root = DungeonGraphNode.new()
	root.room_type = "start"
	nodes.append(root)
#Adds node onto the node at the onto index of the type
func add_node(onto_index, direction, room_type): 
	var onto = nodes[onto_index]
	if onto[direction]: # returns false if their is already a node in the place we are trying to place a new one
		return false
	var new_node = DungeonGraphNode.new()
	new_node.room_type = room_type 
	#Sets up connections
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
	var room = load(rooms[node.room_type].pick_random()).instantiate() #instantiates random room of specified type
	add_child(room)
	if previous_direction: #sets psoition to match entrances 
		room.set_pos(previous_direction,previous.get_pos(opposite_direction[previous_direction]))
	for i in ['north', 'south', 'east', 'west']: #Caps entrances with no neighbour
		if node[i] == null:
			room.cap(i)
	return room

func gen_dungeon(node=root, previous_direction = null, previous = null, generated = []):
	var room = await gen_room(node,previous_direction,previous) #Generates room
	generated.append(node) #Adds to generated list
	for i in ['north', 'south', 'east', 'west']: #recursive call on any neighbour nodes that havent been generated
		if node[i] and node[i] not in generated:
			generated = await gen_dungeon(node[i], opposite_direction[i], room, generated)
	return generated #returns generated to update list
	
	




	
