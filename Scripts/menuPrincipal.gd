extends Node2D

func _on_start_button_down():
	get_tree().change_scene_to_file("res://Escenas/Niveles/Pantalla1A.tscn")

func _on_ajustes_button_down():
	get_tree().change_scene_to_file("res://Escenas/Menus/CambioDeColores.tscn")

func _on_entrenamiento_button_down():
	get_tree().change_scene_to_file("res://Escenas/Niveles/PantallaEntrenamiento.tscn")
