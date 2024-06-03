extends Node2D

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Escenas/Niveles/Pantalla1A.tscn")

func _on_ajustes_pressed():
	get_tree().change_scene_to_file("res://Escenas/Menus/CambioDeColores.tscn")

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Escenas/Niveles/PantallaEntrenamiento.tscn")
