extends CharacterBody2D

const velWalk = 75
const velRun = 150
const velRoll = 200

var roll = false
var can_roll = true
var run = false
var idle = true

func _physics_process(_delta):
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
		
	if Input.is_action_pressed("Correr") and direccion.x != 0 or Input.is_action_pressed("Correr") and direccion.y != 0:
		run = true
	else: 
		run = false
		
	if Input.is_action_just_pressed("Roll") and can_roll:
		roll = true
		can_roll = false
		$Roll.start()
	else: 
		roll = false
		
	if run:
		velocity.x = direccion.normalized().x * velRun
		velocity.y = direccion.normalized().y * velRun
	else: 
		velocity.x = direccion.normalized().x * velWalk
		velocity.y = direccion.normalized().y * velWalk
		
	if run:
		idle = false
		$Sprite.play("run")
	else:
		if direccion != Vector2.ZERO and not roll:
			$Sprite.play("walk")
			idle = false
		elif not idle:
			idle = true
			$Sprite.play("idle")
	
	if roll:
		idle = false
		run = false
		$Sprite.play("roll")
		velocity.x = direccion.normalized().x * velRoll
		velocity.y = direccion.normalized().y * velRoll
	
	move_and_slide()

func _on_roll_timeout():
	roll = false
	$RollTimer.start()

func _on_roll_timer_timeout():
	can_roll = true
