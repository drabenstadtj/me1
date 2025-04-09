extends CharacterBody3D

const MOVE_SPEED = 5.0
const GRAVITY = 9.8
const MOUSE_SENSITIVITY = 0.004

const BASE_FOV = 70.0
const MOVE_FOV = 75.0
const FOV_LERP_SPEED = 8.0

const BOB_SPEED = 15.0
const BOB_AMOUNT = 0.05

@onready var camera = $Camera3D
@onready var footstep_player = $FootstepPlayer

var pitch = 0.0
var bob_timer = 0.0
var camera_base_height = 0.0
var last_bob_sign = 0

#var velocity = Vector3.ZERO
var current_state: State
var states = {}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_base_height = camera.transform.origin.y
	camera.fov = BASE_FOV

	states["Idle"] = preload("res://Assets/Scripts/Idle.gd").new()
	states["Move"] = preload("res://Assets/Scripts/Move.gd").new()

	for state in states.values():
		state.player = self
		add_child(state)

	change_state("Idle")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		pitch = clamp(pitch - event.relative.y * MOUSE_SENSITIVITY, deg_to_rad(-60), deg_to_rad(60))
		camera.rotation.x = pitch

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func _process(delta):
	if current_state:
		current_state.update(delta)

func change_state(new_state_name: String):
	if current_state:
		current_state.exit()
	current_state = states[new_state_name]
	current_state.enter()

func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)

func reset_camera_height():
	var cam_transform = camera.transform
	cam_transform.origin.y = lerp(cam_transform.origin.y, camera_base_height, 0.1)
	camera.transform = cam_transform
