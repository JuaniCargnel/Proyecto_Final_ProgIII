extends Node2D

# Primer "nivel" o arena del juego. Se instancian las escenas necesarias para el jugador y los pickups.

var player: PackedScene = preload("res://Escenas/Personajes/PersonajePrincipal.tscn")
var staminaPickUp: PackedScene = preload("res://Escenas/PickUps/StaminaPickUp.tscn")
var swordPickUp: PackedScene = preload("res://Escenas/PickUps/SwordPickUp.tscn")
var healthPickUp: PackedScene = preload("res://Escenas/PickUps/HealthPickUp.tscn")
var fireColumn: PackedScene = preload("res://Escenas/Globales/FireColumn.tscn")

var arrayPickUps = [healthPickUp, swordPickUp, staminaPickUp] 
var cameraZoom = 2
var colorPlayer = 0
var crossPortal = false

func _ready(): # Inicializa el primer nivel con las variables necesarias para su funcionamiento
	$MusicGameplay1.play()
	$AnimationPlayer.play("FadeIn")
	GlobalStats.maxPickUpsScreen = []
	instance_player()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	GlobalStats.enemyCounter = 0
	GlobalStats.maxEnemyCounter = 5
	GlobalStats.actualLevel = 1 
	GlobalStats.enemyLifeIncrement = 1
	GlobalStats.enemyDmgIncress = 1
	GlobalStats.maxSlimeVerde = 4
	GlobalStats.maxSlimeRojo = 3
	GlobalStats.maxSlimeMage = 2
	GlobalStats.playerWin = false
	
func _process(_delta): # Procesa el fade del player, el progreso de los niveles y la muerte del jugador
	var fadePlayer = get_tree().get_nodes_in_group("player")
	level_progress()
	
	for player1 in fadePlayer:
		player1.modulate = Color(1,1,1,colorPlayer)
		if player1.modulate != Color(1,1,1,1) and GlobalStats.alive and !crossPortal:
			colorPlayer += 0.005
			player1.modulate = Color(1,1,1,colorPlayer)
		elif !GlobalStats.alive and !GlobalStats.playerWin: 
			colorPlayer -= 0.005
			player1.modulate = Color(colorPlayer,colorPlayer,colorPlayer,colorPlayer)
		elif !GlobalStats.alive and crossPortal and GlobalStats.playerWin:
			colorPlayer -= 0.008
			player1.modulate = Color(colorPlayer,colorPlayer,colorPlayer,colorPlayer)
			
	player_death()

func instance_player(): # Instancia al player
	add_child(player.instantiate())

func player_death(): # Funcion de la muerte del player
	if !GlobalStats.alive and !GlobalStats.playerWin:
		cameraZoom += 0.05
		$Camera2D.global_position = GlobalStats.positionPlayer
		$Camera2D.zoom = Vector2(cameraZoom, cameraZoom)
		$MusicGameplay1.stop()
		$MusicGameplay2.stop()
		$AnimationPlayer.play("FadeOut")
		$HUD.visible = false

func level_progress(): # Sistema de progreso de nivel. Cambia las variables globales de los enemigos, actualiza el nivel y le deja al jugador elegir mejorar un stat
	if GlobalStats.enemyCounter >= GlobalStats.maxEnemyCounter and GlobalStats.actualLevel == 1:
		GlobalStats.selectStatistic = true
		GlobalStats.enemyCounter = 0
		GlobalStats.maxEnemyCounter = 7
		GlobalStats.actualLevel = 2
		GlobalStats.enemyLifeIncrement = 1.15
		GlobalStats.enemyDmgIncress = 1.1
		$StatSelect.visible = true
		get_tree().paused = true
	elif GlobalStats.enemyCounter >= GlobalStats.maxEnemyCounter and GlobalStats.actualLevel == 2:
		GlobalStats.selectStatistic = true
		GlobalStats.enemyCounter = 0
		GlobalStats.maxEnemyCounter = 9
		GlobalStats.actualLevel = 3
		GlobalStats.enemyLifeIncrement = 1.25
		GlobalStats.enemyDmgIncress = 1.15
		$StatSelect.visible = true
		get_tree().paused = true
	elif GlobalStats.enemyCounter >= GlobalStats.maxEnemyCounter and GlobalStats.actualLevel == 3:
		GlobalStats.selectStatistic = true
		GlobalStats.enemyCounter = 0
		GlobalStats.actualLevel = 4
		GlobalStats.enemyLifeIncrement = 1.35
		GlobalStats.enemyDmgIncress = 1.2
		$StatSelect.visible = true
		get_tree().paused = true
		GlobalStats.maxSlimeVerde = 8
		GlobalStats.maxSlimeRojo = 5
		GlobalStats.maxSlimeMage = 4
	elif GlobalStats.enemyCounter >= GlobalStats.maxEnemyCounter and GlobalStats.actualLevel == 4:
		GlobalStats.selectStatistic = true
		GlobalStats.enemyCounter = 0
		GlobalStats.maxEnemyCounter = 11
		GlobalStats.actualLevel = 5
		GlobalStats.enemyLifeIncrement = 1.50
		GlobalStats.enemyDmgIncress = 1.25
		$StatSelect.visible = true
		get_tree().paused = true
	elif GlobalStats.enemyCounter >= GlobalStats.maxEnemyCounter and GlobalStats.actualLevel == 5:
		GlobalStats.selectStatistic = true
		GlobalStats.enemyCounter = 0
		GlobalStats.actualLevel = 6
		GlobalStats.enemyLifeIncrement = 1.75
		GlobalStats.enemyDmgIncress = 1.5
		$StatSelect.visible = true
		get_tree().paused = true
		GlobalStats.maxSlimeVerde = 10
		GlobalStats.maxSlimeRojo = 8
		GlobalStats.maxSlimeMage = 6
	elif GlobalStats.enemyCounter >= GlobalStats.maxEnemyCounter and GlobalStats.actualLevel == 6:
		GlobalStats.playerWin = true
		GlobalStats.alive = false
		$Portal.visible = true
		$Portal.set_process_mode(Node.PROCESS_MODE_INHERIT)

