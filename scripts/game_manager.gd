class_name GameManager
extends Node

@onready var spawn_enter_up: Marker3D = $"../Spawns/Spawn Enter Up"
@onready var spawn_enter_down: Marker3D = $"../Spawns/Spawn Enter Down"
@onready var game: Node3D = $".."

var human_scene

func _init() -> void:
	human_scene = load("res://scenes/human.tscn")

var frame = 140
func _process(delta: float) -> void:
	frame += 1
	
	if frame % 150 == 0:
		var human: Node3D = human_scene.instantiate()
		human.position = spawn_enter_up.position
		game.add_child(human)
		
	if (frame + 75) % 150 == 0:
		var human: Node3D = human_scene.instantiate()
		human.position = spawn_enter_down.position
		game.add_child(human)
