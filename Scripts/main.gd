extends Node2D

@onready var prueba = get_node("PersonajePrincipal")

func _process(_delta):
	render($Dummy)
	zonas_enemigos_on_hit()

func render(sprite2):
	if $PersonajePrincipal.position.y >= sprite2.position.y - 5:
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

func zonas_enemigos_on_hit():
	var enemigos = get_tree().get_nodes_in_group("enemy")
	
	for enemigo in enemigos:
		on_hit(enemigo)
	
