extends Object
class_name MenuDeAcoes

var tabuleiro_ref:tabuleiroclass  # Referência ao tabuleiro
var saldo_ref:saldos # Referência ao saldo
var quantidade_atual: int = 1  # Quantidade de ações a ser comprada
var nicho_atual: String = ""  # Nicho selecionado
var valor_de_compra:float = 0

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
	elif quantidade==0:
		return 0.0
	return acao.preco * quantidade

# Atualiza a quantidade e exibe o preço total
func atualizar_preco_em_tempo_real(nicho: String, quantidade: int) -> void:
	nicho_atual = nicho
	quantidade_atual = quantidade
	var preco_total = calcular_preco_total(nicho, quantidade)
	print("Preço total para comprar %d ações de %s: %f" % [quantidade, nicho, preco_total])

func get_preco(nicho:String)->float:
	var acao = tabuleiro_ref._buscar_acao_por_nicho(nicho)
	return acao.preco
# Compra a ação com base na quantidade atual
func comprar_acao(nicho:String,quantidade:int) -> void:
	var preco_total = get_preco(nicho)
	valor_de_compra=preco_total
	if saldo_ref.subtrair_saldo(preco_total):
		print("Compra realizada: 1 ação de %s por %f cada." % [ nicho, preco_total / quantidade_atual])
		
	else:
		print("Compra não realizada. Saldo insuficiente.")
		return
	if nicho == "Alimentação":
		tabuleiro_ref.quantiAcaoAlim=tabuleiro_ref.quantiAcaoAlim+1
		return
	elif nicho == "Transporte":
		tabuleiro_ref.quantiAcaoTrans=tabuleiro_ref.quantiAcaoTrans+1
		return
	elif nicho == "Tecnologia":
		tabuleiro_ref.quantiAcaoTecno=tabuleiro_ref.quantiAcaoTecno+1
		return
	elif nicho == "Siderúrgica":
		tabuleiro_ref.quantiAcaoSider=tabuleiro_ref.quantiAcaoSider+1
		return
	elif nicho == "Saúde":
		tabuleiro_ref.quantiAcaoSau=tabuleiro_ref.quantiAcaoSau+1
		return
	



# Vende a ação com base na quantidade atual
func vender_acao(nicho:String,quantidades:int) -> void:
	var acao = tabuleiro_ref._buscar_acao_por_nicho(nicho_atual)
	


	var valor_total = get_preco(nicho)
	
	
	if nicho == "Alimentação":
		if tabuleiro_ref.quantiAcaoAlim==0:
			print("Você não tem ações para vender nesse nicho")
			return
		else:
			tabuleiro_ref.quantiAcaoAlim=tabuleiro_ref.quantiAcaoAlim-1
			saldo_ref.adicionar_saldo(valor_total)
			print("Venda realizada: 1 ação de %s por %f ." % [ nicho, valor_total / quantidade_atual])
			return
			
	elif nicho == "Transporte":
		if tabuleiro_ref.quantiAcaoTrans==0:
			print("Você não tem ações para vender nesse nicho")
			return
		else:
			tabuleiro_ref.quantiAcaoTrans=tabuleiro_ref.quantiAcaoTrans-1
			saldo_ref.adicionar_saldo(valor_total)
			print("Venda realizada: 1 ação de %s por %f ." % [ nicho, valor_total / quantidade_atual])
			return
	elif nicho == "Tecnologia":
		if tabuleiro_ref.quantiAcaoTecno==0:
			print("Você não tem ações para vender nesse nicho")
			return
		else:
			tabuleiro_ref.quantiAcaoTecno=tabuleiro_ref.quantiAcaoTecno-1
			saldo_ref.adicionar_saldo(valor_total)
			print("Venda realizada: 1 ação de %s por %f ." % [ nicho, valor_total / quantidade_atual])
			return
	elif nicho == "Siderúrgica":
		if tabuleiro_ref.quantiAcaoSider==0:
			print("Você não tem ações para vender nesse nicho")
			return
		else:
			tabuleiro_ref.quantiAcaoSider=tabuleiro_ref.quantiAcaoSider-1
			saldo_ref.adicionar_saldo(valor_total)
			print("Venda realizada: 1 ação de %s por %f ." % [ nicho, valor_total / quantidade_atual])
			return
	elif nicho == "Saúde":
		if tabuleiro_ref.quantiAcaoSau==0:
			print("Você não tem ações para vender nesse nicho")
			return
		else:
			tabuleiro_ref.quantiAcaoSau=tabuleiro_ref.quantiAcaoSau-1
			saldo_ref.adicionar_saldo(valor_total)
			print("Venda realizada: 1 ação de %s por %f ." % [ nicho, valor_total / quantidade_atual])
			return
	

   
	   
func atualizar_valor_em_tempo_real_venda(nicho: String, quantidade: int) -> void:
	nicho_atual = nicho
	quantidade_atual = quantidade
	var valor_total = calcular_preco_total(nicho, quantidade)
	print("Valor total para vender %d ações de %s: %f" % [quantidade, nicho, valor_total])
func mostrar_lucro(nicho,quantidade)->float:
	var preço_atual=calcular_preco_total(nicho,quantidade)
	if(preço_atual>valor_de_compra):
		var valor= preço_atual-valor_de_compra
		return valor
	elif(preço_atual<valor_de_compra):
		var valor= valor_de_compra-preço_atual
		return valor
	return preço_atual
		
