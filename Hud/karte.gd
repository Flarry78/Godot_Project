extends Control


@onready var k_rechts: ColorRect = $k_rechts
@onready var k_links: ColorRect = $k_links

@onready var kartenbild: TextureRect = $kartenbild

@onready var kartentext: RichTextLabel = $textfeld/kartentext

var holdreso : Resource


func _ready() -> void:
	
	farbe()
	
	pass


func farbe():
	
	var typfarbe_one = Color(0.706, 0.706, 0.706)
	
	var typfarbe_two = Color(0.979, 0.577, 0.56, 1.0)
	
	k_rechts.modulate = typfarbe_one
	
	k_links.modulate = typfarbe_two
	
	pass


func _on_button_pressed() -> void:
	
	print(self)
	print("Jaaa")
	Globalknoten.emit_signal("kartegenommen")
	
	
	pass
