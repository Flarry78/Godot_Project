extends Node2D

### Gegner
@onready var enemyebene: Node2D = $enemyebene
@onready var spawntimer: Timer = $spawntimer

var aktivepfade : Array[PathFollow2D] = []

### ---------------------------------

### Maps und Baunzonen und Pfade
@onready var mapebene: Node2D = $mapebene
var baumap : TileMapLayer = null
var baunummer : int = 2
var allewege : Array[Node] = []
var alltiles : Dictionary = {}
var belegtetiles : Dictionary = {}

### ----------------------------------

### Tower und bauen
@onready var towerebene: Node2D = $towerebene

var holdghost : Node2D = null
var ghostzelle : Vector2i = Vector2i()

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
	Globalknoten.starttheround.connect(roundstart)
	Globalknoten.turmwegstart.connect(machweg)
	
	pass


func lademap():
	
	var randommap : String = Globalknoten.mappool.pick_random()
	var loading = load(randommap)
	var erstellemap = loading.instantiate()
	mapebene.add_child(erstellemap)
	allewege = erstellemap.wege.get_children()
	baumap = erstellemap.flache
	baugrid_aufbauen()
	
	pass

func roundstart():
	
	if Globalknoten.aktuelle_runde == Globalknoten.maxrunde:
		Globalknoten.finalerunde = true
		finale()
		return
	
	if Globalknoten.kartegewahlt == false and Globalknoten.aktuelle_runde >= 2:
		print("wähle eine karte")
		return
	
	Globalknoten.rundelauft = true
	Globalknoten.gegnerkommen = true
	spawntimer.start()
	Globalknoten.bauphase = false
	print("RUNDE: " + str(Globalknoten.aktuelle_runde))
	
	pass

func finale():
	
	print("FINALE")
	Globalknoten.rundelauft = true
	Globalknoten.gegnerkommen = true
	spawntimer.start()
	Globalknoten.bauphase = false
	
	pass


func baugrid_aufbauen() -> void:
	
	alltiles.clear()
	belegtetiles.clear()
	for zelle in baumap.get_used_cells_by_id(2):
		alltiles[zelle] = true
	
	pass


func _process(delta: float) -> void:
	
	datenanzeige()
	
	ghosttower()
	
	pfadelaufen(delta)
	
	beenderunde()
	
	pass

func machweg():
	
	ghostaktiv = false
	if holdghost != null:
		holdghost.queue_free()
		holdghost = null
	
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


func beenderunde():
	
	if Globalknoten.rundelauft == false:
		return
	
	if Globalknoten.gegnerkommen == true:
		return
	
	if aktivepfade.is_empty():
		if Globalknoten.life <= 0:
			return
		Globalknoten.aktuellegegner = 0
		Globalknoten.rundelauft = false
		Globalknoten.aktuelle_runde += 1
		Globalknoten.emit_signal("upthud")
		Globalknoten.bauphase = true
		Globalknoten.kartegewahlt = false
		Globalknoten.emit_signal("neuecards")
	
	pass


func pfadelaufen(delta):
	
	var wegdamit : Array[PathFollow2D] = []
	
	for all in aktivepfade:
		if is_instance_valid(all):
			if all.get_child_count() > 0:
				var pfadkind = all.get_child(0)
				if is_instance_valid(pfadkind):
					all.progress = all.progress + (Globalknoten.basespeed + pfadkind.speed) * delta
					if all.progress_ratio >= 0.99:
						if is_instance_valid(pfadkind):
							pfadkind.queue_free()
							wegdamit.append(all)
							Globalknoten.life -= 1
							Globalknoten.emit_signal("upthud")
			else:
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
	 
	for platz in holdghost.towergrose:
		platz += ghostzelle
		belegtetiles[platz] = holdghost
	
	holdghost.modulate = Color(1.0, 1.0, 1.0, 1.0)
	holdghost = null
	
	pass


func ghosttower():
	
	if ghostaktiv == false:
		return
	var mouse = baumap.get_global_mouse_position()
	var tile : Vector2i = baumap.local_to_map(mouse)
	ghostzelle = tile
	
	var center_sum = Vector2.ZERO
	var count = 0
	
	for offset in holdghost.towergrose:
		var current_tile = tile + offset
		center_sum += baumap.map_to_local(current_tile)
		count += 1
		
	var mitte_local = center_sum / count if count > 0 else baumap.map_to_local(tile)
	holdghost.global_position = baumap.to_global(mitte_local)
	
	darfbauen = true
	
	for platz in holdghost.towergrose:
		platz += tile
		if not alltiles.has(platz) or belegtetiles.has(platz):
			darfbauen = false
			break
	
	if darfbauen:
		holdghost.modulate = Color(0.0, 1.0, 0.0, 0.392)
	else:
		holdghost.modulate = Color(1.0, 0.0, 0.0, 0.392)
	
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
		if Globalknoten.bauphase == false:
			return
		elif ghostaktiv == false:
			gettower()
			ghostaktiv = true
		elif ghostaktiv == true and darfbauen == true:
			ghostaktiv = false
			bautower()
	
	pass


func _on_spawntimer_timeout() -> void:
	
	if Globalknoten.aktuellegegner < Globalknoten.maxgegneranzahl:
		spawnenemy()
		Globalknoten.aktuellegegner += 1
	else:
		spawntimer.stop()
		Globalknoten.gegnerkommen = false
	
	pass
