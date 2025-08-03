class_name GameManager
extends Node

@onready var spawn_enter_up: Marker3D = $"../Spawns/Spawn Enter Up"
@onready var spawn_enter_down: Marker3D = $"../Spawns/Spawn Enter Down"
@onready var spawn_enter_up_start: Marker3D = $"../Spawns/Spawn Enter Up Start"

# These spawn points need to be checked before spawn
@onready var spawn_inside_up: ToggleableSpawn = $"../Spawns/Spawn Inside Up"
@onready var spawn_inside_down: ToggleableSpawn = $"../Spawns/Spawn Inside Down"

@onready var game: Node3D = $".."

@onready var tutorial_end_timer: Timer = $"Tutorial End Timer"

@export var time_elapsed := 0.0
@export var transported_successfully := 0
@export var transported_failures := 0

@onready var background_music_player: AudioStreamPlayer = $"../Background Music Player"
@onready var rattling_player: AudioStreamPlayer3D = $"../Rattling Player"

@onready var main_camera: Camera3D = $"../Main Camera"
@onready var init_camera: Camera3D = $"../Init Camera"

@onready var hud: Hud = $"../CanvasLayer/HUD"


signal state_changed(state: STATE)
signal score_updated(score: float)

enum STATE {
	MENU,
	GAME_OVER,
	INIT,
	START,
	TUTORIAL_A,
	TUTORIAL_A_END,
	TUTORIAL_L,
	TUTORIAL_L_END,
	TUTORIAL_DJ,
	TUTORIAL_END,
	GAME_PHASE_1
}

var state: STATE = STATE.MENU:
	set(s):
		state = s
		state_changed.emit(s)

var human_scene

var will_spawn_inside_up: Human
var will_spawn_inside_down: Human

func _init() -> void:
	human_scene = load("res://scenes/human.tscn")
	state = STATE.INIT


func _process(delta: float) -> void:
	
	if will_spawn_inside_up and spawn_inside_up.is_enabled():
		game.add_child(will_spawn_inside_up)
		will_spawn_inside_up = null
	
	if will_spawn_inside_down and spawn_inside_down.is_enabled():
		game.add_child(will_spawn_inside_down)
		will_spawn_inside_down = null
		
	if state > STATE.GAME_OVER and state < STATE.GAME_PHASE_1 and Input.is_action_just_pressed("skip_tutorial"):
		state = STATE.GAME_PHASE_1
		background_music_player.play()
		
	if state == STATE.GAME_PHASE_1:
		time_elapsed += delta
		
		
	if state == STATE.MENU and Input.is_action_just_pressed("enter_up"):
		start_tutorial()

	if Input.is_action_just_pressed("restart"):
		restart()
		
	if Input.is_action_just_pressed("debug_game_over"):
		hud.game_over_reason = "The debug key triggered the game over screen."
		game_over()

func restart():
	state = STATE.GAME_PHASE_1
	
	time_elapsed = 0.0
	transported_successfully = 1
	transported_failures = 1
	
	for h in game.get_children():
		if h is Human:
			h.queue_free()
			
	Engine.time_scale = 1.0
	score_updated.emit(0)
	background_music_player.play()
	rattling_player.play()

func spawn_at(spawn_point: Node3D, state: Human.STATE, id: String):
	var human: Human = human_scene.instantiate()
	human.position = spawn_point.position
	human.state = state
	human.id = id
	
	human.state_changed.connect(on_human_state_changed)
	human.game_over.connect(game_over_wait)
	
	if spawn_point == spawn_inside_up:
		will_spawn_inside_up = human
	elif spawn_point == spawn_inside_down:
		will_spawn_inside_down = human
	else:
		game.add_child(human)

func start_tutorial() -> void:
	spawn_at(spawn_enter_up_start, Human.STATE.AUTO_QUEUE, "TUTORIAL_A")
	state = STATE.START
	main_camera.current = true

func _on_game_ready() -> void:
	state = STATE.MENU

