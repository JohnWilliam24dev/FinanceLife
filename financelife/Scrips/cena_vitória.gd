extends Node2D

@onready var cena_final_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/cena_final  # Caminho correto do botão

func _ready() -> void:
	# Conectando o sinal 'pressed' do botão 'cena_final_button' ao método '_on_cena_final_pressed'
	cena_final_button.connect("pressed", self, "_on_cena_final_pressed")

# Função chamada ao pressionar o botão "cena_final"
func _on_cena_final_pressed() -> void:
	# Troca de cena quando o botão for pressionado
	get_tree().change_scene_to_file("res://Cenas/Atos/cena_final.tscn")
