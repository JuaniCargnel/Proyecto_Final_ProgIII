extends Label

@export var full_text: String = "Hola, este es un ejemplo de texto que aparece letra por letra."
@export var letter_delay: float = 0.05  # Tiempo entre cada letra
@export var text_delay: float = 1.0     # Tiempo de espera entre textos

var char_index: int = 0

func _ready() -> void:
	text = ""
	await type_text()                    # Escribe el primer texto
	await get_tree().create_timer(text_delay).timeout  # Espera text_delay segundos
	start_next_text()                    # Inicia el siguiente texto

func type_text() -> void:
	while char_index < full_text.length():
		text += full_text[char_index]
		char_index += 1
		await get_tree().create_timer(letter_delay).timeout

func start_next_text() -> void:
	# Segundo texto
	print("Ha pasado ", text_delay, " segundos, ahora se inicia el segundo texto.")
	full_text = "Este es el segundo texto."
	char_index = 0
	text = ""
	await type_text()
	
	# Espera text_delay segundos antes del tercer texto
	await get_tree().create_timer(text_delay).timeout
	print("Ha pasado ", text_delay, " segundos, ahora se inicia el tercer texto.")
	
	# Tercer texto
	full_text = "Este es el tercer texto."
	char_index = 0
	text = ""
	await type_text()
