extends Control
class_name tabuleiroclass

@onready var botao_proximo_turno: Button = $BotaoProximoTurno

var _current_carta_sprite: Sprite2D = null
var quantiAcaoAlim: int=1
var quantiAcaoSider: int=1
var quantiAcaoTecno: int=1
var quantiAcaoTrans: int=1
var quantiAcaoSau: int=1

@onready var label_saldo_valor: Label = $Sprite2D/SaldoValor

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
	sprite.position = janela_tamanho - Vector2(sprite.texture.get_size().x * 0.5 + 20, sprite.texture.get_size().y * 0.55 + 20)
	sprite.scale = Vector2(0.8, 0.8)
	add_child(sprite)
	_current_carta_sprite = sprite

func _ready() -> void:
	botao_proximo_turno.connect("pressed", Callable(self, "nova_rodada"))
	
	saldo = saldos.new(100.0)
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()

	menu = MenuDeAcoes.new()
	menu.configurar(self, saldo)
	inicializar_acoes()
	
	var label_Lucro_Atual: Label = $Lucro/LucroAtual
	#Criar a instancia do Lucro e imprimir o valor
	#saldo = saldos.new(100.0)
	#label_Lucro_Atual.text = " %.2f" % saldo.puxar_saldo()

	
	var label_valor_alim: Label = $ticketAlimentacao/valorInvestido
	label_valor_alim.text = "R$ %.2f" % menu.calcular_preco_total("Alimentação",quantiAcaoAlim)
	
	var label_valor_sider: Label = $ticketSiderúgica/valorInvestido
	label_valor_sider.text = "R$ %.2f" % menu.calcular_preco_total("Siderúrgica",quantiAcaoSider)
	
	var label_valor_tecno: Label = $ticketTecnologia/valorInvestido
	label_valor_tecno.text = "R$ %.2f" % menu.calcular_preco_total("Tecnologia",quantiAcaoTecno)
	
	var label_valor_trasp: Label = $ticketTrasporte/valorInvestido
	label_valor_trasp.text = "R$ %.2f" % menu.calcular_preco_total("Transporte",quantiAcaoTrans)
	
	var label_valor_sau: Label = $ticketSaúde/valorInvestido
	label_valor_sau.text = "R$ %.2f" % menu.calcular_preco_total("Saúde",quantiAcaoSau)
	
	
	

	print("Ações iniciais:")
	for acao in acoes_lista:
		print("Nicho: %s, Preço: %f" % [acao.nicho, acao.preco])

	var cartas_sorteadas = sortear_cartas(1)
	for carta in cartas_sorteadas:
		print("Carta sorteada - Nicho: %s, Impacto Positivo: %s" % [carta.nicho, str(carta.informacao)])
		

	exibir_carta(cartas_sorteadas[0])

	print("---------------------------------------------------------------------------------------------")
	print("Ações após aplicação da carta:")
	for acao in acoes_lista:
		print("Nicho: %s, Preço: %f" % [acao.nicho, acao.preco])
		
	# Inicializa o saldo e a interface
	saldo = saldos.new(100.0)  # Exemplo de valor inicial
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()

	menu = MenuDeAcoes.new()
	menu.configurar(self, saldo)
	
	# Restante da inicialização do tabuleiro
	print("Inicialização do Tabuleiro.")
	
	# Aqui você pode adicionar uma lógica para começar o jogo
	# e rodar o jogo. Chame a nova_rodada durante o ciclo do jogo.
	nova_rodada()  # Por exemplo, chamada ao iniciar ou após ações do jogador
	

#Metodos de Realizar comprar
# Função para verificar a vitória e mudar para a cena de vitória
func verificar_vitoria():
	if saldo.puxar_saldo() >= 1000:  # Verifica se o saldo é maior ou igual a 1000
		get_tree().change_scene_to_file("res://Cenas/Atos/Cena_vitória.tscn")  # Troca de cena para a vitória


func _on_btn_comprar_alim_pressed() -> void:
	print(1)
	var label_valor_alim: Label = $ticketAlimentacao/valorInvestido
	label_valor_alim.text = "R$ %.2f" % menu.calcular_preco_total("Alimentação",quantiAcaoAlim)
	
	menu.comprar_acao("Alimentação",quantiAcaoAlim)
	
	

func _on_btn_comprar_side_pressed() -> void:
	var label_valor_sider: Label = $ticketSiderúgica/valorInvestido
	label_valor_sider.text = "R$ %.2f" % menu.calcular_preco_total("Siderúrgica",quantiAcaoSider)
	menu.comprar_acao("Siderúrgica",quantiAcaoSider)
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	print("R$ %.2f" % saldo.puxar_saldo())


func _on_btn_comprar_tecno_pressed() -> void:
	var label_valor_tecno: Label = $ticketTecnologia/valorInvestido
	label_valor_tecno.text = "R$ %.2f" % menu.calcular_preco_total("Tecnologia",quantiAcaoTecno)
	menu.comprar_acao("Tecnologia",quantiAcaoTecno)


func _on_btn_comprar_trans_pressed() -> void:
	var label_valor_trasp: Label = $ticketTrasporte/valorInvestido
	label_valor_trasp.text = "R$ %.2f" % menu.calcular_preco_total("Transporte",quantiAcaoTrans)
	menu.comprar_acao("Transporte",quantiAcaoTrans)


func _on_btn_comprar_sau_pressed() -> void:
	var label_valor_sau: Label = $ticketSaúde/valorInvestido
	label_valor_sau.text = "R$ %.2f" % menu.calcular_preco_total("Saúde",quantiAcaoSau)
	menu.comprar_acao("Saúde",quantiAcaoSau)
	
# Métodos de realizar vendas unitárias
func _on_btn_vender_alim_pressed() -> void:
	var label_valor_alim: Label = $ticketAlimentacao/valorInvestido
	label_valor_alim.text = "R$ %.2f" % menu.calcular_preco_total("Alimentação", quantiAcaoAlim)
	menu.vender_acao("Alimentação",quantiAcaoAlim)
func _on_btn_vender_side_pressed() -> void:
	var label_valor_sider: Label = $ticketSiderúgica/valorInvestido
	label_valor_sider.text = "R$ %.2f" % menu.calcular_preco_total("Siderúrgica", quantiAcaoSider)
	menu.vender_acao("Siderúrgica",quantiAcaoSider)
func _on_btn_vender_tecno_pressed() -> void:
	var label_valor_tecno: Label = $ticketTecnologia/valorInvestido
	label_valor_tecno.text = "R$ %.2f" % menu.calcular_preco_total("Tecnologia", quantiAcaoTecno)
	menu.vender_acao("Tecnologia",quantiAcaoTecno)
func _on_btn_vender_trans_pressed() -> void:
	var label_valor_transp: Label = $ticketTrasporte/valorInvestido
	label_valor_transp.text = "R$ %.2f" % menu.calcular_preco_total("Transporte", quantiAcaoTrans)
	menu.vender_acao("Transporte",quantiAcaoTrans)
func _on_btn_vender_sau_pressed() -> void:
	var label_valor_sau: Label = $ticketSaúde/valorInvestido
	label_valor_sau.text = "R$ %.2f" % menu.calcular_preco_total("Saúde", quantiAcaoSau)
	menu.vender_acao("Saúde",quantiAcaoSau)
