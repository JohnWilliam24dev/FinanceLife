extends Control
class_name tabuleiroclass

@onready var botao_proximo_turno: Button = $BotaoProximoTurno
@onready var lucro: Sprite2D = $Lucro

var _current_carta_sprite: Sprite2D = null
var quantiAcaoAlim: int=abs(0)
var quantiAcaoSider: int=abs(0)
var quantiAcaoTecno: int=abs(0)
var quantiAcaoTrans: int=abs(0)
var quantiAcaoSau: int=abs(0)
var carta_anterior: carta_informacao = null

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

func mudar_valor_acoes(carta: carta_informacao):
	var acao1 = _buscar_acao_por_nicho(carta.nicho)
	if not acao1:
		print("Erro: Ação não encontrada para nicho '%s'" % carta.nicho)
		return
	
	if carta.informacao:
		print("Subida para o nicho '%s'" % acao1.nicho)
		subida(acao1)  # Aumenta o valor da ação
	else:
		print("Queda para o nicho '%s'" % acao1.nicho)
		queda(acao1)  # Reduz o valor da ação
	
	print("Preço após impacto direto: R$ %.2f" % acao1.preco)
	
	# Volatilidade nas outras ações
	for acao in acoes_lista:
		if acao.nicho != acao1.nicho:
			print("Volatilidade para o nicho '%s'" % acao.nicho)
			volatil(acao)
			print("Novo preço do nicho '%s': R$ %.2f" % [acao.nicho, acao.preco])
	
	# Atualiza os valores na interface
	atualizar_valores_acoes()

func _buscar_acao_por_nicho(nicho: String) -> acoes:
	for acao in acoes_lista:
		if acao.nicho == nicho:
			return acao
	return null

func nova_rodada():
	# Remove a carta exibida anteriormente, se houver
	if _current_carta_sprite:
		remove_child(_current_carta_sprite)
		_current_carta_sprite.queue_free()
		_current_carta_sprite = null

	# Aplica o impacto da carta anterior (se houver)
	if carta_anterior != null:
		print("Aplicando impacto da carta anterior: %s" % carta_anterior.nicho)
		mudar_valor_acoes(carta_anterior)

	# Sorteia uma nova carta e exibe sem aplicar impacto ainda
	var cartas_sorteadas = sortear_cartas(1)
	carta_anterior = cartas_sorteadas[0]
	print("Nova carta sorteada: %s" % carta_anterior.nicho)
	exibir_carta(carta_anterior)

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

# Função para atualizar o lucro
func atualizar_lucro():
	var lucro_atual = saldo.puxar_saldo() - 100.0
	var label_lucro: Label = $Lucro/LucroAtual
	label_lucro.text = "R$ %.2f" % lucro_atual

func _ready() -> void:
	botao_proximo_turno.connect("pressed", Callable(self, "nova_rodada"))
	
	saldo = saldos.new(100.0)
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()

	menu = MenuDeAcoes.new()
	menu.configurar(self, saldo)
	inicializar_acoes()
	
	var label_Lucro_Atual: Label = $Lucro/LucroAtual
	atualizar_lucro()  # Atualiza o lucro inicial
	
	# Inicializa valores dos investimentos
	$ticketAlimentacao/valorInvestido.text = "R$ 0,00"
	$ticketSiderúgica/valorInvestido.text = "R$ 0,00"
	$ticketTecnologia/valorInvestido.text = "R$ 0,00"
	$ticketTrasporte/valorInvestido.text = "R$ 0,00"
	$ticketSaúde/valorInvestido.text = "R$ 0,00"

	print("Ações iniciais:")
	for acao in acoes_lista:
		print("Nicho: %s, Preço: %f" % [acao.nicho, acao.preco])
		
	# Inicia o jogo com a primeira rodada
	nova_rodada()
	print("Inicialização do Tabuleiro.")


