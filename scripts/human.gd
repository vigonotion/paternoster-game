class_name Human
extends RigidBody3D

@export var is_waiting_enter_up = false
@export var is_waiting_leave_up = false
@export var is_waiting_enter_down = false
@export var is_waiting_leave_down = false

func _process(delta: float) -> void:
	
	if (is_waiting_enter_up and Input.is_action_just_pressed("enter_up")) or (is_waiting_enter_down and Input.is_action_just_pressed("enter_down")):
		apply_impulse(Vector3(0, 100, -300), Vector3(0, 1, 0))
	elif (is_waiting_leave_down and Input.is_action_just_pressed("leave_down")) or (is_waiting_leave_up and Input.is_action_just_pressed("leave_up")):
		apply_impulse(Vector3(0, 100, 300), Vector3(0, 1, 0))
