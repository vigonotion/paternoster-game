extends Area3D

# Enables and disabled spawn points when entering and exiting the paternoster

func _on_body_entered(body: Node3D) -> void:
	if body is ToggleableSpawn:
		body.paternoster_there = true


func _on_body_exited(body: Node3D) -> void:
	if body is ToggleableSpawn:
		body.paternoster_there = false
