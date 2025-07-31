extends Path3D

@export var count: int = 8

func _ready() -> void:
	# remove placeholder
	for c in get_children():
		c.queue_free()
		
	var scene = load("res://scenes/chainlink.tscn")
	
	for i in range(count):
		var instance = scene.instantiate()
		instance.offset = 1.0/count + i/float(count)
		add_child(instance)
		print("Add child")
	
	
