extends Area3D

@export var prompt_text: String = "Press E to Sit"
@export var interaction_distance: float = 3.0
@export var player_sit_position: Node3D
@export var player_sit_rotation: Vector3
@export var camera_limit_pitch: float = 0.0

var player: Node3D
var ui_prompt: Label
var is_player_near = false
var has_sat = false

func _ready():
	player = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/Player")
	ui_prompt = get_tree().get_root().get_node("World/SubViewportContainer/UI/PromptLabel")
	ui_prompt.visible = false

func _process(_delta):
	if has_sat:
		return

	var distance = player.global_position.distance_to(global_position)
	if distance <= interaction_distance:
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

	var player_body = player as CharacterBody3D
	player_body.velocity = Vector3.ZERO
	player_body.set_physics_process(false)

	# Move and rotate the player into position
	player_body.global_position = player_sit_position.global_position
	player_body.global_rotation = player_sit_rotation

	# Restrict camera movement
	var cam = player.get_node("Camera3D")
	if cam and cam.has_method("restrict_view"):
		cam.restrict_view(camera_limit_pitch)
