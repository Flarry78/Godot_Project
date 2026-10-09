extends Node2D

### Gegner
@onready var enemyebene: Node2D = $enemyebene
@onready var spawntimer: Timer = $spawntimer

var aktivepfade : Array[PathFollow2D] = []

### ---------------------------------

### Maps und Baunzonen und Pfade
@onready var mapebene: Node2D = $mapebene
var baumap : TileMapLayer = null
var baunummer : int = 1
var allewege : Array[Node] = []


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
	randomize()
	lademap()
	
	
	pass


func lademap():
	
	var randommap : String = Globalknoten.mappool.pick_random()
	var loading = load(randommap)
	var erstellemap = loading.instantiate()
	mapebene.add_child(erstellemap)
	allewege = erstellemap.wege.get_children()
	baumap = erstellemap.flache
	
	pass


func _process(delta: float) -> void:
	
	datenanzeige()
	
	ghosttower()
	
	pfadelaufen(delta)
	
	
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


func pfadelaufen(delta):
	
	var wegdamit : Array[PathFollow2D] = []
	
	for all in aktivepfade:
		if is_instance_valid(all):
			var pfadkind = all.get_child(0)
			if is_instance_valid(pfadkind):
				all.progress = all.progress + (Globalknoten.basespeed + pfadkind.speed) * delta
				if all.progress_ratio >= 0.99:
					if is_instance_valid(pfadkind):
						pfadkind.queue_free()
						wegdamit.append(all)
	
	for wech in wegdamit:
		aktivepfade.erase(wech)
		wech.queue_free()
	
	
	pass


func getpfad() -> PathFollow2D:
	
	var rndpfad = allewege.pick_random()
	var neuerpfad : PathFollow2D = PathFollow2D.new()
	rndpfad.add_child(neuerpfad)
	neuerpfad.rotates = false
	neuerpfad.rotation = 0
	
	return neuerpfad


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


func getgegner() -> Node2D:
	
	var rndenemy : String = Globalknoten.enemypool.pick_random()
	var erstellenemy : PackedScene = load(rndenemy)
	var ladeenemy : Node2D = erstellenemy.instantiate()
	
	return ladeenemy


func spawnenemy():
	
	var derpfad : PathFollow2D = getpfad()
	var derenemy : Node2D = getgegner()
	
	derpfad.add_child(derenemy)
	aktivepfade.append(derpfad)
	
	
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
	
	if event.is_action_pressed("spawn"):
		spawntimer.start()
	
	pass


func _on_spawntimer_timeout() -> void:
	
	spawnenemy()
	
	
	pass
