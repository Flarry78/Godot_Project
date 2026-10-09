extends Area2D

var richtung : Vector2 = Vector2()
var  speed : float = 100


func _process(delta: float) -> void:
	
	self.global_position += richtung * speed * delta
	
	
	
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	self.queue_free()
	
	pass
