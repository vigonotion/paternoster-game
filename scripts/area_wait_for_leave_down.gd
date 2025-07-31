extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is not Human:
		return
		
	(body as Human).is_waiting_leave_down = true

func _on_body_exited(body: Node3D) -> void:
	if body is not Human:
		return
		
	(body as Human).is_waiting_leave_down = false
	
