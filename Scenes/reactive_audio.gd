extends Node

var color_rect
@onready var capture := AudioServer.get_bus_effect(AudioServer.get_bus_index("Reactive"), 0) as AudioEffectCapture

@export var enable_static = false


@export var sensitivity := 1.5         # How strong the audio affects alpha
@export var min_alpha := 0.0           # Minimum alpha
@export var max_alpha := 1.0           # Maximum alpha
@export var alpha_rise_speed := 3.0    # How fast it fades in
@export var alpha_fall_speed := 1.0    # How fast it fades out
@export var noise_floor := 0.01        # Ignore anything below this

var smoothed_alpha := 0.0

func _ready():
	color_rect = get_node("/root/World/SubViewportContainer/SubViewport/UI/Static")

func _process(delta):
	if capture.get_frames_available() > 0:
		var audio = capture.get_buffer(capture.get_frames_available())
		var sum_sq := 0.0

		# RMS calculation (smooth energy)
		for i in audio:
			var s = i.length() if i is Vector2 else abs(i)
			sum_sq += s * s

		var rms = sqrt(sum_sq / audio.size())

		# Apply gain and clamp below noise floor
		rms = max(0.0, rms - noise_floor) * sensitivity
		rms = clamp(rms, 0.0, 1.0)

		# Smooth fade in/out
		if rms > smoothed_alpha:
			smoothed_alpha = lerp(smoothed_alpha, rms, alpha_rise_speed * delta)
		else:
			smoothed_alpha = lerp(smoothed_alpha, rms, alpha_fall_speed * delta)

		color_rect.modulate.a = clamp(smoothed_alpha, min_alpha, max_alpha)
