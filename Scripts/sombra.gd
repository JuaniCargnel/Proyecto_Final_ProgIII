extends Node

class_name sombraGlobal

func crear_sombras(sprite_p):
	var sombra = AnimatedSprite2D.new()
	var sprite_original = sprite_p.get_node("Sprite")
	sombra.modulate = Color.BLACK
	sombra.z_index = -10
	sombra.z_as_relative = false
	sombra.flip_v = true
	sombra.skew = 45
	sombra.position = Vector2(sprite_original.position.x - 14, sprite_original.position.y + 24)
	sombra.scale = Vector2(sprite_original.scale.x, sprite_original.scale.y)
	sprite_p.add_child(sombra, true)

func update_sombras(sprite_p):
	var sombra_mov = sprite_p.get_node("AnimatedSprite2D")
	var sprite_original = sprite_p.get_node("Sprite")
	sombra_mov.flip_h = sprite_original.is_flipped_h()
	sombra_mov.set_sprite_frames(sprite_original.get_sprite_frames())
	sombra_mov.set_animation(sprite_original.get_animation())
	sombra_mov.set_frame(sprite_original.get_frame())
