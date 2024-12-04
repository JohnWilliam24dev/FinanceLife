extends Control
class_name tabuleiroclass

var acoes_lista: Array = []  
var saldo: saldos
var menu: MenuDeAcoes
func D6() -> int:
	return floor(randf_range(1, 6))
func D8() -> int:
	return floor(randf_range(4, 8))
func adicionar_acao(nicho: String, preco: float):
	var nova_acao = acoes.new(nicho, preco)
	acoes_lista.append(nova_acao)
func inicializar_acoes():
	adicionar_acao("Transporte", D8())
	adicionar_acao("Siderúrgica", D8())
	adicionar_acao("Tecnologia", D8())
	adicionar_acao("Saúde", D8())
	adicionar_acao("Alimentação", D8())
	
	var label_saldo_valor: Label 
	label_saldo_valor = $Sprite2D/SaldoValor
	


func subida(acao: acoes) -> void:
	acao.preco += D6()

func queda(acao: acoes) -> void:
	acao.preco -= D6()

func mudar_valor_acoes(nicho1: String, resultado1: bool, nicho2: String, resultado2: bool):
	var acao1 = _buscar_acao_por_nicho(nicho1)
	var acao2 = _buscar_acao_por_nicho(nicho2)
	
	if not acao1 or not acao2:
		return  
	
	if nicho1 == nicho2 and resultado1 == resultado2:
		if resultado1:
			subida(acao1)
		else:
			queda(acao1)
	elif nicho1 != nicho2 and resultado1 != resultado2:
		if resultado1:
			subida(acao1)
			queda(acao2)
		else:
			queda(acao1)
			subida(acao2)
	elif nicho1 != nicho2 and resultado1 == resultado2:
		if resultado1:
			subida(acao1)
			subida(acao2)
		else:
			queda(acao1)
			queda(acao2)

func _buscar_acao_por_nicho(nicho: String) -> acoes:
	for acao in acoes_lista:
		if acao.nicho == nicho:
			return acao
	return null



func _ready() -> void:
	var label_saldo_valor: Label #Criar a conexão entre o Label e o codigo
	label_saldo_valor = $Sprite2D/SaldoValor
	 
	saldo = saldos.new(1000.0)  # O jogador começa com 1000 de saldo
	
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	

	# Inicializar menu de ações
	menu = MenuDeAcoes.new()
	menu.configurar(self, saldo)

	# Inicializar ações
	inicializar_acoes()

	# Exibir ações iniciais
	print("Ações iniciais:")
	for acao in acoes_lista:
		print("Nicho: %s, Preço: %f" % [acao.nicho, acao.preco])

	# Cartas fictícias para alterar valores
	var carta1 = carta_informacao.new("Transporte", true)
	var carta2 = carta_informacao.new("Saúde", false)
	mudar_valor_acoes(carta1.nicho, carta1.informacao, carta2.nicho, carta2.informacao)

	# Exibir ações atualizadas
	print("---------------------------------------------------------------------------------------------")
	print("Ações atualizadas:")
	for acao in acoes_lista:
		print("Nicho: %s, Preço: %f" % [acao.nicho, acao.preco])

	# Teste de menu de ações
	menu.atualizar_preco_em_tempo_real("Tecnologia", 3)
	menu.comprar_acao()
	print("Saldo final: %f" % saldo.puxar_saldo())
