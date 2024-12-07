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
	#if nicho_atual == "":
		#print("Selecione um nicho antes de comprar!")
		#return

	var preco_total = calcular_preco_total(nicho_atual, quantidade_atual)
	if saldo_ref.subtrair_saldo(preco_total):
		print("Compra realizada: %d ações de %s por %f cada." % [quantidade_atual, nicho_atual, preco_total / quantidade_atual])
	else:
		print("Compra não realizada. Saldo insuficiente.")
# Calcula o valor total da venda
func calcular_valor_total_venda(nicho: String, quantidade: int) -> float:
	var acao = tabuleiro_ref._buscar_acao_por_nicho(nicho)
	if not acao:
		print("Ação não encontrada!")
		return 0.0

	return acao.preco * quantidade

# Vende a ação com base na quantidade atual
func vender_acao() -> void:
	if nicho_atual == "":
		print("Selecione um nicho antes de vender!")
		return

	var acao = tabuleiro_ref._buscar_acao_por_nicho(nicho_atual)
	if not acao:
		print("Ação não encontrada no tabuleiro.")
		return

	if acao.quantidade < quantidade_atual:
		print("Venda não realizada. Quantidade insuficiente de ações.")
		return

	var valor_total = calcular_valor_total_venda(nicho_atual, quantidade_atual)
	acao.quantidade -= quantidade_atual
	saldo_ref.adicionar_saldo(valor_total)
	print("Venda realizada: %d ações de %s por %f cada." % [quantidade_atual, nicho_atual, valor_total / quantidade_atual])

# Atualiza a quantidade e exibe o valor total para venda em tempo real
func atualizar_valor_em_tempo_real_venda(nicho: String, quantidade: int) -> void:
	nicho_atual = nicho
	quantidade_atual = quantidade
	var valor_total = calcular_valor_total_venda(nicho, quantidade)
	print("Valor total para vender %d ações de %s: %f" % [quantidade, nicho, valor_total])
