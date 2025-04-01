extends Node2D

#Function to load the list
func _load_list():
	for child in $SavesScroller/VBoxContainer.get_children():
		child.queue_free()
	var save_data_list = Database.get_user_save_data()
	for save_data in save_data_list:
		var button = Button.new()
		var hardcore
		if save_data["hardcore"] == 1:
			hardcore = "True"
		else:
			hardcore = "False"
		print(save_data)
		button.text = "Name: %s\nLevel: %s \t Difficulty: %s\nHardcore: %s" % [save_data["name"], save_data["level"], save_data["difficulty"], hardcore]
		button.connect("pressed",_on_save_selected.bind(save_data))
		$SavesScroller/VBoxContainer.add_child(button)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_list()


func _on_save_selected(save_data):
	Database.current_save_id = save_data["save_id"]
	Global.difficulty = save_data["difficulty"]
	get_tree().change_scene_to_file("res://scenes/game/worlds/tutorial.tscn")

func _on_difficulty_drag_ended(value_changed: bool) -> void:
	$Difficulty/DifficultyLabel.text = "Difficulty: " + str($Difficulty.value)


func _on_new_save_button_pressed() -> void:
	Database.add_new_save_data($Name.text,$Difficulty.value,$HardcoreButton.button_pressed)
	_load_list()



func _on_log_out_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/login_form.tscn")
