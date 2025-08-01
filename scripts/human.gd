class_name Human
extends RigidBody3D

@export var is_waiting_enter_up = false
@export var is_waiting_leave_up = false
@export var is_waiting_enter_down = false
@export var is_waiting_leave_down = false

@onready var bubble: Node3D = $Bubble

@onready var raycast: RayCast3D = $Raycast

@onready var model: Node3D = $"Human Node/model"

func _ready() -> void:
	var meshinstance = (model.get_child(0) as MeshInstance3D)
	
	var newMaterial = StandardMaterial3D.new()
	newMaterial.albedo_color = Color(randf(), randf(), randf(), 1.0) #Set color of new material
	
	meshinstance.material_override = newMaterial
	

func _process(delta: float) -> void:
	
	
	if (is_waiting_enter_up and Input.is_action_just_pressed("enter_up")) or (is_waiting_enter_down and Input.is_action_just_pressed("enter_down")):
		apply_impulse(Vector3(0, 100, -300), Vector3(0, 1, 0))
	elif (is_waiting_leave_down and Input.is_action_just_pressed("leave_down")) or (is_waiting_leave_up and Input.is_action_just_pressed("leave_up")):
		apply_impulse(Vector3(0, 100, 300), Vector3(0, 1, 0))
	

var i = 0
func _physics_process(delta: float) -> void:
	i += 1

	if raycast.is_colliding():
		return
	
	if is_waiting_enter_up or is_waiting_enter_down or is_waiting_leave_up or is_waiting_leave_down:
		return	
	
	if i > 100 and i % 25 == 0:
		apply_impulse(Vector3(0, 100, -50), Vector3(0, 1, 0))
