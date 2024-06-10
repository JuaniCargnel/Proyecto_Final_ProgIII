extends CanvasLayer

func _ready():
	$Display/FondoDisplay/AnimatedSprite2D.modulate = Color(GlobalStats.hexColor)

func _process(_delta):
	animations()
	life_bar()
	stamina_bar()
	sword_bar()

func animations():
	$Display/FondoDisplay/AnimatedSprite2D.play(str(GlobalStats.animacion))

func life_bar():
	$Health/HealthBar.max_value = GlobalStats.maxLife
	$Health/HealthBar.value = GlobalStats.playerLife

func stamina_bar():
	$Stamina/StaminaBar.max_value = GlobalStats.maxStamina
	$Stamina/StaminaBar.value = GlobalStats.playerStamina

func sword_bar():
	$Sword/SwordBar.max_value = GlobalStats.maxSwordTime
	$Sword/SwordBar.value = GlobalStats.swordTime

func _on_pause_pressed():
	get_tree().paused = true
