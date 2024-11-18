extends Node

var rodada: int = 1  # inicia a contagem de rodadas

# func p/ incremeta a rodada
func proxima_rodada() -> void:
	rodada += 1
	atualizar_rodada()

# funcaoo para exibir o numero rodada na interface
func atualizar_rodada() -> void:
	var label_rodada = get_node("/root/Principal/ValorRodadaLabel")  # caminho do 'no' interface
	label_rodada.text = "Rodada: %d" % rodada
