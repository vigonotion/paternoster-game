extends Area3D

@onready var game_manager: GameManager = %GameManager

func _on_body_entered(body: Node3D) -> void:
	if body is not Human:
		return
		
	(body as Human).is_waiting_leave_down = true
	game_manager.human_entered_leave_down()

func _on_body_exited(body: Node3D) -> void:
	if body is not Human:
		return
		
	(body as Human).is_waiting_leave_down = false
	game_manager.human_exited_leave_down()
	
