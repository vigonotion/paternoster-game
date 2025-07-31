extends RigidBody3D


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("enter_up"):
		apply_impulse(Vector3(0, 100, -300), Vector3(0, 1, 0))
