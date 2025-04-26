extends AudioStreamPlayer3D


func _ready():
	self.stream_paused = false
	self.play()
	self.connect("finished", _on_audio_finished)

func _on_audio_finished():
	self.play()  # loop by restarting


func _fade_out(time: float = -1):
	var tween = create_tween()
	if time != -1:
		tween.tween_property(self, "volume_db", -80.0, time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
