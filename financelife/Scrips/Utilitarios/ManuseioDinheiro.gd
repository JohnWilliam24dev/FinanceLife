extends Node

var dinheiro: int = 1000  # valor inicial de saldo jogador

# funcao para add dinheiro
func adicionar_dinheiro(valor: int) -> void:
	dinheiro += valor
	atualizar_dinheiro()

# funcao para subtrair dinheiro
func subtrair_dinheiro(valor: int) -> void:
	if valor <= dinheiro:
		dinheiro -= valor
		atualizar_dinheiro()
	else:
		print("Dinheiro insuficiente!")

# funcao p/ mostrar valor atual de dinheiro na interface visual
func atualizar_dinheiro() -> void:
	var label_dinheiro = get_node("/root/Principal/ValorDinheiroLabel")  
	label_dinheiro.text = "Dinheiro: %d" % dinheiro
