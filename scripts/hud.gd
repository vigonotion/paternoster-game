extends Control

@onready var debug_state: Label = $"Debug State"
@onready var tutorial_text: RichTextLabel = $"Tutorial Text"
@onready var key_binds: Control = $"Key Binds"



func _on_game_manager_state_changed(state: GameManager.STATE) -> void:
	debug_state.text = "[STATE] " + GameManager.STATE.keys()[state]

	key_binds.visible = state == GameManager.STATE.TUTORIAL_L_END # TODO on tutorial end

	if state == GameManager.STATE.TUTORIAL_A:
		tutorial_text.text = "Press [A] if you think it's time to hop into the paternoster."
	elif state == GameManager.STATE.TUTORIAL_L:
		tutorial_text.text = "You did it! Now, press [L] if you think it's time to hop out of the paternoster."
	else:
		tutorial_text.text = ""
