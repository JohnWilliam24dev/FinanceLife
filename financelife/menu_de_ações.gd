extends Object
class_name MenuDeAcoes

var tabuleiro_ref  # Referência ao tabuleiro
var saldo_ref  # Referência ao saldo
var quantidade_atual: int = 1  # Quantidade de ações a ser comprada
var nicho_atual: String = ""  # Nicho selecionado

# Configura as referências necessárias
func configurar(tabuleiro: tabuleiroclass, saldo: saldos) -> void:
	tabuleiro_ref = tabuleiro
	saldo_ref = saldo

# Atualiza o custo em tempo real
func calcular_preco_total(nicho: String, quantidade: int) -> float:
	var acao = tabuleiro_ref._buscar_acao_por_nicho(nicho)
	if not acao:
		print("Ação não encontrada!")
		return 0.0

	return acao.preco * quantidade

# Atualiza a quantidade e exibe o preço total
func atualizar_preco_em_tempo_real(nicho: String, quantidade: int) -> void:
	nicho_atual = nicho
	quantidade_atual = quantidade
	var preco_total = calcular_preco_total(nicho, quantidade)
	print("Preço total para comprar %d ações de %s: %f" % [quantidade, nicho, preco_total])

# Compra a ação com base na quantidade atual
func comprar_acao() -> void:
	if nicho_atual == "":
		print("Selecione um nicho antes de comprar!")
		return

	var preco_total = calcular_preco_total(nicho_atual, quantidade_atual)
	if saldo_ref.subtrair_saldo(preco_total):
		print("Compra realizada: %d ações de %s por %f cada." % [quantidade_atual, nicho_atual, preco_total / quantidade_atual])
	else:
		print("Compra não realizada. Saldo insuficiente.")
