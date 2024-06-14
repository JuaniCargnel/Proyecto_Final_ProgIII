extends CanvasLayer

# Pantalla de seleccion de estadisticas. Se ejecuta al subir un nivel y sube la estadistica decidida.

func _process(_delta):
	if GlobalStats.selectStatistic:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_mouse_entered():
	$SFXButtons.play()

func _on_sword_time_pressed():
	GlobalStats.maxSwordTime += 5
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GlobalStats.selectStatistic = false

func _on_max_stamina_pressed():
	GlobalStats.maxStamina += 75
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GlobalStats.selectStatistic = false

func _on_max_life_pressed():
	GlobalStats.maxLife += 7
	if GlobalStats.playerLife + 7 > GlobalStats.maxLife:
			GlobalStats.playerLife = GlobalStats.maxLife
	else: 
		GlobalStats.playerLife += 7
	
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GlobalStats.selectStatistic = false

func _on_damage_pressed():
	GlobalStats.playerDmgIncress += 0.5
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GlobalStats.selectStatistic = false

func _on_regen_stamina_pressed():
	GlobalStats.regenStamina += 0.2
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GlobalStats.selectStatistic = false
