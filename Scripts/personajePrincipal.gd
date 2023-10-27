extends CharacterBody2D

const velWalk = 75
const velRun = 150
const velRoll = 250

var can_roll = true
var roll = false
var run = false
var idle = true

func _ready():
	$Sprite.play("idle")

func _physics_process(_delta):
	estados()
	move_and_slide()
	animations()

func estados():
	desplazamiento()
	running()
	rolling()

func desplazamiento():
	var direccion = Vector2()
	
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
		
	if run:
		velocity.x = direccion.normalized().x * velRun
		velocity.y = direccion.normalized().y * velRun
	elif roll:
		velocity.x = direccion.normalized().x * velRoll
		velocity.y = direccion.normalized().y * velRoll
	else: 
		velocity.x = direccion.normalized().x * velWalk
		velocity.y = direccion.normalized().y * velWalk

func animations():
	if run:
		$Sprite.play("run")
	elif roll:
		$Sprite.play("roll")
	else:
		if velocity != Vector2.ZERO and not roll:
			$Sprite.play("walk")
			idle = false
		elif not idle and not roll:
			idle = true
			$Sprite.play("idle")

func running():
	if Input.is_action_pressed("Correr") and not roll and not idle and velocity != Vector2.ZERO:
		run = true
	else: 
		run = false

func rolling():
	if Input.is_action_pressed("Roll") and not idle and can_roll:
		roll = true
		can_roll = false
		$Roll.start()
	elif roll:
		pass
	else: 
		roll = false

func _on_roll_timeout():
	roll = false
	$RollTimer.start()

func _on_roll_timer_timeout():
	can_roll = true
