extends CharacterBody2D

const velWalk = 75
const velRun = 150
const velRoll = 260

var direcRoll:Vector2

var canRoll = true
var canHitB = true
var canHitA = true
var roll = false
var run = false
var idle = true
var hitA = false
var hitB = false
var activeSword = false
var comboA = false
var comboB = false
var rollX = false
var rollY = false 

func _ready():
	$Sprite.play("idle")

func _physics_process(_delta):
	estados()
	move_and_slide()
	animations()

func estados():
	movimientos()
	running()
	rolling()
	hitting()

func movimientos():
	var direccion = Vector2()
	
	if Input.is_action_pressed("Right"):
		direccion.x += 1
		direcRoll.x = 1
		if roll:
			rollX = true
		$Sprite.set_flip_h(false)
	if Input.is_action_pressed("Left"):
		direccion.x -= 1
		direcRoll.x = -1
		if roll:
			rollX = true
		$Sprite.set_flip_h(true)
	if Input.is_action_pressed("Up"):
		direccion.y -= 1
		direcRoll.y = -1
		if roll:
			rollY = true
	if Input.is_action_pressed("Down"):
		direccion.y += 1
		direcRoll.y = 1
		if roll:
			rollY = true
			
	if Input.is_action_pressed("Sword"):
		activeSword = true
		
	if Input.is_action_pressed("Hands"):
		activeSword = false
		
	if run:
		velocity.x = direccion.normalized().x * velRun
		velocity.y = direccion.normalized().y * velRun
	elif roll:
		if rollX:
			velocity.x = direcRoll.normalized().x * velRoll
		if rollY:
			velocity.y = direcRoll.normalized().y * velRoll
	else: 
		velocity.x = direccion.normalized().x * velWalk
		velocity.y = direccion.normalized().y * velWalk

func animations():
	if run and activeSword:
		$Sprite.play("swordRun")
	elif run:
		$Sprite.play("run")
	elif roll:
		$Sprite.play("roll")
	elif hitA and activeSword:
		$Sprite.play("swordAttack")
	elif hitB and activeSword:
		$Sprite.play("swordStab")
	elif hitA:
		$Sprite.play("jab")
	elif hitB:
		$Sprite.play("cross")
	else:
		if velocity != Vector2.ZERO and not roll and activeSword:
			$Sprite.play("swordWalk")
			idle = false
		elif velocity != Vector2.ZERO and not roll:
			$Sprite.play("walk")
			idle = false
		elif activeSword:
			idle = true
			$Sprite.play("swordIdle")
		else:
			idle = true
			$Sprite.play("idle")

func running():
	if Input.is_action_pressed("Correr") and not roll and not idle and velocity != Vector2.ZERO and not hitA and not hitB:
		run = true
	else: 
		run = false

func rolling():
	if Input.is_action_pressed("Roll") and canRoll and not idle and not hitA and not hitB:
		roll = true
		canRoll = false
		$Timers/Roll.start()
	elif roll:
		if Input.is_action_pressed("Golpear"):
			comboA = true
		if Input.is_action_pressed("Fuerte"):
			comboB = true
	else: 
		roll = false

func hitting():
	if Input.is_action_pressed("Golpear") and canHitA and not roll:
		hitA = true
		canHitA = false
		$Timers/HitA.start()
	elif hitA:
		velocity = Vector2.ZERO
	else:
		hitA = false
		
	if Input.is_action_pressed("Fuerte") and canHitB and not roll:
		hitB = true
		canHitB = false
		$Timers/HitB.start()
	elif hitB:
		velocity = Vector2.ZERO
	else:
		hitB = false

func _on_roll_timeout():
	roll = false
	rollY = false
	rollX = false
	
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

func _on_hit_b_timeout():
	hitB = false
	$Sprite.play("idle")
	$Timers/HitBTimer.start()

func _on_hit_b_timer_timeout():
	canHitB = true

func _on_hit_a_timeout():
	hitA = false
	$Sprite.play("idle")
	$Timers/HitATimer.start()

func _on_hit_a_timer_timeout():
	canHitA = true
