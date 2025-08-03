class_name Hud
extends Control

@onready var debug_state: Label = $"Debug State"
@onready var tutorial_text: RichTextLabel = $"Tutorial Text"
@onready var key_binds: Control = $"Key Binds"
@onready var score_label: Label = $Score
@onready var game_over: Label = $"Game Over"

@export var game_over_reason: String = "?"


func _on_game_manager_state_changed(state: GameManager.STATE) -> void:
	debug_state.text = "[STATE] " + GameManager.STATE.keys()[state]

	key_binds.visible = state == GameManager.STATE.TUTORIAL_L_END # TODO on tutorial end

	if state == GameManager.STATE.TUTORIAL_A:
		tutorial_text.text = "Press [A] if you think it's time to hop into the paternoster."
	elif state == GameManager.STATE.TUTORIAL_L:
		tutorial_text.text = "You did it! Now, press [L] if you think it's time to hop out of the paternoster."
	elif state == GameManager.STATE.TUTORIAL_DJ:
		tutorial_text.text = "Just two keys more to learn: Press [D] to jump out of the left paternoster, and [J] to hop into the right one."
	elif state == GameManager.STATE.TUTORIAL_END:
		tutorial_text.text = "That's all! You get points for every passenger who reaches their destination. The faster they get there, the more points you get."
	else:
		tutorial_text.text = ""

	game_over.visible = state == GameManager.STATE.GAME_OVER

func _on_game_manager_score_updated(score: float) -> void:
	score_label.text = str(score).pad_decimals(2) + " per minute"
