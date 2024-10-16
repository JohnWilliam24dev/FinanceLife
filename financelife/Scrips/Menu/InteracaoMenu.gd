extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_inicio_botão_pressed():
	get_tree().change_scene_to_file("res://Cenas/Menu/teste.tscn")


func _on_créditos_botão_pressed():
	pass # Replace with function body.


func _on_sair_button_pressed():
	get_tree().quit()