func _on_music_gameplay_finished(): # Loopea los dos temas musicales 
	$MusicGameplay2.play()

func _on_music_gameplay_2_finished():
	$MusicGameplay1.play()

func _on_area_2d_body_entered(body): # Portal de salida del nivel al terminar el nivel 6
	if body.is_in_group("player"):
		crossPortal = true
		$HUD.visible = false
		$AnimationPlayer.play("FadeOutFast")

func _on_animation_player_animation_finished(anim_name): # Al terminar la animacion del fadeout, cambia a la escena del win
	if anim_name == "FadeOutFast":
		get_tree().change_scene_to_file("res://Escenas/Menus/Win.tscn")

func _on_pick_up_timer_timeout(): # Genera un pickup 
	#var x = randi_range(-$Area2D/CollisionShape2D.shape.extents.x, $Area2D/CollisionShape2D.shape.extents.x)
	#var y = randf_range(-$Area2D/CollisionShape2D.shape.extents.y, $Area2D/CollisionShape2D.shape.extents.y)
	
	var x = randi_range(810, 1220)
	var y = randf_range(370, 785)
	
	if GlobalStats.maxPickUpsScreen.size() < 5 and !GlobalStats.playerWin: # Genera un pickup aleatorio hasta un maximo de 5 en el array
		var pickupIndex = randi() % arrayPickUps.size()
		var pickupInstance = arrayPickUps[pickupIndex].instantiate()
		add_child(pickupInstance)
		pickupInstance.global_position = Vector2(x,y) 
		GlobalStats.maxPickUpsScreen.append(pickupInstance)

# En lo posible, ambos lados. Tambien que con lo snivele baje el tiempo 
# En el que sale. 
func _on_timer_timeout():
	$Node2D2/Sprite.play("Ataque")
	var tiempo
	
	if GlobalStats.actualLevel <= 2:
		tiempo = randi_range(7, 10)
	elif GlobalStats.actualLevel > 2 and GlobalStats.actualLevel <= 4:
		tiempo = randi_range(5, 7)
	elif GlobalStats.actualLevel > 4 and GlobalStats.actualLevel <= 6:
		tiempo = randi_range(3, 5)
	
	$Node2D2/Timer.set_wait_time(tiempo)
	print($Node2D2/Timer.get_wait_time())

func _on_timer_2_timeout():
	$Node2D/Sprite.play("Ataque")
	var tiempo
	
	if GlobalStats.actualLevel <= 2:
		tiempo = randi_range(7, 10)
	elif GlobalStats.actualLevel > 2 and GlobalStats.actualLevel <= 4:
		tiempo = randi_range(5, 7)
	elif GlobalStats.actualLevel > 4 and GlobalStats.actualLevel <= 6:
		tiempo = randi_range(3, 5)
	
	$Node2D/Timer2.set_wait_time(tiempo)
	print($Node2D/Timer2.get_wait_time())


func _on_sprite_animation_looped():
	if $Node2D2/Sprite.get_animation() == "Ataque":
		$Node2D2/Sprite.play("Idle")

func _on_sprite_frame_changed():
	if $Node2D2/Sprite.get_animation() == "Ataque" and $Node2D2/Sprite.frame == 8:
		var y = randf_range(365, 738)
		var fireColumnInstance = fireColumn.instantiate()
		add_child(fireColumnInstance)
		fireColumnInstance.global_position = Vector2(750,y)
		fireColumnInstance.movimiento = 1




func _on_sprite_animation_looped_2():
	if $Node2D/Sprite.get_animation() == "Ataque":
		$Node2D/Sprite.play("Idle")


func _on_sprite_frame_changed_2():
	if $Node2D/Sprite.get_animation() == "Ataque" and $Node2D/Sprite.frame == 8:
		var y = randf_range(365, 738)
		var fireColumnInstance = fireColumn.instantiate()
		add_child(fireColumnInstance)
		fireColumnInstance.global_position = Vector2(1135,y)
		fireColumnInstance.movimiento = -1
