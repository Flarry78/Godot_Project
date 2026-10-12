extends Area2D

var richtung : Vector2 = Vector2()
var speed : float = 70
var dmg : float = 0

func _process(delta: float) -> void:
	
	self.global_position += richtung * speed * delta
	
	
	
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	self.queue_free()
	
	pass


func _on_area_entered(area: Area2D) -> void:
	
	if is_instance_valid(area):
		var dad = area.get_parent()
		if dad.has_method("getdmg"):
			dad.getdmg(dmg)
	
	self.queue_free()
	
	pass
