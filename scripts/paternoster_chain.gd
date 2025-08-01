@tool
extends Path3D

@export var count: int = 8:
	set(c):
		count = c
		_init()

const paternoster_height = 3

func _init() -> void:
	curve = Curve3D.new() 
	var halfcount = count / 2.0
	var y_offset = -count / 4 * paternoster_height
	
	for i in range(count):
		if i < halfcount:
			curve.add_point(Vector3(0, y_offset + i * paternoster_height, 0))
		else:
			curve.add_point(Vector3(3, y_offset + (halfcount * paternoster_height) - (i - halfcount + 1)* paternoster_height, 0))
			
	curve.closed = true

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
	
	
