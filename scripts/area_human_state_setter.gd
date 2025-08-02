extends Area3D

@onready var game_manager: GameManager = %GameManager
@export var enter_state: Human.STATE = Human.STATE.IDLE

func _on_body_entered(body: Node3D) -> void:
	if body is not Human:
		return
		
	(body as Human).state = enter_state

func _on_body_exited(body: Node3D) -> void:
	if body is not Human:
		return
		
	# (body as Human).is_waiting_enter_up = false
	
