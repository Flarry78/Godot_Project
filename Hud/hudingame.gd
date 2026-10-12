extends CanvasLayer


@onready var aktuellerunde: Label = $mainwindow/HUD/Control/aktuellerunde
@onready var punkte: Label = $mainwindow/HUD/Control/punkte
@onready var leben: Label = $mainwindow/HUD/Control/leben


func _ready() -> void:
	
	updatehud()
	Globalknoten.upthud.connect(updatehud)
	
	pass


func updatehud():
	
	aktuellerunde.text = "RUNDE: " + str(Globalknoten.aktuelle_runde)
	punkte.text = "PUNKTE: " + str("0")
	leben.text = "LEBEN: " + str(Globalknoten.life)
	
	pass



func _on_start_pressed() -> void:
	
	if Globalknoten.rundelauft == true:
		return
	
	Globalknoten.emit_signal("turmwegstart")
	Globalknoten.emit_signal("starttheround")
	
	
	pass
