extends CanvasLayer

func _ready():
	$SoundChange/Master.connect("value_changed", Callable(self, "_on_master_value_change"))
	$SoundChange/Master.value = GlobalStats.masterVolume 
	$SoundChange/Music.connect("value_changed", Callable(self, "_on_master_value_change"))
	$SoundChange/Music.value = GlobalStats.musicVolume 
	$SoundChange/SFX.connect("value_changed", Callable(self, "_on_master_value_change"))
	$SoundChange/SFX.value = GlobalStats.musicVolume 

func _process(_delta):
	if !visible:
		_on_1button_pressed()
		
	if get_tree().paused:
		visible = true
		
	if !GlobalStats.partidaComenzada:
		$Buttons/Menu.visible = false
		
	if Input.is_action_just_pressed("Pause") and GlobalStats.partidaComenzada:
		if get_tree().paused:
			get_tree().paused = false
			visible = false
		else:
			visible = true
			get_tree().paused = true
			$Buttons/Menu.visible = true
			
	$ColorChange/ColorPicker/Player.modulate = Color(GlobalStats.hexColor)

func _on_color_picker_color_changed(color):
	GlobalStats.hexColor = color

func _on_regresar_pressed():
	visible = false
	if get_tree().paused:
		get_tree().paused = false

func _on_1button_pressed():
	$MenuName.text = "AUDIO"
	$MenuName.position = Vector2(1020,310)
	$MenuName.scale = Vector2(1,1)
	$Buttons.position = Vector2(-3,105)
	$Window.scale = Vector2(2,1.5)
	$ColorChange.visible = false
	$SoundChange.visible = true
	$ControlsChange.visible = false

func _on_2button_pressed():
	if !GlobalStats.partidaComenzada:
		$MenuName.text = "COLOR CHANGE"
		$MenuName.position = Vector2(906,317)
		$MenuName.scale = Vector2(1,1)
		$Buttons.position = Vector2(-30,100)
		$Window.scale = Vector2(2,1.6)
		$ColorChange.visible = true
		$SoundChange.visible = false
		$ControlsChange.visible = false
	else:
		$MenuName.text = "YOU CAN'T CHANGE THE COLORS DURING THE GAME!"
		$MenuName.position = Vector2(930,450)
		$MenuName.size = Vector2(500,240)
		$MenuName.scale = Vector2(0.8,0.8)
		$Buttons.position = Vector2(88,-4)
		$Window.scale = Vector2(2,1.6)
		$ColorChange.visible = false
		$SoundChange.visible = false
		$ControlsChange.visible = false

func _on_3button_pressed():
	$MenuName.text = "CONTROLS"
	$MenuName.position = Vector2(1015,324)
	$MenuName.scale = Vector2(1,1)
	$Buttons.position = Vector2(-125,103)
	$Window.scale = Vector2(2,2)
	$ControlsChange.visible = true
	$ColorChange.visible = false
	$SoundChange.visible = false

func _on_menu_pressed():
	$Buttons/Menu.visible = false
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://Escenas/Menus/MenuPrincipal.tscn")

func _on_master_value_changed(value):
	GlobalStats.masterVolume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), GlobalStats.masterVolume)

func _on_music_value_changed(value):
	GlobalStats.musicVolume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), GlobalStats.musicVolume)

func _on_sfx_value_changed(value):
	GlobalStats.sfxVolume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), GlobalStats.sfxVolume)
