extends CharacterBody2D

const velocidad = 200

func _physics_process(delta):
	
	var direcion = Vector2.ZERO
	
	if Input.is_action_pressed("Right"):
		direcion.x += 1
		$Sprite.set_flip_h(false)
		$Sprite.play("run")
	if Input.is_action_pressed("Left"):
		direcion.x -= 1
		$Sprite.set_flip_h(true)
		$Sprite.play("run")
	if Input.is_action_pressed("Up"):
		direcion.y -= 1
		$Sprite.play("run")
	if Input.is_action_pressed("Down"):
		direcion.y += 1
		$Sprite.play("run")
	if direcion.x == 0 and direcion.y == 0:
		$Sprite.play("idle")
		
	if direcion.length() > 0:
		direcion = direcion.normalized()
		
	position += direcion * velocidad * delta
	
	position.x = clamp(position.x, 10, get_tree().root.content_scale_size.x)
	position.y = clamp(position.y, 15, get_tree().root.content_scale_size.y)
	
	move_and_slide()

