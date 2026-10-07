extends Node2D

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ESC"):
		get_tree().quit()
	
	
	pass
