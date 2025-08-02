@tool
extends Path3D

@export var count: int = 8:
	set(c):
		count = c
		_init()

@export_tool_button("Re-init chain path")
var button = _init

const paternoster_height = 3
@export var curve_height = 6.0:
	set(c):
		curve_height = c
		_init()

func _init() -> void:
	curve = Curve3D.new() 
	var halfcount = count / 2.0
	var y_offset = -count / 4 * paternoster_height
	
	for i in range(count):

		if i == 0:
			curve.add_point(Vector3(0, y_offset + i * paternoster_height, 0), Vector3.DOWN * curve_height)
		if i == halfcount - 1:
			curve.add_point(Vector3(0, y_offset + i * paternoster_height, 0), Vector3.ZERO, Vector3.UP * curve_height)
		elif i < halfcount:
			curve.add_point(Vector3(0, y_offset + i * paternoster_height, 0))
		elif i == halfcount:
			curve.add_point(Vector3(3, y_offset + (halfcount * paternoster_height) - (i - halfcount + 1)* paternoster_height, 0), Vector3.UP * curve_height)
		elif i == count - 1:
			curve.add_point(Vector3(3, y_offset + (halfcount * paternoster_height) - (i - halfcount + 1)* paternoster_height, 0), Vector3.ZERO, Vector3.DOWN * curve_height)
		else:
			curve.add_point(Vector3(3, y_offset + (halfcount * paternoster_height) - (i - halfcount + 1)* paternoster_height, 0))
			
	curve.closed = true

func _ready() -> void:
	# remove placeholder
	for c in get_children():
		c.queue_free()
		
	var scene = load("res://scenes/chainlink.tscn")
	
	var paternoster_count = count + 4

	for i in range(paternoster_count):
		var instance = scene.instantiate()
		instance.offset = 1.0/paternoster_count + i/float(paternoster_count)
		add_child(instance)
	
	
