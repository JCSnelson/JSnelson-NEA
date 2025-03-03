extends Node



func await_call(n:int,f:Callable):
	await get_tree().create_timer(n).timeout
	f.call(1)

func quit():
	get_tree().quit()
