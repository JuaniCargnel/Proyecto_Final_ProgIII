extends Area2D

var speed = 100
var direction = 0

func _process(delta): # Elimina la fireball de la queue si el jugador no esta vivo (para la animacion de muerte y de win)
	if !GlobalStats.alive:
		queue_free()
	global_position += direction * speed * delta

func _on_body_entered(body): # Le hace daño al jugador al entrar a su area
	if body.is_in_group("player"):
		GlobalStats.recibirDanio = true
		GlobalStats.playerLife -= 2 * GlobalStats.enemyDmgIncress 

func _on_body_exited(body):
	if body.is_in_group("player"):
		GlobalStats.recibirDanio = false

func _on_visible_on_screen_notifier_2d_screen_exited(): # Elimina la fireball al salir de la pantalla para optimizar los recursos
	queue_free()
