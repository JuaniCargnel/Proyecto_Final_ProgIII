extends Node2D

func _on_start_button_down():
	get_tree().change_scene_to_file("res://Escenas/Pantalla1A.tscn")

func _process(_delta):
	$PersonajePrincipal/Sprite.modulate = Color($R.value, $G.value, $B.value)
	
	GlobalStats.colorR = $R.value
	GlobalStats.colorG = $G.value
	GlobalStats.colorB = $B.value
