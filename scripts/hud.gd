class_name Hud
extends Control

@onready var tutorial_text: RichTextLabel = $"Tutorial Text"

@onready var score_label: Label = %Score
@onready var failures_label: Label = %Failures

@onready var game_over_panel: Panel = %"Game Over Panel"
@onready var game_over_reason_label: RichTextLabel = %"Game Over Reason"


@export var game_over_reason: String = "?":
	set(r):
		game_over_reason = r
		if game_over_reason_label:
			game_over_reason_label.text = r + "\n\n" + "You transported " +str(transported_successfully)+ " passengers." + "\n\nPress [img=40,top]res://icons/key r.png[/img] to play another round."

@export var time_elapsed := 0.0
@export var transported_successfully := 0
@export var transported_failures := 0

func _on_game_manager_state_changed(state: GameManager.STATE) -> void:

	if state == GameManager.STATE.TUTORIAL_A:
		tutorial_text.text = "Press [img=40,top]res://icons/key a.png[/img] if you think it's time to hop into the paternoster."
	elif state == GameManager.STATE.TUTORIAL_L:
		tutorial_text.text = "You did it! Now, press [img=40,top]res://icons/key l.png[/img] if you think it's time to hop out of the paternoster."
	elif state == GameManager.STATE.TUTORIAL_DJ:
		tutorial_text.text = "Just two keys more to learn: Press [img=40,top]res://icons/key d.png[/img] to jump out of the left paternoster, and [img=40,top]res://icons/key j.png[/img] to hop into the right one."
	elif state == GameManager.STATE.TUTORIAL_END:
		tutorial_text.text = "That's all! You get points for every passenger who reaches their destination. The faster they get there, the more points you get."
	else:
		tutorial_text.text = ""

	game_over_panel.visible = state == GameManager.STATE.GAME_OVER
	

func _on_game_manager_score_updated(score: float) -> void:
	score_label.text = str(transported_successfully)
	failures_label.text = str(transported_failures) + "/20"
