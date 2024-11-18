extends Node2D

@onready var manuseio_dinheiro = get_node("/root/Principal/ManuseioDinheiro")
@onready var contagem_rodadas = get_node("/root/Principal/ContagemRodadas")

# funcao p/ ativar uma carta de acao
func ativar_carta_acao(tipo_acao: String) -> void:
	match tipo_acao:
		"aumento_dinheiro":
			manuseio_dinheiro.adicionar_dinheiro(100)
		"diminui_rodada":
			contagem_rodadas.proxima_rodada()
		# irei add outros tipos de acoes conforme necessario
		_:
			print("Ação desconhecida!")

# funcao p/ exibir uma carta de informacao
func exibir_carta_informacao(mensagem: String) -> void:
	var ui = get_node("/root/Principal/UIManager")
	ui.exibir_mensagem(mensagem)
