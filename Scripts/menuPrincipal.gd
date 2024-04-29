extends Node2D

class_name menuPrincipal

func _on_texture_button_button_down():
	get_tree().change_scene_to_file("res://Escenas/PantallaPrueba.tscn")
