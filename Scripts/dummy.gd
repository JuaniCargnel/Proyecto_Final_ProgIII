extends StaticBody2D

@export var inArea:bool
@export var canBeHit:bool = false

func _on_dummy_area_entered(area):
	if area.is_in_group("golpe") and canBeHit:
		$Sprite.play("dummy")
	else:
		pass

func _on_sprite_animation_looped():
	$Sprite.stop() 

func _on_hitbox_cerca_body_entered(body):
	if body.is_in_group("player"):
		inArea = true

func _on_hitbox_cerca_body_exited(body):
	if body.is_in_group("player"):
		inArea = false
