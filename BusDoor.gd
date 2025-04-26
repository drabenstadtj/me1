extends Node3D

@export var prompt_text: String = "Press E to get on the bus"
@export var interaction_distance: float = 3.0
@export var target_scene_path: String = "res://Scenes/end-world.tscn"
@export var fade_duration: float = 5.0
@export var pause_after_fade: float = 5

signal interacted

var player_camera: Camera3D
var ui_prompt: Label
var fade_rect: ColorRect
var fading := false
var music_player
var bus_player

func _ready():
	player_camera = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/Player/Camera3D")
	ui_prompt = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/UI/PromptLabel")
	fade_rect = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/UI/Fade")
	music_player = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/Player/MusicPlayer")
	bus_player = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/World/Bus/Idling")
	if ui_prompt:
		ui_prompt.visible = false

func _process(_delta):
	if fading or not player_camera or not ui_prompt or not fade_rect:
		return

	var from = player_camera.global_transform.origin
	var to = from + -player_camera.global_transform.basis.z * interaction_distance

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.exclude = [player_camera.get_camera_rid()]

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result and self.is_ancestor_of(result.collider):
		ui_prompt.text = prompt_text
		ui_prompt.visible = true

		if Input.is_action_just_pressed("interact"):
			music_player._fade_out(5.0)  # Only if implemented
			bus_player._fade_out(5.0)
			emit_signal("interacted")
			fading = true
			start_fade()
	else:
		ui_prompt.visible = false

func start_fade():
	var tween := get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_duration)
	tween.tween_callback(Callable(self, "_on_fade_complete"))

func _on_fade_complete():
	await get_tree().create_timer(pause_after_fade).timeout
	get_tree().change_scene_to_file(target_scene_path)
