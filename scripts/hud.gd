extends Control

@onready var debug_state: Label = $"Debug State"



func _on_game_manager_state_changed(state: GameManager.STATE) -> void:
	debug_state.text = "[STATE] " + GameManager.STATE.keys()[state]
