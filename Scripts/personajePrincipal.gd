extends CharacterBody2D

class_name personajeClass

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

func _ready():
	NavigationManager.onTriggerPlayer.connect(on_spawn)
	$Sprite.modulate = Color(GlobalStats.colorR, GlobalStats.colorG, GlobalStats.colorB)

func _process(delta):
	if GlobalStats.alive:
		GlobalStats.positionPlayer = global_position
		z_index = GlobalStats.zindexPlayer 
		estados(delta)
		animations()

func estados(delta):
	rolling()
	movimientos(delta)
	walking()
	running()
	hitting()
	player_death()

func on_spawn(positionPlayer: Vector2, _direction):
	global_position = positionPlayer
	
func movimientos(delta):
	if Input.is_action_pressed("Sword"):
		GlobalStats.activeSword = true
	if Input.is_action_pressed("Hands"):
		GlobalStats.activeSword = false
		
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
		return "death"
	elif anim_hitA:
		if GlobalStats.activeSword:
			return "swordAttack"
		else: 
			return "jab"
	elif anim_hitB:
		if GlobalStats.activeSword:
			return "swordStab"
		else:
			return "cross"
	elif anim_dmg:
		return "damage"
	elif anim_run:
		if GlobalStats.activeSword:
			return "swordRun"
		else:
			return "run"
	elif anim_roll:
		return "roll"
	elif direccion != Vector2.ZERO and not anim_roll and not anim_run:
		if GlobalStats.activeSword:
			return "swordWalk"
		else: 
			return "walk"
	else:
		if GlobalStats.activeSword:
			anim_idle = true
			return "swordIdle"
		else:
			anim_idle = true
			return "idle"

func walking():
	var input_x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var input_y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	if !anim_hitA:
		if !anim_hitB:
			if Input.is_action_pressed("Right"):
				$Sprite.set_flip_h(false)
				$DmgArea/HitboxDmg.position = Vector2(-1,1)
				lookDerecha = true
			if Input.is_action_pressed("Left"):
				$Sprite.set_flip_h(true)
				$DmgArea/HitboxDmg.position = Vector2(1,1)
				lookDerecha = false
				
	direccion = Vector2(input_x, input_y)

func running():
	if Input.is_action_pressed("Correr") and not anim_roll and not anim_hitA and not anim_hitB and direccion != Vector2.ZERO:
		anim_run = true
	else: 
		anim_run = false

func rolling():
	if Input.is_action_pressed("Roll") and canRoll and not anim_hitA and not anim_hitB and direccion != Vector2.ZERO:
		anim_roll = true
		canRoll = false
		valor_tmp_roll = direccion
		$Timers/Roll.start()
		$DmgArea/HitboxDmg.disabled = true
	elif anim_roll:
		if Input.is_action_pressed("GolpeA"):
			comboA = true
		if Input.is_action_pressed("GolpeB"):
			comboB = true
		direccion = valor_tmp_roll
	else: 
		$DmgArea/HitboxDmg.disabled = false
		anim_roll = false
		valor_tmp_roll = null

func hitting():
	if Input.is_action_pressed("GolpeA") and canHitA and not anim_roll and not anim_hitB:
		anim_hitA = true
		canHitA = false
		$Timers/HitA.start()
	elif Input.is_action_pressed("GolpeB") and canHitB and not anim_roll and not anim_hitA:
		anim_hitB = true
		canHitB = false
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
			if $Sprite.frame == 2:
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
		$Timers/Death.start()

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
	GlobalStats.alive = true
	GlobalStats.playerLife = 10

func _on_dmg_area_body_entered(body):
	if body.is_in_group("areaEnemy"):
		GlobalStats.playerLife -= 1
		anim_dmg = true
		$Timers/Dmg.start()

func _on_dmg_area_body_exited(body):
	if body.is_in_group("areaEnemy"):
		anim_dmg = false
		$Timers/Dmg.stop()

func _on_dmg_timeout():
	GlobalStats.playerLife -= 1
