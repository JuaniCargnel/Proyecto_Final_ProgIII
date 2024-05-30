extends Node

func render():
	var enemigos = get_tree().get_nodes_in_group("enemigos")
	for enemigo in enemigos:
		if enemigo.inArea:
			if GlobalStats.positionPlayer.y + 2 >= enemigo.global_position.y:
				enemigo.z_index = 1
			else:
				enemigo.z_index = 3
