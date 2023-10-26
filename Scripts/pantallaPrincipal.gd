extends Node2D


func _process(_delta):
	
	if Input.is_action_pressed("Tab"):
		get_tree().change_scene_to_file("res://Proyecto_Final_ProgIII/Escenas/PantallaPrueba.tscn")
	
