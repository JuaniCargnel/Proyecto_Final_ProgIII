extends Node2D

var speeds = [1, 1, 1, 1]
func _process(delta):
	cambio_de_fondo(delta)
	if speeds[3] <= 0.5:
		speeds[0] += 0.008
		if speeds[0] >= 1:
			speeds = [1, 1, 1, 1]
			for i in range(speeds.size()):
				$TileMap.set_layer_modulate(3 - i, Color(1, 1, 1, speeds[i]))

func cambio_de_fondo(delta):
	for i in range(speeds.size()):
		if i > 0 and speeds[i - 1] > 0:
			continue
		if speeds[i] > 0:
			speeds[i] -= delta * 0.2
			$TileMap.set_layer_modulate(3 - i, Color(1, 1, 1, speeds[i]))
		elif speeds[i] < 0:
			speeds[i] = 0

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Escenas/Niveles/Pantalla1A.tscn")

func _on_ajustes_pressed():
	get_tree().change_scene_to_file("res://Escenas/Menus/CambioDeColores.tscn")

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Escenas/Niveles/PantallaEntrenamiento.tscn")


func _on_timer_timeout():
	if $Title/Name0.modulate == Color(1,1,1):
		$Title/Name0.modulate = Color(0,0,0)
		$Title/Name1.modulate = Color(1,1,1)
		$Title/Name2.modulate = Color(0,0,0)
	elif $Title/Name1.modulate == Color(1,1,1):
		$Title/Name0.modulate = Color(0,0,0)
		$Title/Name1.modulate = Color(0,0,0)
		$Title/Name2.modulate = Color(1,1,1)
	else:
		$Title/Name0.modulate = Color(1,1,1)
		$Title/Name1.modulate = Color(0,0,0)
		$Title/Name2.modulate = Color(0,0,0)
