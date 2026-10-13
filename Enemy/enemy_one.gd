extends Node2D

@onready var lifebar: ProgressBar = $lifebar

@onready var speed : float = 60
@onready var leben : float = 3000

func _ready() -> void:
	
	setup()
	
	
	pass

func setup():
	
	lifebar.max_value = leben
	lifebar.value = leben
	
	
	pass


func getdmg(schaden):
	
	leben -= schaden
	if leben <= 0:
		queue_free()
		return
	
	updatelife()
	
	pass

func updatelife():
	
	lifebar.value = leben
	
	
	pass
