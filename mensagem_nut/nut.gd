extends Node2D

@onready var label: Label = $Label
@onready var input_field: LineEdit = $LineEdit  # Input para o valor do depósito

var player_in_area: bool = false
var awaiting_choice: bool = false
var awaiting_input: bool = false

#func _ready() -> void:
	#label.visible = false
	#input_field.visible = false  # Esconde o campo de input inicialmente

func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interect"):
		label.text = "Depositar dinheiro (Sim(S))/(Não(N))"
		label.visible = true
		awaiting_choice = true

	if awaiting_choice:
		if Input.is_action_just_pressed("ui_accept"):  # "S" para Sim
			label.text = "Digite o valor a ser depositado:"
			input_field.visible = true
			input_field.grab_focus()  # Foco no campo de input
			awaiting_choice = false
			awaiting_input = true
		elif Input.is_action_just_pressed("ui_cancel"):  # "N" para Não
			exit_interaction()

	if awaiting_input and Input.is_action_just_pressed("ui_accept"):  # Enter para confirmar depósito
		var deposit_amount = float(input_field.text)
		deposit_money(deposit_amount)
		input_field.clear()
		input_field.visible = false
		awaiting_input = false
		label.text = "Depósito realizado! Jogo salvo automaticamente."
		save_game()
		await get_tree().create_timer(1.5).timeout  # Usando await em vez de yield
		label.visible = false

func deposit_money(amount: float) -> void:
	# Aqui você pode adicionar o código para atualizar o saldo do jogador com o valor depositado
	print("Valor depositado:", amount)

func save_game() -> void:
	# Função para salvar o jogo
	print("Jogo salvo.")

func exit_interaction() -> void:
	label.text = "Interação encerrada."
	await get_tree().create_timer(1.5).timeout  # Usando await em vez de yield
	label.visible = false

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
		awaiting_input = false
