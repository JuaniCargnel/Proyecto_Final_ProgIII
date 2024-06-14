extends CanvasLayer

# Muestra los creditos (Los sfx no estan colocados ya que son demasiados. 
# Los assets no utilizados en el proyecto visible no estan colocados pero si en los diversos notepads de las carpetas

func _on_regresar_pressed():
	visible = false

func _on_regresar_mouse_entered():
	$SFXButtons.play()
