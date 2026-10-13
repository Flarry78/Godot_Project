extends CanvasLayer

@onready var aktuellerunde: Label = $mainwindow/HUD/stats/aktuellerunde
@onready var punkte: Label = $mainwindow/HUD/stats/punkte
@onready var leben: Label = $mainwindow/HUD/stats/leben

### Karten

@onready var allekarten: Control = $mainwindow/allekarten

@onready var kartenanordnung: HBoxContainer = $mainwindow/allekarten/kartenanordnung


### --------------------





func _ready() -> void:
	
	updatehud()
	Globalknoten.upthud.connect(updatehud)
	Globalknoten.kartegenommen.connect(kartenauswahl)
	Globalknoten.neuecards.connect(neuekarten)
	allekarten.visible = false
	
	pass



func updatehud():
	
	aktuellerunde.text = "RUNDE: " + str(Globalknoten.aktuelle_runde)
	punkte.text = "PUNKTE: " + str("0")
	leben.text = "LEBEN: " + str(Globalknoten.life)
	
	if Globalknoten.life <= 0:
		get_tree().paused = true
	
	pass

func neuekarten():
	
	allekarten.visible = true
	
	pass


func kartenauswahl():
	
	allekarten.visible = false
	Globalknoten.kartegewahlt = true
	updatehud()
	
	pass


func _on_start_pressed() -> void:
	
	if Globalknoten.rundelauft == true:
		return
	
	Globalknoten.emit_signal("turmwegstart")
	Globalknoten.emit_signal("starttheround")
	
	
	pass
