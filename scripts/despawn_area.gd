extends Area3D



func _on_body_entered(body: Node3D) -> void:
	if body is not Human:
		return
		
	body.queue_free()
	print("Human despawned")
