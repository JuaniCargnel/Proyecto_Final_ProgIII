extends Node2D

func _ready():
	var nodos = get_tree().get_nodes_in_group("nodo")
	for sprites in nodos:
		Sombra.crear_sombras(sprites)

func _process(_delta):
	Sombra.update_sombras()
	GlobalManager.render()

func _on_start_button_down():
	get_tree().change_scene_to_file("res://Escenas/Pantalla1A.tscn")
