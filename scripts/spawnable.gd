extends Area3D

# Enables and disabled spawn points when entering and exiting the paternoster

func _on_body_entered(body: Node3D) -> void:
	print("collision", body)

	if body is ToggleableSpawn:
		body.enabled = true


func _on_body_exited(body: Node3D) -> void:
	if body is ToggleableSpawn:
		body.enabled = false