#Metodos de Realizar comprar
# Função para verificar a vitória e mudar para a cena de vitória
func verificar_vitoria():
	if saldo.puxar_saldo() >= 500:  # Verifica se o saldo é maior ou igual a 1000
		get_tree().change_scene_to_file("res://Cenas/Atos/Cena_vitória.tscn")  # Troca de cena para a vitória


func _on_btn_comprar_alim_pressed() -> void:
	
	var label_valor_alim: Label = $ticketAlimentacao/valorInvestido
	label_valor_alim.text = "R$ %.2f" % menu.calcular_preco_total("Alimentação",quantiAcaoAlim)
	print("R$ %.2f" % saldo.puxar_saldo())
	menu.comprar_acao("Alimentação",quantiAcaoAlim)
	label_valor_alim.text = "R$ %.2f" % menu.calcular_preco_total("Alimentação",quantiAcaoAlim)
	var label_saldo_valor: Label = $Sprite2D/SaldoValor
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	atualizar_lucro()
	
	

func _on_btn_comprar_side_pressed() -> void:
	var label_valor_sider: Label = $ticketSiderúgica/valorInvestido
	label_valor_sider.text = "R$ %.2f" % menu.calcular_preco_total("Siderúrgica",quantiAcaoSider)
	menu.comprar_acao("Siderúrgica",quantiAcaoSider)
	label_valor_sider.text = "R$ %.2f" % menu.calcular_preco_total("Siderúrgica",quantiAcaoSider)
	var label_saldo_valor: Label = $Sprite2D/SaldoValor
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	print("R$ %.2f" % saldo.puxar_saldo())
	atualizar_lucro()


func _on_btn_comprar_tecno_pressed() -> void:
	var label_valor_tecno: Label = $ticketTecnologia/valorInvestido
	label_valor_tecno.text = "R$ %.2f" % menu.calcular_preco_total("Tecnologia",quantiAcaoTecno)
	menu.comprar_acao("Tecnologia",quantiAcaoTecno)
	label_valor_tecno.text = "R$ %.2f" % menu.calcular_preco_total("Tecnologia",quantiAcaoTecno)
	var label_saldo_valor: Label = $Sprite2D/SaldoValor
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	atualizar_lucro()

func _on_btn_comprar_trans_pressed() -> void:
	var label_valor_trasp: Label = $ticketTrasporte/valorInvestido
	label_valor_trasp.text = "R$ %.2f" % menu.calcular_preco_total("Transporte",quantiAcaoTrans)
	menu.comprar_acao("Transporte",quantiAcaoTrans)
	label_valor_trasp.text = "R$ %.2f" % menu.calcular_preco_total("Transporte",quantiAcaoTrans)
	var label_saldo_valor: Label = $Sprite2D/SaldoValor
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	atualizar_lucro()


func _on_btn_comprar_sau_pressed() -> void:
	var label_valor_sau: Label = $ticketSaúde/valorInvestido
	label_valor_sau.text = "R$ %.2f" % menu.calcular_preco_total("Saúde",quantiAcaoSau)
	menu.comprar_acao("Saúde",quantiAcaoSau)
	label_valor_sau.text = "R$ %.2f" % menu.calcular_preco_total("Saúde",quantiAcaoSau)
	var label_saldo_valor: Label = $Sprite2D/SaldoValor
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	atualizar_lucro()
	
# Métodos de realizar vendas unitárias
func _on_btn_vender_alim_pressed() -> void:
	var label_valor_alim: Label = $ticketAlimentacao/valorInvestido
	if quantiAcaoAlim==0:
		label_valor_alim.text="R$ %.2f" % 0.00
		return
	elif  quantiAcaoAlim==1:
		menu.vender_acao("Alimentação",quantiAcaoAlim)
		label_valor_alim.text="R$ %.2f" % 0.00
		return
	else:
		label_valor_alim.text = "R$ %.2f" % menu.calcular_preco_total("Alimentação", quantiAcaoAlim)
	menu.vender_acao("Alimentação",quantiAcaoAlim -1)
	label_valor_alim.text = "R$ %.2f" % menu.calcular_preco_total("Alimentação", quantiAcaoAlim)
	var label_saldo_valor: Label = $Sprite2D/SaldoValor
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	print("R$ %.2f" % saldo.puxar_saldo())
	print(quantiAcaoAlim)
	atualizar_lucro()
	
