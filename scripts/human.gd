class_name Human
extends RigidBody3D

@onready var raycast_front: RayCast3D = $"Raycast Front"
@onready var raycast_back: RayCast3D = $"Raycast Back"


@onready var model: Node3D = $"Human Node/model"
@onready var label: Label3D = $"Label"

@onready var jump_block_timer: Timer = $"Jump Block Timer"

@onready var jump_timer: Timer = $"Jump Timer"

@onready var jump_sfx: AudioStreamPlayer3D = $"Jump Sfx"
@onready var jump_long_sfx: AudioStreamPlayer3D = $"Jump Long Sfx"



@export var id: String

signal state_changed(state: STATE)
signal game_over()

enum STATE {
	IDLE,
	WAIT_ENTER_UP,
	WAIT_ENTER_DOWN,
	WAIT_EXIT_UP,
	WAIT_EXIT_DOWN,
	AUTO_LEAVE,
	AUTO_QUEUE
}

var blocked = false

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
		label.text = "A"
	elif state == STATE.WAIT_ENTER_DOWN:
		label.text = "J"
	elif state == STATE.WAIT_EXIT_UP:
		label.text = "D"
	elif state == STATE.WAIT_EXIT_DOWN:
		label.text = "L"
	else:
		label.text = ""
		
	if blocked:
		label.text = ""

func _process(delta: float) -> void:
	if !jump_block_timer.is_stopped():
		return

	if (state == STATE.WAIT_ENTER_UP and Input.is_action_just_pressed("enter_up")) or (state == STATE.WAIT_ENTER_DOWN and Input.is_action_just_pressed("enter_down")):
		apply_impulse(Vector3(0, 100, -300), Vector3(0, 1, 0))
		jump_long_sfx.play()
		jump_block_timer.start()
		blocked = true
		set_label()
	elif (state == STATE.WAIT_EXIT_DOWN and Input.is_action_just_pressed("leave_down")) or (state == STATE.WAIT_EXIT_UP and Input.is_action_just_pressed("leave_up")):
		apply_impulse(Vector3(0, 100, 300), Vector3(0, 1, 0))
		jump_long_sfx.play()
		jump_block_timer.start()
		blocked = true
		set_label()
	

var i = 0
func _physics_process(delta: float) -> void:
	i += 1
		
	if state == STATE.IDLE:
		return
	
	if state == STATE.WAIT_ENTER_UP or state == STATE.WAIT_ENTER_DOWN or state == STATE.WAIT_EXIT_UP or state == STATE.WAIT_EXIT_DOWN:
		return	



func _on_jump_block_timer_timeout() -> void:
	blocked = false
	set_label()



func _on_game_over_timer_timeout() -> void:
	if state == STATE.AUTO_QUEUE:
		game_over.emit()


func _on_jump_timer_timeout() -> void:
	if !raycast_front.is_colliding() and state == STATE.AUTO_QUEUE:	
		apply_impulse(Vector3(0, 100, -50), Vector3(0, 1, 0))
		jump_sfx.play()
	elif !raycast_back.is_colliding() and state == STATE.AUTO_LEAVE:
		apply_impulse(Vector3(0, 100, 50), Vector3(0, 1, 0))
		jump_sfx.play()
