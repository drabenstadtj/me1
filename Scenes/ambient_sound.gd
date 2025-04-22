extends AudioStreamPlayer

@export var fade_duration := 2.0  # seconds
var loop = true 

func _ready():
	if loop:
		fade_in()
		connect("finished", _on_finished)

func _on_finished():
	if loop:
		play()

func fade_in():
	volume_db = -80  # start silent
	play()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -5, fade_duration)

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -80, fade_duration)
	tween.tween_callback(Callable(self, "stop"))
