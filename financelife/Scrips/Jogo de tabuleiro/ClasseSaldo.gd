extends Object

class_name Saldo

var valor: float = 100.0


func mostrar_saldo() -> float:
	return valor

func subtrair_saldo(valor_subtraido: float) -> bool:
	if valor_subtraido > valor:
		print("Saldo insuficiente!")
		return false
	else:
		valor -= valor_subtraido
		return true

func aumentar_saldo(valor_aumentado: float) -> bool:
	valor += valor_aumentado
	return true
