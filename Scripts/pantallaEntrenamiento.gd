extends Node2D

func _process(_delta):
	GlobalManager.render()

func _on_start_button_down():
	get_tree().change_scene_to_file("res://Escenas/Niveles/Pantalla1A.tscn")
