extends Node2D




func _on_sign_up_button_pressed() -> void:
	#Get inputs
	var username = $Input/UsernameInput.text
	var password =  $Input/PasswordInput.text
	var answer = $Input/QuestionInput.text
	#Add's user if the passwords match checking for errors
	if $Input/PasswordInput.text == $Input/ConfirmPasswordInput.text:
		var success = Database.add_user(username, password, answer)
		if not (typeof(success) == TYPE_BOOL and success == true):
			if success == "InvalidUsernameError":
				$Labels/ErrorLabel.text = "Invalid Username"
		else:
			#Changes scene if user added
			get_tree().change_scene_to_file("res://scenes/menu/login_form.tscn")
	else:
		$Labels/ErrorLabel.text = "Passwords Don't Match"

#Changes scene
func _on_cancel_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/login_form.tscn")
