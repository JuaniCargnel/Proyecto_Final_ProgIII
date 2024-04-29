extends Area2D

class_name dummy

@export var inArea:bool = false
@export var canBeHit:bool = false
@export var inSprite:bool = false

func _on_sprite_animation_looped():
	$Sprite.stop() 

func _on_hitbox_cerca_body_entered(body):
	if body.is_in_group("player"):
		inArea = true

func _on_hitbox_cerca_body_exited(body):
	if body.is_in_group("player"):
		inArea = false

func _on_area_entered(area):
	if area.is_in_group("golpe") and canBeHit:
		$Sprite.stop()
		if global_position.x < area.global_position.x:
			$Sprite.frame = 2
		else:
			$Sprite.frame = 1
		$Sprite.play("dummy")
	if area.is_in_group("areaSprite"):
		inSprite = true

func _on_area_exited(area):
	if area.is_in_group("areaSprite"):
		inSprite = false
