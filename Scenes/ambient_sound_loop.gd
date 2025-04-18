extends AudioStreamPlayer

@export var loop := true

func _ready():
	if loop:
		play()
		connect("finished", _on_finished)

func _on_finished():
	if loop:
		play()
