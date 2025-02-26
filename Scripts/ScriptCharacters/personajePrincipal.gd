extends CharacterBody2D

# Variables de animacion 
var animRoll: bool = false
var animRun: bool = false
var animIdle: bool = true
var animHitA: bool = false
var animHitB: bool = false
var animDmg: bool = false
var animDeath: bool = false

# Variables de acciones
var canRoll: bool = true
var canHitB: bool = true
var canHitA: bool = true
var comboA: bool = false
var comboB: bool = false

# Variables generales
var lookDerecha: bool = true
var vidaAnterior = GlobalStats.playerLife
var direccion = Vector2()
var valorTmpRoll = Vector2()

########################################################################################
#################################  CONTROL GENERAL  ####################################
########################################################################################

func _ready(): # Seteo de variables globales al instanciar al jugador (En caso de querer mantenerlas por nivel, CORREGIR)
	GlobalStats.playerLife = 15
	GlobalStats.playerDmgIncress = 0
	GlobalStats.maxLife = 15
	GlobalStats.playerStamina = 500
	GlobalStats.maxStamina = 500
	GlobalStats.regenStamina = 0.5
	GlobalStats.swordTime = 0
	GlobalStats.maxSwordTime = 15
	GlobalStats.recibirDanio = false
	GlobalStats.activeSword = false
	GlobalStats.alive = true
	GlobalStats.playerLife = GlobalStats.maxLife
	GlobalStats.playerStamina = GlobalStats.maxStamina
	GlobalStats.partidaComenzada = true
	$Sprite.modulate = Color(GlobalStats.hexColor)
	$Sprite.material.set_shader_parameter("modulate_color", modulate)
	Sombra.crear_sombras($Sprite, $SombraMark)
	global_position = Vector2(1000,550)

func _process(delta): # Process del jugador - Si esta vivo - Si gano y no esta vivo (Provisorio) - Si murio
	if GlobalStats.alive:
		GlobalStats.positionPlayer = global_position
		z_index = round(global_position.y)
		regen_stamina()
		estados(delta)
		animations()
	elif !GlobalStats.alive and GlobalStats.playerWin:
		regen_stamina()
		estados(delta)
		animations()
		
	Sombra.update_sombras() # Update de las sombras para seguir las animaciones 

func estados(delta): # Funcion de control de estados
	active_sword()
	rolling()
	movimientos(delta)
	walking()
	running()
	hitting()
	recibir_dmg()
	player_death()

func movimientos(delta): # Movimiento del player segun su estado
	if animRun:
		translate(direccion.normalized() * GlobalStats.velRun * delta)
	elif animRoll:
		translate(direccion.normalized() * GlobalStats.velRoll * delta)
	else: 
		translate(direccion.normalized() * GlobalStats.velWalk * delta)
		
	move_and_slide()

func animations(): # Controlador de animaciones
	var animationName = get_animation_name()
	$Sprite.play(animationName)

func get_animation_name(): # "Maquina de estados" - Mejorar en un futuro utilizando animation player
	if animDeath:
		return "death"
	elif animHitA:
		if GlobalStats.activeSword:
			GlobalStats.animacion = 5.1
			return "swordAttack"
		else: 
			GlobalStats.animacion = 5
			return "jab"
	elif animHitB:
		if GlobalStats.activeSword:
			GlobalStats.animacion = 4.1
			return "swordStab"
		else:
			GlobalStats.animacion = 4
			return "cross"
	elif animDmg:
		GlobalStats.animacion = 7
		return "damage"
	elif animRun:
		if GlobalStats.activeSword:
			GlobalStats.animacion = 3.1
			return "swordRun"
		else:
			GlobalStats.animacion = 3
			return "run"
	elif animRoll:
		GlobalStats.animacion = 6
		return "roll"
	elif direccion != Vector2.ZERO and not animRoll and not animRun:
		if GlobalStats.activeSword:
			GlobalStats.animacion = 2.1
			return "swordWalk"
		else: 
			GlobalStats.animacion = 2
			return "walk"
	else:
		if GlobalStats.activeSword:
			animIdle = true
			GlobalStats.animacion = 1.1
			return "swordIdle"
		else:
			animIdle = true
			GlobalStats.animacion = 1
			return "idle"

########################################################################################
###############################  ACCIONES DEL PLAYER  ##################################
########################################################################################

