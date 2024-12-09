extends Node2D

@onready var cena_final_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/cena_final  # Caminho correto do botão

# Função chamada automaticamente quando o botão for pressionado
func _on_cena_final_pressed() -> void:
	# Troca de cena quando o botão for pressionado
	get_tree().change_scene_to_file("res://Cenas/Atos/cena_final.tscn")
