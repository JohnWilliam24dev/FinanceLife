extends Control
@onready var label = $MarginContainer2/HBoxContainer/ValorTotal  # Acessa o nó Label que você nomeou como ValorTotal
var contador: int = 0

func _ready():
	label.text = "Valor: %d" % contador  # Define o texto inicial do Label

func _on_button_increm_pressed() -> void:
	contador += 1
	label.text = "Valor: %d" % contador  # Atualiza o texto com o novo valor

func _on_button_subtr_pressed() -> void:
	contador -= 1
	label.text = "Valor: %d" % contador  # Atualiza o texto com o novo valor
