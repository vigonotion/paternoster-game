class_name Chainlink
extends PathFollow3D

@export var speed: float = 0.8
@export var offset: float = 0.0

func _physics_process(delta):
	progress += speed * delta
	pass
	
func _ready() -> void:
	var chain: Path3D = get_parent()
	
	var chain_length = chain.curve.get_baked_length()
	
	progress += offset * chain_length
	
