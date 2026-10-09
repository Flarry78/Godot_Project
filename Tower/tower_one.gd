extends Node2D

@onready var towergrose : Array[Vector2i] = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(1,1)]
@onready var feuerrate: Timer = $feuerrate
var bullet : PackedScene = preload("res://Bullets/tower_geschoss_one.tscn")

var allegegner : Array[Node2D] = []
var wasdrin : bool = false

func _ready() -> void:
	
	feuerrate.start()
	
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if is_instance_valid(area):
		allegegner.append(area)
	
	wasdrin = true
	
	
	pass


func _on_area_2d_area_exited(area: Area2D) -> void:
	
	if is_instance_valid(area):
		allegegner.erase(area)
	
	
	if allegegner.is_empty():
		wasdrin = false
	
	pass


func shoot():
	
	var ladebullet : Area2D = bullet.instantiate()
	ladebullet.global_position = self.global_position
	var schussrichtung = (allegegner[0].global_position - self.global_position).normalized()
	ladebullet.richtung = schussrichtung
	get_tree().current_scene.get_node("kiste").add_child(ladebullet)
	
	
	pass


func _on_feuerrate_timeout() -> void:
	
	if wasdrin == false:
		return
	
	shoot()
	
	pass
