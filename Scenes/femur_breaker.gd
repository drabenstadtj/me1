extends AudioStreamPlayer3D

@export_range(0.8, 1.2) var min_pitch := 0.9
@export_range(0.8, 1.2) var max_pitch := 1.1

@export_range(1.0, 10.0) var min_delay := 2.0
@export_range(1.0, 10.0) var max_delay := 5.0

func _ready():
	await get_tree().create_timer(randf_range(5, 20)).timeout
	_play_loop()

func _play_loop():
	while true:
		pitch_scale = randf_range(min_pitch, max_pitch)
		play()

		var duration = stream.get_length() / pitch_scale
		await get_tree().create_timer(duration).timeout

		var delay = randf_range(min_delay, max_delay)
		await get_tree().create_timer(delay).timeout
