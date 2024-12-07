extends Control
class_name tabuleiroclass

@onready var botao_proximo_turno: Button = $BotaoProximoTurno

var _current_carta_sprite: Sprite2D = null
var acoes_lista: Array = []  
var saldo: saldos
var menu: MenuDeAcoes

func D6() -> int:
	return floor(randf_range(1, 6))

func D66() -> int:
	return floor(randf_range(-6, 6))

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
	
	atualizar_valores_acoes()

func atualizar_valores_acoes():
	$"SituaçAçãoTrans/ValorAçãoTrans".text = "R$ %.2f" % acoes_lista[0].preco
	$"SituaçAçãoSider/ValorAçãoSider".text = "R$ %.2f" % acoes_lista[1].preco
	$"SituaçAçãoTecno/ValorAçãoTecno".text = "R$ %.2f" % acoes_lista[2].preco
	$"SituaçAçãoSaúde/ValorAçãoSau".text = "R$ %.2f" % acoes_lista[3].preco
	$"SituaçAçãoAlimen/ValorAçãoAlime".text = "R$ %.2f" % acoes_lista[4].preco

func subida(acao: acoes) -> void:
	acao.preco += D6()

func queda(acao: acoes) -> void:
	acao.preco -= D6()

func volatil(acao: acoes) -> void:
	acao.preco += D66()

func mudar_valor_acoes(nicho1: String, resultado1: bool):
	var acao1 = _buscar_acao_por_nicho(nicho1)
	if not acao1:
		return
	
	if resultado1 == true:
		subida(acao1)
	else:
		queda(acao1)
	
	for acao in acoes_lista:
		if acao.nicho != acao1.nicho:
			volatil(acao)
	
	atualizar_valores_acoes()

func _buscar_acao_por_nicho(nicho: String) -> acoes:
	for acao in acoes_lista:
		if acao.nicho == nicho:
			return acao
	return null

func nova_rodada():
	if _current_carta_sprite:
		remove_child(_current_carta_sprite)
		_current_carta_sprite.queue_free()
		_current_carta_sprite = null

	var cartas_sorteadas = sortear_cartas(1)
	var nova_carta = cartas_sorteadas[0]

	mudar_valor_acoes(nova_carta.nicho, nova_carta.informacao)
	exibir_carta(nova_carta)

func sortear_cartas(quantidade: int) -> Array:
	var cartas = []
	var nichos_possiveis = ["Transporte", "Siderúrgica", "Tecnologia", "Saúde", "Alimentação"]
	for i in range(quantidade):
		var nicho_aleatorio = nichos_possiveis[randi() % nichos_possiveis.size()]
		var informacao_aleatoria = randf() > 0.5
		cartas.append(carta_informacao.new(nicho_aleatorio, informacao_aleatoria))
	return cartas

func exibir_carta(carta: carta_informacao):
	var sprite = Sprite2D.new()
	match carta.nicho:
		"Transporte":
			if carta.informacao:
				sprite.texture = preload("res://assents/Cartas/_Carta em alta Transporte.png")
			else:
				sprite.texture = preload("res://assents/Cartas/Carta em baixa Transporte.png")
		"Siderúrgica":
			if carta.informacao:
				sprite.texture = preload("res://assents/Cartas/Carta em alta Siderúrgica.png")
			else:
				sprite.texture = preload("res://assents/Cartas/Carta em Baixa Siderúrgica.png")
		"Tecnologia":
			if carta.informacao:
				sprite.texture = preload("res://assents/Cartas/Carta em alta Tecnologia.png")
			else:
				sprite.texture = preload("res://assents/Cartas/Cópia de Carta em Baixa Tecnologia.png")
		"Saúde":
			if carta.informacao:
				sprite.texture = preload("res://assents/Cartas/_ Carta em alta Saúde.png")
			else:
				sprite.texture = preload("res://assents/Cartas/_Carta em baixa Saúde.png")
		"Alimentação":
			if carta.informacao:
				sprite.texture = preload("res://assents/Cartas/Carta em alta Alimentação.png")
			else:
				sprite.texture = preload("res://assents/Cartas/Carta em baixa Alimentação.png")

	var janela_tamanho = get_viewport().get_visible_rect().size
	sprite.position = janela_tamanho - Vector2(sprite.texture.get_size().x * -0.3 + 20, sprite.texture.get_size().y * 0.4 + 20)
	sprite.scale = Vector2(0.8, 0.8)
	add_child(sprite)
	_current_carta_sprite = sprite

func _ready() -> void:
	botao_proximo_turno.connect("pressed", Callable(self, "nova_rodada"))
	var label_saldo_valor: Label = $Sprite2D/SaldoValor
	saldo = saldos.new(100.0)
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()

	menu = MenuDeAcoes.new()
	menu.configurar(self, saldo)
	inicializar_acoes()
	
	var quantiAcaoAlim: int=0
	var quantiAcaoSider: int=0
	var quantiAcaoTecno: int=0
	var quantiAcaoTrans: int=0
	var quantiAcaoSau: int=0
	
	var btn_comprar = $ticketAlimentacao/btnComprar
	
	var label_valor_alim: Label = $ticketAlimentacao/valorInvestido
	label_valor_alim.text = "R$ %.2f" % menu.calcular_preco_total("Alimentação",quantiAcaoAlim)
	
	var label_valor_sider: Label = $ticketSiderúgica/valorInvestido
	label_valor_sider.text = "R$ %.2f" % menu.calcular_preco_total("Siderúrgica",quantiAcaoAlim)
	
	var label_valor_tecno: Label = $ticketTecnologia/valorInvestido
	label_valor_tecno.text = "R$ %.2f" % menu.calcular_preco_total("Tecnologia",quantiAcaoAlim)
	
	var label_valor_trasp: Label = $ticketTrasporte/valorInvestido
	label_valor_trasp.text = "R$ %.2f" % menu.calcular_preco_total("Transporte",quantiAcaoAlim)
	
	var label_valor_sau: Label = $ticketSaúde/valorInvestido
	label_valor_sau.text = "R$ %.2f" % menu.calcular_preco_total("Saúde",quantiAcaoAlim)
	
	

	print("Ações iniciais:")
	for acao in acoes_lista:
		print("Nicho: %s, Preço: %f" % [acao.nicho, acao.preco])

	var cartas_sorteadas = sortear_cartas(1)
	for carta in cartas_sorteadas:
		print("Carta sorteada - Nicho: %s, Impacto Positivo: %s" % [carta.nicho, str(carta.informacao)])
		mudar_valor_acoes(carta.nicho, carta.informacao)

	exibir_carta(cartas_sorteadas[0])

	print("---------------------------------------------------------------------------------------------")
	print("Ações após aplicação da carta:")
	for acao in acoes_lista:
		print("Nicho: %s, Preço: %f" % [acao.nicho, acao.preco])
