extends CanvasLayer

# Variable para determinar el fullscreen
var fullscreen = false

func _process(_delta): # El process de los ajustes
	if !visible: # Si no esta visible, siempre tiene que estar con el modificador de sonido como primera pestaña
		_on_1button_pressed()
		
	if get_tree().paused and !GlobalStats.selectStatistic: # Si el juego esta pausado y no esta el otro menu, tiene que estar visible
		visible = true
		
	if !GlobalStats.partidaComenzada: # Si no esta la partida comenzada, el boton de volver al menu no debe estar
		$Buttons/Menu.visible = false
		
	if Input.is_action_just_pressed("Pause") and GlobalStats.partidaComenzada: # El boton de pausa para cuando la partida este comenzada
		if get_tree().paused:
			get_tree().paused = false
			visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		else:
			visible = true
			get_tree().paused = true
			$Buttons/Menu.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	# Los valores de las barras de sonido se igualan al volumen del Bus
	$SoundChange/Music.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	$SoundChange/SFX.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	$SoundChange/Master.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$ColorChange/ColorPicker/Player.modulate = Color(GlobalStats.hexColor)

func _on_color_picker_color_changed(color): # Color Picker para el player
	GlobalStats.hexColor = color
  
func _on_regresar_pressed(): # Regresar al menu anterior o pantalla de juego
	visible = false
	if get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_tree().paused = false

func _on_1button_pressed(): # Menu de audio
	$Name/MenuName.text = "AUDIO"
	$Name/MenuName.position = Vector2(1035,325)
	$Name/MenuName.scale = Vector2(1,1)
	$Buttons.position = Vector2(-3,105)
	$Window.scale = Vector2(2,1.5)
	$ColorChange.visible = false
	$SoundChange.visible = true
	$ControlsChange.visible = false

func _on_2button_pressed(): # Menu de cambio de color
	if !GlobalStats.partidaComenzada:
		$Name/MenuName.text = "COLOR CHANGE"
		$Name/MenuName.position = Vector2(906,317)
		$Name/MenuName.scale = Vector2(1,1)
		$Buttons.position = Vector2(-30,100)
		$Window.scale = Vector2(2,1.6)
		$ColorChange.visible = true
		$SoundChange.visible = false
		$ControlsChange.visible = false
	else:
		$Name/MenuName.text = "YOU CAN'T CHANGE THE COLORS DURING THE GAME!"
		$Name/MenuName.position = Vector2(930,450)
		$Name/MenuName.size = Vector2(500,240)
		$Name/MenuName.scale = Vector2(0.8,0.8)
		$Buttons.position = Vector2(-30,100)
		$Window.scale = Vector2(2,1.6)
		$ColorChange.visible = false
		$SoundChange.visible = false
		$ControlsChange.visible = false

func _on_3button_pressed(): # Menu de controles
	$Name/MenuName.text = "CONTROLS"
	$Name/MenuName.position = Vector2(1015,324)
	$Name/MenuName.scale = Vector2(1,1)
	$Buttons.position = Vector2(-125,103)
	$Window.scale = Vector2(2,2)
	$ControlsChange.visible = true
	$ColorChange.visible = false
	$SoundChange.visible = false

func _on_menu_pressed(): # Boton para regresar al menu
	$Buttons/Menu.visible = false
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://Escenas/Menus/MenuPrincipal.tscn")

func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)

func _on_button_mouse_entered(): # Reproduce un sonido para todos los botones
	$SFXButtons.play()

func _on_full_screen_button_down(): # Boton de fullscreen
	if !fullscreen:
		fullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif fullscreen: 
		fullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
