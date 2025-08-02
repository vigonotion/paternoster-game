extends Area3D

@onready var game_manager: GameManager = %GameManager


func _on_body_entered(body: Node3D) -> void:
	if body is not Human:
		return
		
	(body as Human).is_waiting_enter_up = true
	game_manager.human_entered_enter_up()

func _on_body_exited(body: Node3D) -> void:
	if body is not Human:
		return
		
	(body as Human).is_waiting_enter_up = false
	game_manager.human_exited_enter_up()
	
