extends Node

func crear_sombras(sprite: AnimatedSprite2D, sombraMarker: Marker2D):
	var spriteOriginal = sprite
	var marker = sombraMarker
	var sombra = AnimatedSprite2D.new()
	
	sombra.modulate = Color.BLACK
	sombra.z_index = 0
	sombra.z_as_relative = false
	sombra.flip_v = true
	sombra.skew = 45
	sombra.scale = Vector2(1,1)
	sombra.position = Vector2(marker.position)
	spriteOriginal.add_child(sombra, true)

func update_sombras():
	var spriteOriginal = get_tree().get_nodes_in_group("sprites")
	
	for sprite in spriteOriginal:
		var sombra_mov = sprite.get_node("AnimatedSprite2D")
		sombra_mov.flip_h = sprite.is_flipped_h()
		sombra_mov.set_sprite_frames(sprite.get_sprite_frames())
		sombra_mov.set_animation(sprite.get_animation())
		sombra_mov.set_frame(sprite.get_frame())
