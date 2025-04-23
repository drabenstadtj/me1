extends AudioStreamPlayer

@export var fade_time := 10.0  # seconds
@export var volume_db_target := -10.0  # Normal volume (0 dB)

func _ready():
	volume_db = -80.0  # Start silent
	_fade_in()

func _fade_in(time: float = -1):
	play()
	var tween = create_tween()
	if time != -1:
		tween.tween_property(self, "volume_db", volume_db_target, time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(self, "volume_db", volume_db_target, fade_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_wait_for_track_end)

func _wait_for_track_end():
	var remaining_time = stream.get_length()
	await get_tree().create_timer(remaining_time - fade_time).timeout
	_fade_out()

func _fade_out(time: float = -1):
	var tween = create_tween()
	if time != -1:
		tween.tween_property(self, "volume_db", -80.0, time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	else:
		tween.tween_property(self, "volume_db", -80.0, fade_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(_fade_in)
