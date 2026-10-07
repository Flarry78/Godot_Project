extends Node2D

### Maps und Baunzonen und Pfade
@onready var mapebene: Node2D = $mapebene
var baumap : TileMapLayer = null


### ----------------------------------

### Tower
@onready var towerebene: Node2D = $towerebene

### ----------------------------------

### Leistung Anzeige
@onready var fps: Label = $leistung/fps
@onready var cpu: Label = $leistung/cpu
@onready var ram: Label = $leistung/ram
@onready var nodes: Label = $leistung/nodes
### -----------------------------------

func _ready() -> void:
	
	lademap()
	
	
	pass


func lademap():
	
	var randommap = Globalknoten.mappool.pick_random()
	var loading = load(randommap)
	var erstellemap = loading.instantiate()
	mapebene.add_child(erstellemap)
	baumap = erstellemap.flache
	
	pass


func _process(delta: float) -> void:
	
	
	datenanzeige()
	
	
	pass


func datenanzeige() -> void:
	
	var fpspro = Engine.get_frames_per_second()
	var memory = Performance.get_monitor(Performance.MEMORY_STATIC) / 1024 / 1024
	var cpupro = Performance.get_monitor(Performance.TIME_PROCESS) * 100
	
	fps.text = "FPS " + str(fpspro)
	cpu.text = "CPU " + str(cpupro)
	ram.text = "RAM " +  str(memory)
	nodes.text = "ALLNODES " + str(get_tree().get_node_count())
	
	pass


func bautower():
	
	var mouse = get_global_mouse_position()
	
	
	var tower = load(Globalknoten.towerpool.pick_random())
	var erstelletower = tower.instantiate()
	towerebene.add_child(erstelletower)
	erstelletower.global_position = mouse
	
	
	pass


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ESC"):
		get_tree().quit()
	
	if event.is_action_pressed("bauen"):
		bautower()
	
	pass
