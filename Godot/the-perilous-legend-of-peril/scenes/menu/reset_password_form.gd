extends Node2D





func _on_reset_button_pressed() -> void:
	var username = $Input/UsernameInput.text
	var answer = $Input/QuestionInput.text
	var password = $Input/PasswordInput.text
	var success = Database.reset_password(username, answer, password)
	if not (typeof(success) == TYPE_BOOL and success == true):
		if success == "InvalidUsernameError":
			$Labels/ErrorLabel.text = "Invalid Username"
		elif success == "IncorrectAnswerError":
			$Labels/ErrorLabel.text = "Incorrect Answer"
	else:
		get_tree().change_scene_to_file("res://scenes/menu/login_form.tscn")


func _on_cancel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/login_form.tscn")
