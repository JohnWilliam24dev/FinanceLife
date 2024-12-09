extends Control

@onready var timer: Timer = $Timer  # Acessando o Timer, que deve estar na cena

# Chamado quando o nó entra na árvore de cena pela primeira vez
func _ready() -> void:
	timer.start(10)  # Inicia o temporizador com 10 segundos

# Chamado a cada quadro. 'delta' é o tempo decorrido desde o quadro anterior.
func _process(delta: float) -> void:
	pass

# Função chamada quando o temporizador termina
func _on_Timer_timeout():
	get_tree().change_scene_to_file("res://Cenas/Cena_Fina
