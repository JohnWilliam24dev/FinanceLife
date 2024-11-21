extends Node2D

@onready var label: Label = $Label


var player_in_area: bool = false
var awaiting_choice: bool = false

func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interect"):
		label.text = "Você quer jogar? (Sim(S))/(Não(N))"
		awaiting_choice = true

	#if awaiting_choice:
		#if Input.is_action_just_pressed("accept"): # Assumindo que "ui_accept" está mapeado para "S"
			#go_to_battle()
			#awaiting_choice = false
		#elif Input.is_action_just_pressed("cancel"): # Assumindo que "ui_cancel" está mapeado para "N"
			#exit_interaction()
			#awaiting_choice = false

#func go_to_battle() -> void:
	#label.text = "Indo para a batalha..."
	#await(get_tree().create_timer(1.0), "timeout") # Pequeno atraso antes de trocar a cena
	#get_tree().change_scene("res://CENA_3_BATALHA.tscn")

#func exit_interaction() -> void:
	#label.text = "Interação encerrada."
	#await(get_tree().create_timer(1.5), "timeout")
	#label.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		player_in_area = true
		label.visible = true
		label.text = "Pressione 'E' para interagir."

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		player_in_area = false
		label.visible = false
		awaiting_choice = false
