extends Node2D




func _on_sign_in_button_pressed() -> void:
	var username = $Input/UsernameInput.text
	var password = $Input/PasswordInput.text
	var success = Database.login(username, password)
	if not (typeof(success) == TYPE_BOOL and success == true):
		if success == "InvalidUsernameError":
			$Labels/ErrorLabel.text = "Invalid Username"
		elif success == "IncorrectPasswordError":
			$Labels/ErrorLabel.text = "Incorrect Password"
	else:
		get_tree().change_scene_to_file("res://scenes/menu/save_menu.tscn")


func _on_forgot_password_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/reset_password_form.tscn")


func _on_create_account_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/create_account_form.tscn")


func _on_quit_button_pressed() -> void:
	Global.quit()
