extends Node2D

class_name menuPrincipal

func _on_start_button_down():
	get_tree().change_scene_to_file("res://Escenas/Pantalla1A.tscn")

func _on_ajustes_button_down():
	get_tree().change_scene_to_file("res://Escenas/CambioDeColores.tscn")

func _on_entrenamiento_button_down():
	get_tree().change_scene_to_file("res://Escenas/PantallaEntrenamiento.tscn")
