extends Area3D

@onready var game_manager: GameManager = %GameManager
@export var area_id: String

func _on_body_entered(body: Node3D) -> void:
	if body is not Human:
		return
	
	game_manager.human_will_despawn(body.id, area_id)
	body.queue_free()
