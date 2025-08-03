class_name ToggleableSpawn 
extends StaticBody3D

@export var paternoster_there = false
@export var human_there = false

func is_enabled():
	return paternoster_there and not human_there
