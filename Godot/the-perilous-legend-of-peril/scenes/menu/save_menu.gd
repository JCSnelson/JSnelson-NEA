extends Node2D

#Function to load the list
func _load_list():
	for child in $SavesScroller/VBoxContainer.get_children():
		child.queue_free()
	var save_data_list = Database.get_user_save_data()
	for save_data in save_data_list:
		print(save_data)
		var button = Button.new()
		button.text = "Save_Id: %s\nLevel: %s \t Difficulty: %s\nHardcore: %s" % [save_data["save_id"], save_data["level"], save_data["difficulty"], save_data["hardcore"]]
		button.connect("pressed",_on_save_selected.bind(save_data))
		$SavesScroller/VBoxContainer.add_child(button)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_list()


func _on_save_selected(save_data):
	Database.current_save_id = save_data["save_id"]
	print("yes")
	get_tree().change_scene_to_file("res://test.tscn")

func _on_difficulty_drag_ended(value_changed: bool) -> void:
	$Difficulty/DifficultyLabel.text = "Difficulty: " + str($Difficulty.value)


func _on_new_save_button_pressed() -> void:
	Database.add_new_save_data($Difficulty.value,$HardcoreButton.button_pressed)
	_load_list()



func _on_log_out_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/login_form.tscn")
