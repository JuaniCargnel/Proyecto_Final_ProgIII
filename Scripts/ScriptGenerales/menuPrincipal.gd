extends Node2D

# Menu principal. Ejecuta un parallax de una ciudad destruida y una animacion del player corriendo. Al cambiar el color tambien lo cambia del titulo y del player corriendo
# Las funciones y partes del codigo comentados son para la implementacion de una pantalla tutorial

var speeds = [1, 1, 1, 1]
var tutorial = false
var play = false

func _ready():
	GlobalStats.partidaComenzada = false
	$Title/Name1.modulate = GlobalStats.hexColor
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AnimationPlayer.play("intro")

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
	#if $Buttons/Play.visible:
		#$Buttons/Play.visible = false
		#$Buttons/Tutorial.visible = false
	#else:
		#$Buttons/Play.visible = true
		#$Buttons/Tutorial.visible = true
	$AnimationPlayer.play("fade")
	$Music_SFX/StartGame.play()
	$Buttons/StartButton/Start.disabled = true
	$Buttons/Play/Play.disabled = true
	$Buttons/Tutorial/Tutorial.disabled = true
	$Buttons/AjustesButton/Ajustes.disabled = true
	$Buttons/ExitButton/Exit.disabled = true
	$Buttons/CreditsButton/Credits.disabled = true
	$FadeTimer.start()

func _on_ajustes_pressed():
	$Ajustes.visible = true

func _on_exit_pressed():
	get_tree().quit()

func _on_credits_pressed():
	$Credits.visible = true

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
	#if tutorial:
		#get_tree().change_scene_to_file("res://Escenas/Niveles/PantallaEntrenamiento.tscn")
	#elif play:
		#get_tree().change_scene_to_file("res://Escenas/Niveles/Pantalla1A.tscn")

func _on_musica_menu_finished():
	$Music_SFX/MusicaMenu.play()

func _on_button_mouse_entered():
	if !$Buttons/StartButton/Start.disabled:
		$Music_SFX/SFXButtons.play()

func _on_play_pressed():
	#play = true
	#$AnimationPlayer.play("fade")
	#$Music_SFX/StartGame.play()
	#$Buttons/StartButton/Start.disabled = true
	#$Buttons/Play/Play.disabled = true
	#$Buttons/Tutorial/Tutorial.disabled = true
	#$Buttons/AjustesButton/Ajustes.disabled = true
	#$Buttons/ExitButton/Exit.disabled = true
	#$Buttons/CreditsButton/Credits.disabled = true
	#$FadeTimer.start()
	pass

func _on_tutorial_pressed():
	#tutorial = true
	#$AnimationPlayer.play("fade")
	#$Music_SFX/StartGame.play()
	#$Buttons/StartButton/Start.disabled = true
	#$Buttons/AjustesButton/Ajustes.disabled = true
	#$Buttons/Play/Play.disabled = true
	#$Buttons/Tutorial/Tutorial.disabled = true
	#$Buttons/ExitButton/Exit.disabled = true
	#$Buttons/CreditsButton/Credits.disabled = true
	#$FadeTimer.start()
	pass
