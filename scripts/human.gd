class_name Human
extends RigidBody3D

@onready var game_manager: GameManager = %GameManager

@onready var bubble: Node3D = $Bubble

@onready var raycast: RayCast3D = $Raycast

@onready var model: Node3D = $"Human Node/model"
@onready var label: Label3D = $"Label"


signal state_changed(state: STATE)

enum STATE {
	IDLE,
	WAIT_ENTER_UP,
	WAIT_ENTER_DOWN,
	WAIT_EXIT_UP,
	WAIT_EXIT_DOWN,
	AUTO_LEAVE,
	AUTO_QUEUE
}

@export var state = STATE.IDLE:
	set(s):
		state = s
		state_changed.emit(state)
		
		if label:
			set_label()

func _ready() -> void:
	set_label()
	var meshinstance = (model.get_child(0) as MeshInstance3D)
	
	var newMaterial = StandardMaterial3D.new()
	newMaterial.albedo_color = Color.from_rgba8(210, 59, 56)
	newMaterial.albedo_color.ok_hsl_h = randf()
	newMaterial.albedo_color.ok_hsl_l = randf_range(0.4, 0.8)
	meshinstance.material_override = newMaterial
	
func set_label():
	if state == STATE.WAIT_ENTER_UP:
		label.text = "[A]"
	elif state == STATE.WAIT_ENTER_DOWN:
		label.text = "[J]"
	elif state == STATE.WAIT_EXIT_UP:
		label.text = "[D]"
	elif state == STATE.WAIT_EXIT_DOWN:
		label.text = "[L]"
	else:
		label.text = ""

func _process(delta: float) -> void:
	
	
	if (state == STATE.WAIT_ENTER_UP and Input.is_action_just_pressed("enter_up")) or (state == STATE.WAIT_ENTER_DOWN and Input.is_action_just_pressed("enter_down")):
		apply_impulse(Vector3(0, 100, -300), Vector3(0, 1, 0))
	elif (state == STATE.WAIT_EXIT_DOWN and Input.is_action_just_pressed("leave_down")) or (state == STATE.WAIT_EXIT_UP and Input.is_action_just_pressed("leave_up")):
		apply_impulse(Vector3(0, 100, 300), Vector3(0, 1, 0))
	

var i = 0
func _physics_process(delta: float) -> void:
	i += 1

	if raycast.is_colliding():
		return
		
	if state == STATE.IDLE:
		return
	
	if state == STATE.WAIT_ENTER_UP or state == STATE.WAIT_ENTER_DOWN or state == STATE.WAIT_EXIT_UP or state == STATE.WAIT_EXIT_DOWN:
		return	
	
	if i % 25 != 0:
		return

	if state == STATE.AUTO_QUEUE:	
		apply_impulse(Vector3(0, 100, -50), Vector3(0, 1, 0))
	elif state == STATE.AUTO_LEAVE:
		apply_impulse(Vector3(0, 100, 50), Vector3(0, 1, 0))