func _on_btn_vender_side_pressed() -> void:
	var label_valor_sider: Label = $ticketSiderúgica/valorInvestido
	if quantiAcaoSider==0:
		label_valor_sider.text="R$ %.2f" % 0.00
		return
	elif  quantiAcaoSider==1:
		menu.vender_acao("Siderúrgica",quantiAcaoSider)
		label_valor_sider.text="R$ %.2f" % 0.00
		return
	else:
		label_valor_sider.text = "R$ %.2f" % menu.calcular_preco_total("Siderúrgica", quantiAcaoSider)
	menu.vender_acao("Siderúrgica",quantiAcaoSider -1 )
	label_valor_sider.text = "R$ %.2f" % menu.calcular_preco_total("Siderúrgica", quantiAcaoSider)
	var label_saldo_valor: Label = $Sprite2D/SaldoValor
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	atualizar_lucro()
	
func _on_btn_vender_tecno_pressed() -> void:
	var label_valor_tecno: Label = $ticketTecnologia/valorInvestido
	if quantiAcaoTecno==0:
		label_valor_tecno.text="R$ %.2f" % 0.00
		return
	elif  quantiAcaoTecno==1:
		menu.vender_acao("Tecnologia",quantiAcaoTecno)
		label_valor_tecno.text="R$ %.2f" % 0.00
		return
	else:
		label_valor_tecno.text = "R$ %.2f" % menu.calcular_preco_total("Tecnologia", quantiAcaoTecno)
	menu.vender_acao("Tecnologia",quantiAcaoTecno -1)
	label_valor_tecno.text = "R$ %.2f" % menu.calcular_preco_total("Tecnologia", quantiAcaoTecno)
	var label_saldo_valor: Label = $Sprite2D/SaldoValor
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	atualizar_lucro()
	
func _on_btn_vender_trans_pressed() -> void:
	var label_valor_transp: Label = $ticketTrasporte/valorInvestido
	if quantiAcaoTrans==0:
		label_valor_transp.text="R$ %.2f" % 0.00
		return
	elif  quantiAcaoTrans==1:
		menu.vender_acao("Transporte",quantiAcaoTrans)
		label_valor_transp.text="R$ %.2f" % 0.00
		return
	else:
		label_valor_transp.text = "R$ %.2f" % menu.calcular_preco_total("Transporte", quantiAcaoTrans)
	menu.vender_acao("Transporte",quantiAcaoTrans -1)
	label_valor_transp.text = "R$ %.2f" % menu.calcular_preco_total("Transporte", quantiAcaoTrans)
	var label_saldo_valor: Label = $Sprite2D/SaldoValor
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	atualizar_lucro()
	
func _on_btn_vender_sau_pressed() -> void:
	var label_valor_sau: Label = $ticketSaúde/valorInvestido
	if quantiAcaoSau==0:
		label_valor_sau.text="R$ %.2f" % 0.00
		return
	elif  quantiAcaoSau==1:
		menu.vender_acao("Saúde",quantiAcaoSau )
		label_valor_sau.text="R$ %.2f" % 0.00
		return
	else:
		label_valor_sau.text = "R$ %.2f" % menu.calcular_preco_total("Saúde", quantiAcaoSau)
	menu.vender_acao("Saúde",quantiAcaoSau - 1)
	label_valor_sau.text = "R$ %.2f" % menu.calcular_preco_total("Saúde", quantiAcaoSau)
	var label_saldo_valor: Label = $Sprite2D/SaldoValor
	label_saldo_valor.text = "R$ %.2f" % saldo.puxar_saldo()
	atualizar_lucro()
	
