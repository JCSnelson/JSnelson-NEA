extends CanvasLayer

var player

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	$HealthBar.max_value = player.health
	$MagicBar.max_value = player.magic
	

func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	$HealthBar.value = player.health
	$MagicBar.value = player.magic