func walking(): # Caminar y controles
	var input_x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var input_y = Input.get_action_strength("Down") - Input.get_action_strength("Up")

	if $Sprite.get_animation() == "walk":  # Controlador del sonido de los pasos
		$SFX/Pasos.set_pitch_scale(1.5)
		if $Timers/Steps.time_left <= 0:
			$Timers/Steps.start()
	elif !$Sprite.get_animation() == "walk" and !$Sprite.get_animation() == "run":
		$Timers/Steps.stop()
		
	if !animHitA: # Evita el movimiento durante el golpe
		if !animHitB:
			if Input.is_action_pressed("Right"):
				$Sprite.set_flip_h(false)
				$Hitbox.position = Vector2(-1,11)
				$DmgArea/CollisionShape2D.position = Vector2(-1,11)
				lookDerecha = true
			if Input.is_action_pressed("Left"):
				$Sprite.set_flip_h(true)
				$Hitbox.position = Vector2(1,11)
				$DmgArea/CollisionShape2D.position = Vector2(1,11)
				lookDerecha = false
				
	direccion = Vector2(input_x, input_y)

func running(): # Correr - Al igual que rodar y golpear, se puede hacer si y solo si no se cumplen las condiciones esas (A mejorar con animation player en un futuro)
	if Input.is_action_pressed("Correr") and not animRoll and not animHitA and not animHitB and direccion != Vector2.ZERO and GlobalStats.playerStamina > 1:
		animRun = true
		GlobalStats.playerStamina -= 1
		
		if $Sprite.get_animation() == "run": # Controlador del sonido de los pasos
			$SFX/Pasos.set_pitch_scale(1.25)
			if $Timers/Steps.time_left <= 0:
				$Timers/Steps.start()
		elif !$Sprite.get_animation() == "walk" and !$Sprite.get_animation() == "run":
			$Timers/Steps.stop()
		
	elif GlobalStats.playerStamina <= 1: # Niega correr en caso de no tener stamina, suelta el boton para evitar posibles errores
		Input.action_release("Correr")
	else: 
		animRun = false

func rolling(): # Rodar
	if Input.is_action_pressed("Roll") and canRoll and not animHitA and not animHitB and direccion != Vector2.ZERO and GlobalStats.playerStamina > 101:
		animRoll = true
		canRoll = false
		valorTmpRoll = direccion
		$Timers/Roll.start()
		$DmgArea/CollisionShape2D.disabled = true
		GlobalStats.playerStamina -= 100
		$SFX/Roll.play()
	elif animRoll: # Gestion de combos (Los combos son las acciones instantaneas luego de realizar una accion)
		if Input.is_action_pressed("GolpeA"):
			comboA = true
		if Input.is_action_pressed("GolpeB"):
			comboB = true
		direccion = valorTmpRoll # Evita rolles estaticos y cambios de direcciones
	else: 
		$DmgArea/CollisionShape2D.disabled = false
		animRoll = false
		valorTmpRoll = null

func hitting(): # Golpear - Controla todos los tipos de golpes
	if Input.is_action_pressed("GolpeA") and canHitA and not animRoll and not animHitB and GlobalStats.playerStamina > 21:
		animHitA = true
		canHitA = false
		GlobalStats.playerStamina -= 20
		$Timers/HitA.start()
		if GlobalStats.activeSword:
			$SFX/Hit1S.play()
		else: 
			$SFX/Hit1.play()
	elif Input.is_action_pressed("GolpeB") and canHitB and not animRoll and not animHitA and GlobalStats.playerStamina > 51:
		animHitB = true
		canHitB = false
		GlobalStats.playerStamina -= 50
		$Timers/HitB.start()
		if GlobalStats.activeSword:
			$SFX/Hit2S.play()
		else: 
			$SFX/Hit2.play()
	elif animHitA: # Modifica la collision shape segun el tipo de golpe 
		direccion = Vector2.ZERO
		if GlobalStats.activeSword:
			$HittingArea/HitboxHit.scale = Vector2(2.5,4)
			if $Sprite.frame == 3:
				$HittingArea/HitboxHit.disabled = false
			if lookDerecha:
				$HittingArea/HitboxHit.position = Vector2(20,1.5)
			else:
				$HittingArea/HitboxHit.position = Vector2(-20,1.5)
		elif !GlobalStats.activeSword:
			$HittingArea/HitboxHit.scale = Vector2(2,0.5)
			if $Sprite.frame == 1:
				$HittingArea/HitboxHit.disabled = false
			if lookDerecha:
				$HittingArea/HitboxHit.position = Vector2(13,-0.5)
			else:
				$HittingArea/HitboxHit.position = Vector2(-13,-0.5)
		if Input.is_action_pressed("GolpeB"):
			comboB = true
	elif animHitB:
		direccion = Vector2.ZERO
		if GlobalStats.activeSword:
			if $Sprite.frame == 3:
				$HittingArea/HitboxHit.disabled = false
			$HittingArea/HitboxHit.scale = Vector2(4,1)
			if lookDerecha:
				$HittingArea/HitboxHit.position = Vector2(21.6,1.4)
			else:
				$HittingArea/HitboxHit.position = Vector2(-21.6,1.4)
		elif !GlobalStats.activeSword:
			if $Sprite.frame == 3:
				$HittingArea/HitboxHit.disabled = false
			$HittingArea/HitboxHit.scale = Vector2(2,2)
			if lookDerecha:
				$HittingArea/HitboxHit.position = Vector2(18.6,2.5)
			else:
				$HittingArea/HitboxHit.position = Vector2(-18.6,2.5)
	else:
		animHitB = false
		animHitA = false
		$HittingArea/HitboxHit.disabled = true

