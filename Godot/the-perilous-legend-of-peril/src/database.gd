extends Node


var create_table_users = """
CREATE TABLE IF NOT EXISTS users (
	user_id INTEGER PRIMARY KEY AUTOINCREMENT,
	username VARCHAR(15) NOT NULL,
	password VARCHAR(64) UNIQUE NOT NULL,
	salt VARCHAR(64) NOT NULL,
	answer VARCHAR(64) NOT NULL
);
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
