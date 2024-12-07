extends Object
class_name saldos

var saldo: float = 0.0

func _init(money: float) -> void:
	saldo = money

func puxar_saldo() -> float:
	return saldo

func adicionar_saldo(valor: float) -> void:
	saldo += valor

func subtrair_saldo(valor: float) -> bool:
	if saldo >= valor:
		saldo -= valor
		return true
	else:
		print("Saldo insuficiente!")
		return false
func meta()->bool:
	if(saldo==2000):
		return true
	else:
		return false