func on_human_state_changed(human: Human.STATE):
	if state == STATE.START and human == Human.STATE.WAIT_ENTER_UP:
		state = STATE.TUTORIAL_A

	if state == STATE.TUTORIAL_A and human == Human.STATE.IDLE:
		state = STATE.TUTORIAL_A_END
		background_music_player.play()
		
	if state == STATE.TUTORIAL_L and human == Human.STATE.AUTO_LEAVE:
		state = STATE.TUTORIAL_L_END

func human_will_despawn(id: String, area_id: String) -> void:
	if state == STATE.TUTORIAL_L and id == "TUTORIAL_L":
		# they did not successfully jump out
		spawn_at(spawn_inside_down, Human.STATE.WAIT_EXIT_DOWN, "TUTORIAL_L")

	if state == STATE.TUTORIAL_DJ and id == "TUTORIAL_DJ_UP":
		# they did not successfully jump out
		spawn_at(spawn_inside_up, Human.STATE.WAIT_EXIT_UP, "TUTORIAL_DJ_UP")
		
	if state == STATE.TUTORIAL_DJ and id == "TUTORIAL_DJ_DOWN":
		state = STATE.TUTORIAL_END
		tutorial_end_timer.start()
		
	if state == STATE.GAME_PHASE_1:
		
		if id == "LOOP_ENTER_UP" and area_id == "up":
			transported_successfully += 1
		elif id == "LOOP_ENTER_DOWN" and area_id == "down":
			transported_successfully += 1
		elif (id == "LOOP_EXIT_UP" or id == "LOOP_EXIT_DOWN") and area_id == "floor":
			transported_successfully += 1
		else:
			transported_failures += 1
			
		if transported_failures > 20:
			game_over()
			hud.game_over_reason = "Too many passengers missed their floor."

func game_over_wait():
	hud.game_over_reason = "A passenger waited more than 60 seconds in the queue."
	game_over()

func game_over():
	if state == STATE.GAME_OVER:
		return
		
	state = STATE.GAME_OVER
	Engine.time_scale = 0
	rattling_player.stop()

func _on_state_changed(new_state: GameManager.STATE) -> void:
	if new_state == STATE.TUTORIAL_A_END:
		state = STATE.TUTORIAL_L
		spawn_at(spawn_inside_down, Human.STATE.WAIT_EXIT_DOWN, "TUTORIAL_L")
		
	if new_state == STATE.TUTORIAL_L_END:
		state = STATE.TUTORIAL_DJ
		spawn_at(spawn_inside_up, Human.STATE.WAIT_EXIT_UP, "TUTORIAL_DJ_UP")
		spawn_at(spawn_enter_down, Human.STATE.AUTO_QUEUE, "TUTORIAL_DJ_DOWN")



func _on_tutorial_end_timer_timeout() -> void:
	state = STATE.GAME_PHASE_1



func _on_spawn_timer_timeout() -> void:
	if state < STATE.TUTORIAL_END:
		return
		
	var choices = 16
	
	if transported_successfully > 20:
		choices = 8
		
	if transported_successfully > 80:
		choices = 4
	
	if transported_successfully > 100:
		choices = 3
		
	var choice = randi_range(0, choices)
	
	if choice == 0:
		spawn_at(spawn_enter_up, Human.STATE.AUTO_QUEUE, "LOOP_ENTER_UP")
	elif choice == 1:
		spawn_at(spawn_inside_up, Human.STATE.WAIT_EXIT_UP, "LOOP_EXIT_UP")
	elif choice == 2:
		spawn_at(spawn_enter_down, Human.STATE.AUTO_QUEUE, "LOOP_ENTER_DOWN")
	elif choice == 3:
		spawn_at(spawn_inside_down, Human.STATE.WAIT_EXIT_DOWN, "LOOP_EXIT_DOWN")
	else:
		# spawn-free cycle
		pass



func _on_score_timer_timeout() -> void:
	score_updated.emit(0)
	
	hud.time_elapsed = time_elapsed
	hud.transported_successfully = transported_successfully
	hud.transported_failures = transported_failures
