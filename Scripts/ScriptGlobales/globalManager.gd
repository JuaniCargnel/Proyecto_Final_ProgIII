extends Node

func render():
	var enemigos = get_tree().get_nodes_in_group("enemigos")
	for enemigo in enemigos:
		if enemigo.inArea:
			if GlobalStats.positionPlayer.y >= enemigo.global_position.y:
				GlobalStats.zindexPlayer = 3
			elif GlobalStats.positionPlayer.y <= enemigo.global_position.y:
				GlobalStats.zindexPlayer = 1
