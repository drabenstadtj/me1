extends Node

@export var fade_duration: float = 1.0

var fade_rect: ColorRect
var door_sound_player: AudioStreamPlayer3D = null  # Make nullable

func _ready():
	await get_tree().process_frame

	var root = get_tree().get_root()

	# Always get fade_rect (assumes it exists in all scenes)
	fade_rect = root.get_node("World/SubViewportContainer/SubViewport/UI/Fade")

	# Only assign door_sound_player if it exists
	var door_path = "World/SubViewportContainer/SubViewport/World/BarRoom/MainDoor/AudioStreamPlayer"
	if root.has_node(door_path):
		door_sound_player = root.get_node(door_path)
		door_sound_player.play()

	if fade_rect:
		# Ensure starting black
		fade_rect.modulate.a = 1.0

		# Fade in to transparent
		var tween := get_tree().create_tween()
		tween.tween_property(fade_rect, "modulate:a", 0.0, fade_duration)

func fade_out(duration: float = -1.0):
	if not fade_rect:
		fade_rect = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/UI/Fade")

	if fade_rect:
		fade_rect.modulate.a = 0.0
		var tween := get_tree().create_tween()
		tween.tween_property(fade_rect, "modulate:a", 1.0, duration if duration > 0.0 else fade_duration)

func fade_in(duration: float = -1.0):
	if not fade_rect:
		fade_rect = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/UI/Fade")

	if fade_rect:
		fade_rect.modulate.a = 1.0
		var tween := get_tree().create_tween()
		tween.tween_property(fade_rect, "modulate:a", 0.0, duration if duration > 0.0 else fade_duration)
