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
		print("spawned now!")
	
	if will_spawn_inside_down and spawn_inside_down.enabled:
		game.add_child(will_spawn_inside_down)
		will_spawn_inside_down = null
		print("spawned now!")
		

func spawn_at(spawn_point: Node3D, state: Human.STATE):
	var human: Human = human_scene.instantiate()
	human.position = spawn_point.position
	human.state = state
	
	if spawn_point == spawn_inside_up:
		will_spawn_inside_up = human
		print("will spawn later")
	elif spawn_point == spawn_inside_down:
		will_spawn_inside_down = human
		print("will spawn later")
	else:
		game.add_child(human)


func _on_game_ready() -> void:
	spawn_at(spawn_enter_up_start, Human.STATE.ENTERING)
	spawn_at(spawn_inside_down, Human.STATE.EXITING)
	state = STATE.START

func human_entered_enter_up() -> void:
	if state != STATE.START:
		return
		
	state = STATE.TUTORIAL_A

func human_exited_enter_up() -> void:
	if state != STATE.TUTORIAL_A:
		return
		
	state = STATE.TUTORIAL_A_END
