extends Node

func _ready():
	# Carregar a classe Saldo
	var Saldo = preload("res://Scrips/Jogo de tabuleiro/ClasseSaldo.gd")
	
	# Criar uma instância de Saldo com saldo inicial de 100
	var meu_saldo = Saldo.new()
	
	# Teste 1: Mostrar saldo inicial
	print("Saldo inicial:", meu_saldo.mostrar_saldo())  # Deve imprimir 100.0
	
	# Teste 2: Aumentar o saldo
	meu_saldo.aumentar_saldo(50.0)
	print("Saldo após aumento:", meu_saldo.mostrar_saldo())  # Deve imprimir 150.0
	
	# Teste 3: Subtrair do saldo
	meu_saldo.subtrair_saldo(75.0)
	print("Saldo após subtração:", meu_saldo.mostrar_saldo())  # Deve imprimir 75.0
	
	# Teste 4: Tentar subtrair mais do que o saldo disponível
	meu_saldo.subtrair_saldo(100.0)  # Deve exibir "Saldo insuficiente!"
	print("Saldo final:", meu_saldo.mostrar_saldo())  # Deve continuar sendo 75.0
