class_name GameManager
extends Node

@onready var spawn_enter_up: Marker3D = $"../Spawns/Spawn Enter Up"
@onready var spawn_enter_down: Marker3D = $"../Spawns/Spawn Enter Down"
@onready var spawn_enter_up_start: Marker3D = $"../Spawns/Spawn Enter Up Start"

@onready var game: Node3D = $".."

var human_scene

func _init() -> void:
	human_scene = load("res://scenes/human.tscn")

func spawn_at(spawn_point: Node3D):
	print("spawning!", human_scene)
	var human: Node3D = human_scene.instantiate()
	human.position = spawn_point.position
	human.name = "HUMAN SPAWNED"
	game.add_child(human)


func _on_game_ready() -> void:
	spawn_at(spawn_enter_up_start)
