extends TileMapLayer

@onready var label: Label = $Label

var player_in_area: bool = false

func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interect"):
		label.text = "Filho, 
		descobri um jogo 
		novo e muito divertido hoje!
		 Vamos Jogar?"


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		player_in_area = true
		label.visible = true
		label.text = "Pressione 'E' para interagir."
		
# Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		player_in_area = false
		label.visible = false # Replace with function body.
