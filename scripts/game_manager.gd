class_name GameManager
extends Node

@onready var spawn_enter_up: Marker3D = $"../Spawns/Spawn Enter Up"
@onready var spawn_enter_down: Marker3D = $"../Spawns/Spawn Enter Down"
@onready var spawn_enter_up_start: Marker3D = $"../Spawns/Spawn Enter Up Start"

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

func _init() -> void:
	human_scene = load("res://scenes/human.tscn")
	state = STATE.START

func spawn_at(spawn_point: Node3D, state: Human.STATE):
	var human: Human = human_scene.instantiate()
	human.position = spawn_point.position
	human.state = state	
	game.add_child(human)


func _on_game_ready() -> void:
	spawn_at(spawn_enter_up_start, Human.STATE.ENTERING)
	state = STATE.START

func human_entered_enter_up() -> void:
	if state != STATE.START:
		return
		
	state = STATE.TUTORIAL_A

func human_exited_enter_up() -> void:
	if state != STATE.TUTORIAL_A:
		return
		
	state = STATE.TUTORIAL_A_END
