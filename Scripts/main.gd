extends Node2D

# Arreglar los golpes para que no se realicen si el personaje se mueve izquierda derecha
# Agregar las sombras para que los golpes sean mas predecibles 

func _ready():
	$PersonajePrincipal.add_child(crear_sombras($PersonajePrincipal))
func _process(_delta):

	update_process()

func render(sprite2):
	if $PersonajePrincipal.position.y >= sprite2.position.y:
		sprite2.z_index = 1
		$PersonajePrincipal.z_index = 2
	else:
		$PersonajePrincipal.z_index = 1
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
		render(enemigo)
		crear_sombras(enemigo)

func crear_sombras(sprite_p):
	var sombra = AnimatedSprite2D.new()
	var sprite_original = sprite_p.get_node("Sprite")
	
	#sombra = sprite_original.duplicate()
	sombra.set_sprite_frames(sprite_original.get_sprite_frames())
	sombra.set_animation(sprite_original.get_animation())
	sombra.set_frame(sprite_original.get_frame())


	sombra.play(sprite_original.get_animation())
	sombra.modulate = Color.BLACK
	sombra.position =  Vector2(sprite_original.position.x - 15, sprite_original.position.y + 39)
	sombra.flip_v = true
	sombra.flip_h = sprite_original.is_flipped_h()
	sombra.scale = Vector2(sprite_original.scale.x, sprite_original.scale.y)
	sombra.skew = 45
	
	return sombra
