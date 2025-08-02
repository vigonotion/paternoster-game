class_name GameManager
extends Node

@onready var spawn_enter_up: Marker3D = $"../Spawns/Spawn Enter Up"
@onready var spawn_enter_down: Marker3D = $"../Spawns/Spawn Enter Down"
@onready var spawn_enter_up_start: Marker3D = $"../Spawns/Spawn Enter Up Start"

# These spawn points need to be checked before spawn
@onready var spawn_inside_up: ToggleableSpawn = $"../Spawns/Spawn Inside Up"
@onready var spawn_inside_down: ToggleableSpawn = $"../Spawns/Spawn Inside Down"

@onready var game: Node3D = $".."

signal state_changed(state: STATE)

enum STATE {
	INIT,
	START,
	TUTORIAL_A,
	TUTORIAL_A_END,
	TUTORIAL_L,
	TUTORIAL_L_END,
	TUTORIAL_DJ,
	TUTORIAL_END
}

@export var state: STATE = STATE.INIT:
	set(s):
		state = s
		print("new state:", state)
		state_changed.emit(s)

var human_scene

var will_spawn_inside_up: Human
var will_spawn_inside_down: Human

func _init() -> void:
	human_scene = load("res://scenes/human.tscn")
	state = STATE.START

func _process(delta: float) -> void:
	
	if will_spawn_inside_up and spawn_inside_up.enabled:
		game.add_child(will_spawn_inside_up)
		will_spawn_inside_up = null
	
	if will_spawn_inside_down and spawn_inside_down.enabled:
		game.add_child(will_spawn_inside_down)
		will_spawn_inside_down = null
		

func spawn_at(spawn_point: Node3D, state: Human.STATE, id: String):
	var human: Human = human_scene.instantiate()
	human.position = spawn_point.position
	human.state = state
	human.name = id
	
	human.state_changed.connect(on_human_state_changed)
	
	if spawn_point == spawn_inside_up:
		will_spawn_inside_up = human
	elif spawn_point == spawn_inside_down:
		will_spawn_inside_down = human
	else:
		game.add_child(human)


func _on_game_ready() -> void:
	spawn_at(spawn_enter_up_start, Human.STATE.AUTO_QUEUE, "TUTORIAL_A")
	
	state = STATE.START

func on_human_state_changed(human: Human.STATE):
	if state == STATE.START and human == Human.STATE.WAIT_ENTER_UP:
		state = STATE.TUTORIAL_A

	if state == STATE.TUTORIAL_A and human == Human.STATE.IDLE:
		state = STATE.TUTORIAL_A_END
		
	if state == STATE.TUTORIAL_L and human == Human.STATE.AUTO_LEAVE:
		state = STATE.TUTORIAL_L_END

func human_will_despawn(id: String) -> void:
	if state == STATE.TUTORIAL_L and id == "TUTORIAL_L":
		# they did not successfully jump out
		spawn_at(spawn_inside_down, Human.STATE.WAIT_EXIT_DOWN, "TUTORIAL_L")

func _on_state_changed(new_state: GameManager.STATE) -> void:
	if new_state == STATE.TUTORIAL_A_END:
		spawn_at(spawn_inside_down, Human.STATE.WAIT_EXIT_DOWN, "TUTORIAL_L")
		state = STATE.TUTORIAL_L