func player_death(): # Muerte del jugador si no tiene mas vida (En la barra se confunde cuando tiene porcentajes muy pequeños debido al tamaño)
	if GlobalStats.playerLife <= 0:
		GlobalStats.alive = false
		GlobalStats.partidaComenzada = false
		animDeath = true
		$Sprite.material.set_shader_parameter("flicker_enabled", false)
		$SFX/Death.play()

func recibir_dmg(): #  Al recibir un golpe emite un sonido (Vida anterior se utiliza para que el sonido no suene en bucle)
	if GlobalStats.recibirDanio:
		if GlobalStats.playerLife < vidaAnterior:
			$SFX/Dmg.play()
			
		vidaAnterior = GlobalStats.playerLife
		animDmg = true
		$Sprite.material.set_shader_parameter("flicker_enabled", true)
	elif !GlobalStats.recibirDanio and $Sprite.frame == 2:
		$Sprite.material.set_shader_parameter("flicker_enabled", false)
		animDmg = false

func regen_stamina(): # Regenera Stamina
	if GlobalStats.playerStamina < GlobalStats.maxStamina:
		GlobalStats.playerStamina += GlobalStats.regenStamina

func active_sword(): # Controla el tiempo de la espada activa
	if GlobalStats.activeSword:
		$Timers/SwordTimer.set_wait_time(GlobalStats.maxSwordTime)
		
		if $Timers/SwordTimer.get_time_left() == 0:
			$Timers/SwordTimer.start()
		
		if GlobalStats.swordTime < $Timers/SwordTimer.get_time_left(): # Si se agarra un pickup de espada mientras esta activa la espada, reinicia el temporizador
			$Timers/SwordTimer.start()
		
		GlobalStats.swordTime = $Timers/SwordTimer.get_time_left()

########################################################################################
#################################  CONTROL DE NODOS ####################################
########################################################################################

func _on_roll_timeout(): # Controla el roll mientras se ejecuta
	animRoll = false
	if comboA:
		animHitA = true
		$Timers/HitA.start()
		comboA = false
	if comboB:
		animHitB = true
		$Timers/HitB.start()
		comboB = false
		
	$Timers/RollTimer.start()

func _on_roll_timer_timeout(): # Vuelve a activar el roll 
	canRoll = true

func _on_hit_a_timeout(): # Controla el golpe A mientras se ejecuta
	animHitA = false
	$HittingArea/HitboxHit.disabled = true
	$Timers/HitATimer.start()
	if comboB:
		animHitB = true
		$Timers/HitB.start()
		comboB = false

func _on_hit_a_timer_timeout(): # Vuelve a activar el golpe A 
	canHitA = true

func _on_hit_b_timeout(): # Controla el golpe B mientras se ejecuta
	animHitB = false
	$HittingArea/HitboxHit.disabled = true
	$Timers/HitBTimer.start()

func _on_hit_b_timer_timeout(): # Vuelve a activar el golpe B
	canHitB = true

func _on_hitting_area_body_entered(body): # Controla el daño que hace el jugador a los enemigos y le suma estadisticas extra en caso que las haya
	if body.is_in_group("enemigos"):
		if animHitA and GlobalStats.activeSword:
			body.life -= 2.5 + GlobalStats.playerDmgIncress
			body.recibirDmg = true
		elif animHitA and !GlobalStats.activeSword:
			body.life -= 1.5 + GlobalStats.playerDmgIncress
			body.recibirDmg = true
		elif animHitB and GlobalStats.activeSword:
			body.life -= 4 + GlobalStats.playerDmgIncress
			body.recibirDmg = true
		elif animHitB and !GlobalStats.activeSword: 
			body.life -= 2.5 + GlobalStats.playerDmgIncress
			body.recibirDmg = true

func _on_hitting_area_body_exited(body): # Deja de producir daño al enemigo (desactiva la animacion de daño)
	if body.is_in_group("enemigos"):
		body.recibirDmg = false

func _on_sword_timer_timeout(): # Desactiva la espada
	GlobalStats.activeSword = false

func _on_steps_timeout(): # Reproduce el sonido de los pasos
	$SFX/Pasos.play()

func _on_death_finished(): # Si el jugador muere va a Game Over
	get_tree().change_scene_to_file("res://Escenas/Menus/GameOver.tscn")
