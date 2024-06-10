extends Node2D

var speeds = [1, 1, 1, 1]

func _ready():
	GlobalStats.partidaComenzada = false
	$Title/Name1.modulate = GlobalStats.hexColor
	$MusicaMenu.set_volume_db(GlobalStats.musicVolume)

func _process(delta):
	$ParallaxBackground/Player.modulate = GlobalStats.hexColor
	cambio_de_fondo(delta)
	if speeds[3] <= 0.5:
		speeds[0] += 0.008
		if speeds[0] >= 1:
			speeds = [1, 1, 1, 1]
			for i in range(speeds.size()):
				$ParallaxBackground/TileMap.set_layer_modulate(3 - i, Color(1, 1, 1, speeds[i]))

func cambio_de_fondo(delta):
	for i in range(speeds.size()):
		if i > 0 and speeds[i - 1] > 0:
			continue
		if speeds[i] > 0:
			speeds[i] -= delta * 0.2
			$ParallaxBackground/TileMap.set_layer_modulate(3 - i, Color(1, 1, 1, speeds[i]))
		elif speeds[i] < 0:
			speeds[i] = 0
	
func _on_start_pressed():
	$AnimationPlayer.get_animation("fade").track_set_key_value(1,0,GlobalStats.musicVolume)
	$AnimationPlayer.play("fade")
	$Buttons/StartButton/Start.disabled = true
	$Buttons/AjustesButton/Ajustes.disabled = true
	$Buttons/ExitButton/Exit.disabled = true
	$Buttons/CreditsButton/Credits.disabled = true
	$FadeTimer.start()
	
func _on_ajustes_pressed():
	$Ajustes.visible = true

func _on_exit_pressed():
	get_tree().quit()

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Escenas/Menus/Credits.tscn")

func _on_timer_timeout():
	if $Title/Name0.modulate == Color(GlobalStats.hexColor):
		$Title/Name0.modulate = Color(0,0,0)
		$Title/Name1.modulate = Color(GlobalStats.hexColor)
		$Title/Name2.modulate = Color(0,0,0)
	elif $Title/Name1.modulate == Color(GlobalStats.hexColor):
		$Title/Name0.modulate = Color(0,0,0)
		$Title/Name1.modulate = Color(0,0,0)
		$Title/Name2.modulate = Color(GlobalStats.hexColor)
	else:
		$Title/Name0.modulate = Color(GlobalStats.hexColor)
		$Title/Name1.modulate = Color(0,0,0)
		$Title/Name2.modulate = Color(0,0,0)

func _on_fade_timer_timeout():
	get_tree().change_scene_to_file("res://Escenas/Niveles/Pantalla1A.tscn")

func _on_musica_menu_finished():
	$MusicaMenu.play()

func _on_start_mouse_entered():
	if !$Buttons/StartButton/Start.disabled:
		$SFXButtons.play()

func _on_credits_mouse_entered():
	if !$Buttons/CreditsButton/Credits.disabled:
		$SFXButtons.play()

func _on_exit_mouse_entered():
	if !$Buttons/ExitButton/Exit.disabled:
		$SFXButtons.play()

func _on_ajustes_mouse_entered():
	if !$Buttons/AjustesButton/Ajustes.disabled:
		$SFXButtons.play()
