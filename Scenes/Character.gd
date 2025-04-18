extends Node3D

func say(text: String, time: float):
	$SpeechBubble.text = text
	$SpeechBubble.visible = true

	# Optional: Hide after 3 seconds
	await get_tree().create_timer(time).timeout
	$SpeechBubble.visible = false

func _process(_delta: float) -> void:
	$SpeechBubble.look_at(get_viewport().get_camera_3d().global_transform.origin, Vector3.UP)
