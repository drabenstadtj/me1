extends Area3D

@export var prompt_text: String = "Press E to Sit"
@export var interaction_distance: float = 3.0
@export var player_sit_position: Node3D
@export var player_sit_rotation: Vector3
@export var camera_limit_pitch := 2.50  # degrees up/down
@export var camera_limit_yaw := 60.0    # degrees left/right

var current_yaw := 0.0
var current_pitch := 0.0


var player: CharacterBody3D
var camera: Camera3D
var ui_prompt: Label

var is_player_near = false
var has_sat = false
var original_camera_rotation := Vector3.ZERO

var enabled = false

func _ready():
	player = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/Player")
	camera = player.get_node("Camera3D")  # adjust path if needed
	ui_prompt = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/UI/PromptLabel")
	ui_prompt.visible = false

func _process(_delta):
	if has_sat:
		return

	var distance = player.global_position.distance_to(global_position)
	if distance <= interaction_distance and enabled:
		is_player_near = true
		ui_prompt.text = prompt_text
		ui_prompt.visible = true

		if Input.is_action_just_pressed("interact"):
			sit_player()
	else:
		is_player_near = false
		ui_prompt.visible = false

func sit_player():
	if has_sat:
		return

	has_sat = true
	ui_prompt.visible = false

	player.velocity = Vector3.ZERO
	player.set_physics_process(false)

	player.global_position = player_sit_position.global_position
	player.global_rotation = player_sit_rotation

	original_camera_rotation = camera.rotation
	current_yaw = 0.0
	current_pitch = 0.0

func _input(event):
	if not has_sat or not event is InputEventMouseMotion:
		return

	# Update yaw and pitch deltas
	current_yaw -= event.relative.x * 0.002
	current_pitch -= event.relative.y * 0.002

	# Clamp them relative to zero
	current_yaw = clamp(current_yaw, deg_to_rad(-camera_limit_yaw), deg_to_rad(camera_limit_yaw))
	current_pitch = clamp(current_pitch, deg_to_rad(-camera_limit_pitch), deg_to_rad(camera_limit_pitch))

	# Apply to player and camera
	player.rotation.y = player_sit_rotation.y + current_yaw
	camera.rotation.x = original_camera_rotation.x + current_pitch

func disable():
	enabled = false;
	
func enable():
	enabled = true;
