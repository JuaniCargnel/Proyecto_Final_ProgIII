extends CharacterBody2D

const velWalk = 75
const velRun = 150
const velRoll = 200

var direccion:Vector2
var valor_tmp_roll = Vector2()

var canRoll = true
var canHitB = true
var canHitA = true
var roll = false
var run = false
var idle = true
var hitA = false
var hitB = false
var comboA = false
var comboB = false
var activeSword = false
var izquierda = false
var derecha = true


func _ready():
	$Sprite.play("idle")

func _process(delta):
	estados(delta)
	animations()
	move_and_slide()

func estados(delta):
	rolling()
	movimientos(delta)
	walking()
	running()
	hitting()

func movimientos(delta):
	if Input.is_action_pressed("Sword"):
		activeSword = true
	if Input.is_action_pressed("Hands"):
		activeSword = false
		
	if run:
		translate(direccion.normalized() * velRun * delta)
	elif roll:
		translate(direccion.normalized() * velRoll * delta)
	else: 
		translate(direccion.normalized() * velWalk * delta)

func animations():
	var animationName = get_animation_name()
	$Sprite.play(animationName)

func get_animation_name():
	if hitA:
		if activeSword:
			return "swordAttack"
		else: 
			return "jab"
	elif hitB:
		if activeSword:
			return "swordStab"
		else:
			return "cross"
	elif run:
		if activeSword:
			return "swordRun"
		else:
			return "run"
	elif roll:
		return "roll"
	elif direccion != Vector2.ZERO and not roll and not run:
		if activeSword:
			return "swordWalk"
		else: 
			return "walk"
	else:
		if activeSword:
			idle = true
			return "swordIdle"
		else:
			idle = true
			return "idle"

func walking():
	var input_x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var input_y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	if Input.is_action_pressed("Right"):
		$Sprite.set_flip_h(false)
		$Hitbox.position = Vector2(-0.5,0)
		derecha = true
		izquierda = false
	if Input.is_action_pressed("Left"):
		$Sprite.set_flip_h(true)
		$Hitbox.position = Vector2(2.5,0)
		izquierda = true
		derecha = false
	
	direccion = Vector2(input_x, input_y)

func running():
	if Input.is_action_pressed("Correr") and not roll and not hitA and not hitB and direccion != Vector2.ZERO:
		run = true
	else: 
		run = false

func rolling():
	if Input.is_action_pressed("Roll") and canRoll and not hitA and not hitB and direccion != Vector2.ZERO:
		roll = true
		canRoll = false
		valor_tmp_roll = direccion
		$Timers/Roll.start()
	elif roll:
		if Input.is_action_pressed("GolpeA"):
			comboA = true
		if Input.is_action_pressed("GolpeB"):
			comboB = true
		direccion = valor_tmp_roll
	else: 
		roll = false
		valor_tmp_roll = null

func hitting():
	if Input.is_action_pressed("GolpeA") and canHitA and not roll and not hitB:
		hitA = true
		canHitA = false
		$Timers/HitA.start()
	elif Input.is_action_pressed("GolpeB") and canHitB and not roll and not hitA:
		hitB = true
		canHitB = false
		$Timers/HitB.start()
	elif hitA:
		if activeSword:
			$AreaGolpes/CollisionShapeGolpes.scale = Vector2(2.5,4)
			if derecha:
				$AreaGolpes/CollisionShapeGolpes.position = Vector2(20,2)
			if izquierda: 
				$AreaGolpes/CollisionShapeGolpes.position = Vector2(-20,1)
		elif !activeSword:
			$AreaGolpes/CollisionShapeGolpes.scale = Vector2(2,1)
			if derecha:
				$AreaGolpes/CollisionShapeGolpes.position = Vector2(14,-1)
			elif izquierda:
				$AreaGolpes/CollisionShapeGolpes.position = Vector2(-14,-1)
		
		direccion = Vector2.ZERO
		$AreaGolpes/CollisionShapeGolpes.disabled = false
		
		if Input.is_action_pressed("GolpeB"):
			comboB = true
	elif hitB:
		if activeSword:
			$AreaGolpes/CollisionShapeGolpes.scale = Vector2(4,1)
			if derecha:
				$AreaGolpes/CollisionShapeGolpes.position = Vector2(27,2)
			elif izquierda:
				$AreaGolpes/CollisionShapeGolpes.position = Vector2(-27,2)
		elif !activeSword:
			$AreaGolpes/CollisionShapeGolpes.scale = Vector2(2,2)
			if derecha:
				$AreaGolpes/CollisionShapeGolpes.position = Vector2(22,4)
			elif izquierda:
				$AreaGolpes/CollisionShapeGolpes.position = Vector2(-22,4)
		
		direccion = Vector2.ZERO
		$AreaGolpes/CollisionShapeGolpes.disabled = false
	else:
		hitB = false
		hitA = false
		$AreaGolpes/CollisionShapeGolpes.disabled = true

func _on_roll_timeout():
	roll = false
	
	if comboA:
		hitA = true
		$Timers/HitA.start()
		comboA = false
	if comboB:
		hitB = true
		$Timers/HitB.start()
		comboB = false
	
	$Timers/RollTimer.start()

func _on_roll_timer_timeout():
	canRoll = true

func _on_hit_a_timeout():
	hitA = false
	$Timers/HitATimer.start()
	if comboB:
		hitB = true
		$Timers/HitB.start()
		comboB = false

func _on_hit_a_timer_timeout():
	canHitA = true

func _on_hit_b_timeout():
	hitB = false
	$Timers/HitBTimer.start()

func _on_hit_b_timer_timeout():
	canHitB = true


