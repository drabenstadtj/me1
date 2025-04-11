extends Node3D

@export var prompt_text: String = "Press E to Enter"
@export var interaction_distance: float = 3.0

signal interacted

var player_camera: Camera3D
var ui_prompt: Label

func _ready():
	# Dynamically find references (adjust paths to your actual scene structure)
	player_camera = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/Player/Camera3D")
	ui_prompt = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/UI/PromptLabel")

	if ui_prompt:
		ui_prompt.visible = false

func _process(_delta):
	if not player_camera or not ui_prompt:
		return

	var from = player_camera.global_transform.origin
	var to = from + -player_camera.global_transform.basis.z * interaction_distance

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true   # Enable detection of Area3Ds
	query.collide_with_bodies = true
	query.exclude = [player_camera.get_camera_rid()]

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result:
		print("Hit: ", result.collider.name)

		if self.is_ancestor_of(result.collider):
			ui_prompt.text = prompt_text
			ui_prompt.visible = true

			if Input.is_action_just_pressed("interact"):
				emit_signal("interacted")
		else:
			if ui_prompt.visible:
				ui_prompt.visible = false
	else:
		if ui_prompt.visible:
			ui_prompt.visible = false
