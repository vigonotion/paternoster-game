extends PathFollow3D

const speed: float = .2

func _physics_process(delta):
	progress_ratio += delta * speed
