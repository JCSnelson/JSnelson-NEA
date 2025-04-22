extends Node2D



func _on_sign_in_button_pressed() -> void:
	#Gets Inputs
	var username = $Input/UsernameInput.text
	var password = $Input/PasswordInput.text
	#Tries to login and handles errors
	var success = Database.login(username, password)
	if not (success is bool and success == true):
		if success == "InvalidUsernameError":
			$Labels/ErrorLabel.text = "Invalid Username"
		elif success == "IncorrectPasswordError":
			$Labels/ErrorLabel.text = "Incorrect Password"
	else: #Changes to save menu if succesfull
		get_tree().change_scene_to_file("res://scenes/menu/save_menu.tscn")

#Changes scene to reset password form
func _on_forgot_password_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/reset_password_form.tscn")

#Changes scene to create acount form
func _on_create_account_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/create_account_form.tscn")

#Quits
func _on_quit_button_pressed() -> void:
	Global.quit()
