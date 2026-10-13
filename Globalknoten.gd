extends Node

### gegner begrenzen und level einfügen und bauhphase und erstes HUD


## den index erhöht bei der visibility bei der lifebar von enemy_one


@onready var mappool : Array[String] = ["res://Maps/map_one.tscn","res://Maps/map_two.tscn"]

@onready var towerpool : Array[String] = ["res://Tower/tower_one.tscn","res://Tower/tower_two.tscn"]

@onready var enemypool : Array[String] = ["res://Enemy/enemy_one.tscn"]

### Leben und so HUD
var life : int = 30

@warning_ignore("unused_signal")
signal upthud


### -------------------



### Gegner Zeug

var basespeed : float = 20

### ---------------------

### Runden und Bauphase
@warning_ignore("unused_signal")
signal starttheround
@warning_ignore("unused_signal")
signal turmwegstart
@warning_ignore("unused_signal")
signal kartegenommen
@warning_ignore("unused_signal")
signal neuecards

var kartegewahlt : bool = false

var aktuelle_runde : int = 1
var maxrunde : int = 5

var maxgegneranzahl : int = 30
var aktuellegegner : int = 0

var bauphase : bool = true
var rundelauft : bool = false
var gegnerkommen : bool = false
var finalerunde : bool = false

### -----------------------

func _ready() -> void:
	
	startsetup()
	
	
	pass

func startsetup():
	
	life = 30
	
	aktuelle_runde = 1
	maxrunde = 5
	
	maxgegneranzahl = 30
	aktuellegegner = 0
	
	bauphase = true
	rundelauft = false
	gegnerkommen = false
	finalerunde = false
	
	pass
