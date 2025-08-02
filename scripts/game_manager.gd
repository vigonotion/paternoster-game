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
@export var transported_successfully := 1
@export var transported_failures := 1
@export var score_per_minute := 1.0

signal state_changed(state: STATE)
signal score_updated(score: float)

enum STATE {
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

@export var state: STATE = STATE.INIT:
	set(s):
		state = s
		print("new state:", state)
		state_changed.emit(s)

var human_scene

var will_spawn_inside_up: Human
var will_spawn_inside_down: Human

func _init() -> void:
	human_scene = load("res://scenes/human.tscn")
	state = STATE.START

func _process(delta: float) -> void:
	
	if will_spawn_inside_up and spawn_inside_up.enabled:
		game.add_child(will_spawn_inside_up)
		will_spawn_inside_up = null
	
	if will_spawn_inside_down and spawn_inside_down.enabled:
		game.add_child(will_spawn_inside_down)
		will_spawn_inside_down = null
		
	if state == STATE.GAME_PHASE_1:
		time_elapsed += delta
		
		score_per_minute = (transported_successfully * 10 - transported_failures) / time_elapsed

func spawn_at(spawn_point: Node3D, state: Human.STATE, id: String):
	var human: Human = human_scene.instantiate()
	human.position = spawn_point.position
	human.state = state
	human.id = id
	
	human.state_changed.connect(on_human_state_changed)
	
	if spawn_point == spawn_inside_up:
		will_spawn_inside_up = human
	elif spawn_point == spawn_inside_down:
		will_spawn_inside_down = human
	else:
		game.add_child(human)


func _on_game_ready() -> void:
	spawn_at(spawn_enter_up_start, Human.STATE.AUTO_QUEUE, "TUTORIAL_A")
	
	state = STATE.START

func on_human_state_changed(human: Human.STATE):
	if state == STATE.START and human == Human.STATE.WAIT_ENTER_UP:
		state = STATE.TUTORIAL_A

	if state == STATE.TUTORIAL_A and human == Human.STATE.IDLE:
		state = STATE.TUTORIAL_A_END
		
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
		
	var choice = randi_range(0, 4)
	
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
	score_updated.emit(score_per_minute)
