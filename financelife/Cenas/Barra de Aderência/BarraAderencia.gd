extends Control

@export var max_value: float = 100.0  # valor maximo da barraAderencia
var current_value: float = 0.0        # valor atual da barra
@onready var progress_bar = $TextureProgressBar

#func para atualizar a barraAderencia com base no investimento atual
func atualizar_barra(valor_investido: float, total_dinheiro: float) -> void:
	if total_dinheiro > 0:
		current_value = (valor_investido / total_dinheiro) * max_value
		progress_bar.value = current_value
	else:
		progress_bar.value = 0.0  # evita divisao por zero

# teste p/ simular update
func _ready():
	atualizar_barra(50.0, 100.0)  # atualiza a barra com 50% de aderencia
