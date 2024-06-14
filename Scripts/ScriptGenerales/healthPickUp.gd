extends Area2D

func _process(_delta): # Procesa el z index segun la posicion en Y. Si alive es false lo borra para comodidad en el zoom de la camara del player
	z_index = round(global_position.y)
	if !GlobalStats.alive:
		queue_free()

func _on_body_entered(body): # Cuando el body entra lo cura segun la vida maxima. Las cantidades dependen de la vida actual del jugador
	if body.is_in_group("player"):
		var plusLife = GlobalStats.maxLife * 0.25
		$Pickup.play()
		$Timer.start()
		if GlobalStats.playerLife < GlobalStats.maxLife:
			if GlobalStats.playerLife + plusLife > GlobalStats.maxLife:
				GlobalStats.playerLife = GlobalStats.maxLife
			else: 
				GlobalStats.playerLife += plusLife

func _on_timer_timeout(): # Elimina de la pool  (array) de pickups activos y luego lo borra de la queue
	GlobalStats.maxPickUpsScreen.erase(self)
	queue_free()
