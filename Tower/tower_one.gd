extends Node2D

@onready var towergrose : Array[Vector2i] = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(1,1)]
@onready var feuerrate: Timer = $feuerrate
var bullet : PackedScene = preload("res://Bullets/tower_geschoss_one.tscn")

var allegegner : Array[Node2D] = []

var schaden : float = 30

func _ready() -> void:
	
	
	
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if is_instance_valid(area):
		allegegner.append(area)
	
	if feuerrate.is_stopped():
		call_deferred("shoot")
		feuerrate.start()
	
	pass


func _on_area_2d_area_exited(area: Area2D) -> void:
	
	if is_instance_valid(area):
		allegegner.erase(area)
	
	pass


func shoot():
	
	if allegegner.is_empty():
		return
	
	if is_instance_valid(allegegner[0]):
		var ladebullet : Area2D = bullet.instantiate()
		ladebullet.global_position = self.global_position
		var schussrichtung = (allegegner[0].global_position - self.global_position).normalized()
		ladebullet.richtung = schussrichtung
		ladebullet.dmg = schaden
		get_tree().current_scene.get_node("kiste").add_child(ladebullet)
	
	
	pass


func _on_feuerrate_timeout() -> void:
	
	if allegegner.is_empty():
		feuerrate.stop()
		return
	
	shoot()
	
	pass
