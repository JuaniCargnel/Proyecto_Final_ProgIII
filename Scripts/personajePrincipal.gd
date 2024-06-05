extends CharacterBody2D

var direccion = Vector2()
var valor_tmp_roll = Vector2()

var anim_roll: bool = false
var anim_run: bool = false
var anim_idle: bool = true
var anim_hitA: bool = false
var anim_hitB: bool = false
var anim_dmg: bool = false
var anim_death: bool = false

var canRoll: bool = true
var canHitB: bool = true
var canHitA: bool = true
var comboA: bool = false
var comboB: bool = false
var lookDerecha: bool = true

var cameraZoom = 2

func _ready():
	$Sprite.modulate = Color(GlobalStats.colorR, GlobalStats.colorG, GlobalStats.colorB)
	Sombra.crear_sombras($Sprite, $SombraMark)
	global_position = Vector2(500,500)
	
func _process(delta):
	print(GlobalStats.playerLife)
	if GlobalStats.alive:
		GlobalStats.positionPlayer = global_position
		z_index = GlobalStats.zindexPlayer 
		regenStamina()
		estados(delta)
		animations()
	else:
		cameraZoom += 0.05
		$Camera2D.zoom = Vector2(cameraZoom, cameraZoom)
		
	Sombra.update_sombras()

func estados(delta):
	activeSword()
	rolling()
	movimientos(delta)
	walking()
	running()
	hitting()
	recibir_dmg()
	player_death()

func regenStamina():
	if GlobalStats.playerStamina < GlobalStats.maxStamina:
		GlobalStats.playerStamina += GlobalStats.regenStamina

func activeSword():
	if GlobalStats.activeSword:
		$Timers/SwordTimer.set_wait_time(GlobalStats.maxSwordTime)
		
		if $Timers/SwordTimer.get_time_left() == 0:
			$Timers/SwordTimer.start()
			
		GlobalStats.swordTime = $Timers/SwordTimer.get_time_left()

func movimientos(delta):
	if anim_run:
		translate(direccion.normalized() * GlobalStats.velRun * delta)
	elif anim_roll:
		translate(direccion.normalized() * GlobalStats.velRoll * delta)
	else: 
		translate(direccion.normalized() * GlobalStats.velWalk * delta)
		
	move_and_slide()

func animations():
	var animationName = get_animation_name()
	$Sprite.play(animationName)

func get_animation_name():
	if anim_death:
		GlobalStats.animacion = 8
		return "death"
	elif anim_hitA:
		if GlobalStats.activeSword:
			GlobalStats.animacion = 5.1
			return "swordAttack"
		else: 
			GlobalStats.animacion = 5
			return "jab"
	elif anim_hitB:
		if GlobalStats.activeSword:
			GlobalStats.animacion = 4.1
			return "swordStab"
		else:
			GlobalStats.animacion = 4
			return "cross"
	elif anim_dmg:
		GlobalStats.animacion = 7
		return "damage"
	elif anim_run:
		if GlobalStats.activeSword:
			GlobalStats.animacion = 3.1
			return "swordRun"
		else:
			GlobalStats.animacion = 3
			return "run"
	elif anim_roll:
		GlobalStats.animacion = 6
		return "roll"
	elif direccion != Vector2.ZERO and not anim_roll and not anim_run:
		if GlobalStats.activeSword:
			GlobalStats.animacion = 2.1
			return "swordWalk"
		else: 
			GlobalStats.animacion = 2
			return "walk"
	else:
		if GlobalStats.activeSword:
			anim_idle = true
			GlobalStats.animacion = 1.1
			return "swordIdle"
		else:
			anim_idle = true
			GlobalStats.animacion = 1
			return "idle"

func walking():
	var input_x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var input_y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	if !anim_hitA:
		if !anim_hitB:
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

func running():
	if Input.is_action_pressed("Correr") and not anim_roll and not anim_hitA and not anim_hitB and direccion != Vector2.ZERO and GlobalStats.playerStamina > 1:
		anim_run = true
		GlobalStats.playerStamina -= 1
	elif GlobalStats.playerStamina <= 1:
		Input.action_release("Correr")
	else: 
		anim_run = false

func rolling():
	if Input.is_action_pressed("Roll") and canRoll and not anim_hitA and not anim_hitB and direccion != Vector2.ZERO and GlobalStats.playerStamina > 101:
		anim_roll = true
		canRoll = false
		valor_tmp_roll = direccion
		$Timers/Roll.start()
		$DmgArea/CollisionShape2D.disabled = true
		GlobalStats.playerStamina -= 100
	elif anim_roll:
		if Input.is_action_pressed("GolpeA"):
			comboA = true
		if Input.is_action_pressed("GolpeB"):
			comboB = true
		direccion = valor_tmp_roll
	else: 
		$DmgArea/CollisionShape2D.disabled = false
		anim_roll = false
		valor_tmp_roll = null

