extends CharacterBody2D

const velWalk = 75
const velRun = 150
const velRoll = 260

var direcRoll:Vector2
var direccion:Vector2

var canRoll = true
var canHitB = true
var canHitA = true

var walk = false
var roll = false
var run = false
var idle = true
var hitA = false
var hitB = false
var comboA = false
var comboB = false
var rollX = false
var rollY = false 
var activeSword = false

func _ready():
	$Sprite.play("idle")

func _physics_process(_delta):
	estados()
	animations()
	move_and_slide()

func estados():
	walking()
	running()
	rolling()
	hitting()
	movimientos()

func movimientos():
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
	var animationName = get_animation_name()
	$Sprite.play(animationName)

func get_animation_name():
	if velocity != Vector2.ZERO and not roll and not run:
		if activeSword:
			idle = false
			return "swordWalk"
		else: 
			idle = false
			return "walk"
	elif run:
		if activeSword:
			return "swordRun"
		else:
			return "run"
	elif roll:
		return "roll"
	elif hitA:
		if activeSword:
			return "swordAttack"
		else: 
			return "jab"
	elif hitB:
		if activeSword:
			return "swordStab"
		else:
			return "cross"
	else:
		if activeSword:
			idle = true
			return "swordIdle"
		else:
			idle = true
			return "idle"

func walking():
	direccion = Vector2()
	
	if Input.is_action_pressed("Right"):
		direccion.x += 1
		$Sprite.set_flip_h(false)
	if Input.is_action_pressed("Left"):
		direccion.x -= 1
		$Sprite.set_flip_h(true)
	if Input.is_action_pressed("Up"):
		direccion.y -= 1
	if Input.is_action_pressed("Down"):
		direccion.y += 1

func running():
	if Input.is_action_pressed("Correr") and not roll and not hitA and not hitB and velocity != Vector2.ZERO:
		run = true
	else: 
		run = false

func rolling():
	if direccion.x == 1 and roll:
		direcRoll.x = 1
		rollX = true
	elif direccion.x == -1 and roll:
		direcRoll.x = -1
		rollX = true
	
	if Input.is_action_pressed("Roll") and canRoll and not hitA and not hitB and velocity != Vector2.ZERO:
		roll = true
		canRoll = false
		$Timers/Roll.start()
	elif roll:
		if Input.is_action_pressed("GolpeA"):
			comboA = true
		if Input.is_action_pressed("GolpeB"):
			comboB = true
	else: 
		roll = false

func hitting():
	if Input.is_action_pressed("GolpeA") and canHitA and not roll:
		hitA = true
		canHitA = false
		$Timers/HitA.start()
	elif hitA:
		velocity = Vector2.ZERO
	else:
		hitA = false
		
	if Input.is_action_pressed("GolpeB") and canHitB and not roll:
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
