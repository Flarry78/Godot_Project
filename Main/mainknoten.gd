extends Node2D

### Maps und Baunzonen und Pfade
@onready var mapebene: Node2D = $mapebene
var baumap : TileMapLayer = null
var baunummer : int = 1


### ----------------------------------

### Tower und bauen
@onready var towerebene: Node2D = $towerebene

var bebauteplatze : Array[Vector2i] = []

var holdghost : Node2D = null

var ghostaktiv : bool = false
var ambauen : bool = false
var darfbauen : bool = false

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
	
	var randommap : String = Globalknoten.mappool.pick_random()
	var loading = load(randommap)
	var erstellemap = loading.instantiate()
	mapebene.add_child(erstellemap)
	baumap = erstellemap.flache
	
	pass


func _process(delta: float) -> void:
	
	
	datenanzeige()
	
	ghosttower()
	
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

func gettower():
	
	var tower = load(Globalknoten.towerpool.pick_random())
	var erstelletower = tower.instantiate()
	towerebene.add_child(erstelletower)
	holdghost = erstelletower
	
	pass

func bautower():
	
	var baucopy : Node2D = holdghost.duplicate()
	towerebene.add_child(baucopy)
	
	var mouse = get_global_mouse_position()
	var tile : Vector2i = baumap.local_to_map(mouse)
	
	for grose in holdghost.towergrose:
		grose += tile
		bebauteplatze.append(grose)
	
	holdghost.queue_free()
	
	print(bebauteplatze)
	
	pass


func ghosttower():
	
	if ghostaktiv == false:
		return
	var mouse = get_global_mouse_position()
	var tile : Vector2i = baumap.local_to_map(mouse)
	
	var tilenummer = baumap.get_cell_source_id(tile)
	
	
	var belegt : Array[Vector2i] = []
	
	for grose in holdghost.towergrose:
		grose += tile
		belegt.append(grose)
	var fastmitte : Vector2 = baumap.map_to_local(tile)
	var mitte : Vector2 = fastmitte + Vector2(8,8)
	holdghost.global_position = mitte
	
	
	if tilenummer == 2:
		darfbauen = true
	else:
		darfbauen = false
	
	
	pass



func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ESC"):
		get_tree().quit()
	
	if event.is_action_pressed("bauen"):
		if ghostaktiv == false:
			gettower()
			ghostaktiv = true
		elif ghostaktiv == true and darfbauen == true:
			ghostaktiv = false
			bautower()
	
	pass