func hitting():
	if Input.is_action_pressed("GolpeA") and canHitA and not anim_roll and not anim_hitB and GlobalStats.playerStamina > 21:
		anim_hitA = true
		canHitA = false
		GlobalStats.playerStamina -= 20
		$Timers/HitA.start()
	elif Input.is_action_pressed("GolpeB") and canHitB and not anim_roll and not anim_hitA and GlobalStats.playerStamina > 51:
		anim_hitB = true
		canHitB = false
		GlobalStats.playerStamina -= 50
		$Timers/HitB.start()
	elif anim_hitA:
		direccion = Vector2.ZERO
		if GlobalStats.activeSword:
			$HittingArea/HitboxHit.scale = Vector2(2.5,4)
			if $Sprite.frame == 3:
				$HittingArea/HitboxHit.disabled = false
			if lookDerecha:
				$HittingArea/HitboxHit.position = Vector2(20,2)
			else:
				$HittingArea/HitboxHit.position = Vector2(-20,1)
		elif !GlobalStats.activeSword:
			$HittingArea/HitboxHit.scale = Vector2(2,0.5)
			if $Sprite.frame == 1:
				$HittingArea/HitboxHit.disabled = false
			if lookDerecha:
				$HittingArea/HitboxHit.position = Vector2(12,-1)
			else:
				$HittingArea/HitboxHit.position = Vector2(-12,-1)
		if Input.is_action_pressed("GolpeB"):
			comboB = true
	elif anim_hitB:
		direccion = Vector2.ZERO
		if GlobalStats.activeSword:
			if $Sprite.frame == 3:
				$HittingArea/HitboxHit.disabled = false
			$HittingArea/HitboxHit.scale = Vector2(4,1)
			if lookDerecha:
				$HittingArea/HitboxHit.position = Vector2(27,2)
			else:
				$HittingArea/HitboxHit.position = Vector2(-27,2)
		elif !GlobalStats.activeSword:
			if $Sprite.frame == 3:
				$HittingArea/HitboxHit.disabled = false
			$HittingArea/HitboxHit.scale = Vector2(2,2)
			if lookDerecha:
				$HittingArea/HitboxHit.position = Vector2(22,4)
			else:
				$HittingArea/HitboxHit.position = Vector2(-22,4)
	else:
		anim_hitB = false
		anim_hitA = false
		$HittingArea/HitboxHit.disabled = true

func player_death():
	if GlobalStats.playerLife <= 0:
		GlobalStats.alive = false
		anim_death = true
		$Sprite.material.set_shader_parameter("flicker_enabled", false)
		$Timers/Death.start()

func recibir_dmg():
	if GlobalStats.recibirDanio:
		anim_dmg = true
		$Sprite.material.set_shader_parameter("flicker_enabled", true)
	elif !GlobalStats.recibirDanio and $Sprite.frame == 2:
		anim_dmg = false
		$Sprite.material.set_shader_parameter("flicker_enabled", false)

func _on_roll_timeout():
	anim_roll = false
	if comboA:
		anim_hitA = true
		$Timers/HitA.start()
		comboA = false
	if comboB:
		anim_hitB = true
		$Timers/HitB.start()
		comboB = false
		
	$Timers/RollTimer.start()

func _on_roll_timer_timeout():
	canRoll = true

func _on_hit_a_timeout():
	anim_hitA = false
	$HittingArea/HitboxHit.disabled = true
	$Timers/HitATimer.start()
	if comboB:
		anim_hitB = true
		$Timers/HitB.start()
		comboB = false

func _on_hit_a_timer_timeout():
	canHitA = true

func _on_hit_b_timeout():
	anim_hitB = false
	$HittingArea/HitboxHit.disabled = true
	$Timers/HitBTimer.start()

func _on_hit_b_timer_timeout():
	canHitB = true

func _on_death_timeout():
	get_tree().reload_current_scene()
	GlobalStats.recibirDanio = false
	GlobalStats.alive = true
	GlobalStats.playerLife = GlobalStats.maxLife
	GlobalStats.playerStamina = GlobalStats.maxStamina

func _on_hitting_area_body_entered(body):
	if body.is_in_group("enemigos"):
		if anim_hitA and GlobalStats.activeSword:
			body.life -= 2
			body.recibirDmg = true
		elif anim_hitA and !GlobalStats.activeSword:
			body.life -= 1
			body.recibirDmg = true
		elif anim_hitB and GlobalStats.activeSword:
			body.life -= 3
			body.recibirDmg = true
		elif anim_hitB and !GlobalStats.activeSword: 
			body.life -= 2
			body.recibirDmg = true

func _on_hitting_area_body_exited(body):
	if body.is_in_group("enemigos"):
		body.recibirDmg = false

func _on_sword_timer_timeout():
	GlobalStats.activeSword = false
