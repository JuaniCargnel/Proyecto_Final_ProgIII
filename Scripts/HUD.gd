extends CanvasLayer

func _process(_delta):
	animations()
	life_bar()
	stamina_bar()

func animations():
	$Display/FondoDisplay/AnimatedSprite2D.play(str(GlobalStats.animacion))

func life_bar():
	$Health/HealthBar.max_value = GlobalStats.maxLife
	$Health/HealthBar.value = GlobalStats.playerLife

func stamina_bar():
	$Stamina/StaminaBar.max_value = GlobalStats.maxStamina
	$Stamina/StaminaBar.value = GlobalStats.playerStamina