class_name Hud
extends Control

@onready var tutorial_text: RichTextLabel = $"Tutorial Text"

@onready var score_label: Label = %Score
@onready var failures_label: Label = %Failures

@onready var game_over: Label = $"Game Over"

@export var game_over_reason: String = "?"

@export var time_elapsed := 0.0
@export var transported_successfully := 0
@export var transported_failures := 0

func _on_game_manager_state_changed(state: GameManager.STATE) -> void:

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
	score_label.text = str(transported_successfully)
	failures_label.text = str(transported_failures) + "/20"
