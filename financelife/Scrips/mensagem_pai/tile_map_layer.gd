extends TileMapLayer

@onready var label: Label = $Area2D/Label

var player_in_area: bool = false
var awaiting_choice: bool = false

func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interect"):
		label.text = "Filho, descobri um jogo novo \n e muito divertido hoje!\nVamos jogar? (Sim(S))/(Não(N))"
		awaiting_choice = true
		
	if awaiting_choice:
		if Input.is_action_just_pressed("accept"):  # Tecla "S" para aceitar
			go_to_battle()
			awaiting_choice = false
		elif Input.is_action_just_pressed("cancel"):  # Tecla "N" para recusar
			exit_interaction()
			awaiting_choice = false
			
func go_to_battle() -> void:
	label.text = "Indo para o tabuleiro..."
	get_tree().change_scene_to_file("res://Cenas/JogoDeTabuleiro/jogo_de_tabuleiro.tscn")

func exit_interaction() -> void:
	label.text = "Talvez outra hora, filho."
	label.visible = false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		player_in_area = true
		label.visible = true
		label.text = "Pressione 'E' para interagir."
		
# Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		player_in_area = false
		label.visible = false # Replace with function body.
