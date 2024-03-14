extends Node2D

# Arreglar la wea de los sprites de los dummys

func _ready():
	crear_sombras($PersonajePrincipal)
	var enemigos = get_tree().get_nodes_in_group("enemy")
	for enemigo in enemigos:
		crear_sombras(enemigo)

func _process(_delta):
	update_process()
	update_sombras($PersonajePrincipal)

func render(sprite1, sprite2):
	if sprite1.position.y >= sprite2.position.y and sprite2.inSprite:
		sprite2.z_index = 1
		sprite1.z_index = 2
	if sprite1.position.y <= sprite2.position.y and sprite2.inSprite:
		sprite1.z_index = 1
		sprite2.z_index = 2

func on_hit(enemy):
	if $PersonajePrincipal.position.y >= enemy.position.y - 5 and $PersonajePrincipal.position.y <= enemy.position.y + 4 and enemy.inArea:
		enemy.canBeHit = true
	else:
		enemy.canBeHit = false

func update_process():
	var enemigos = get_tree().get_nodes_in_group("enemy")
	for enemigo in enemigos:
		on_hit(enemigo)
		render($PersonajePrincipal, enemigo)
		update_sombras(enemigo)
func crear_sombras(sprite_p):
	var sombra = AnimatedSprite2D.new()
	var sprite_original = sprite_p.get_node("Sprite")
	sombra.modulate = Color.BLACK
	sombra.flip_v = true
	sombra.skew = 45
	sombra.z_index = 0
	sombra.position = Vector2(sprite_original.position.x - 15, sprite_original.position.y - sprite_original.position.y + 11)
	sombra.scale = Vector2(sprite_original.scale.x, sprite_original.scale.y)
	sprite_p.add_child(sombra, true)

func update_sombras(sprite_p):
	var sombra_mov = sprite_p.get_node("AnimatedSprite2D")
	var sprite_original = sprite_p.get_node("Sprite")
	sombra_mov.flip_h = sprite_original.is_flipped_h()
	sombra_mov.set_sprite_frames(sprite_original.get_sprite_frames())
	sombra_mov.set_animation(sprite_original.get_animation())
	sombra_mov.set_frame(sprite_original.get_frame())
