extends SpotLight3D

@export var base_energy := 20.0               # Normal light energy when on
@export var flicker_chance := 0.75            # Chance per second to flicker
@export var min_flicker_duration := 0.05     # Shortest flicker (seconds)
@export var max_flicker_duration := 0.5      # Longest flicker (seconds)

var flicker_timer := 0.0
var is_flickering := false

func _ready():
	randomize()
	light_energy = base_energy

func _process(delta):
	if is_flickering:
		flicker_timer -= delta
		if flicker_timer <= 0.0:
			# Light turns back on
			light_energy = base_energy
			is_flickering = false
	else:
		# Random chance to flicker this frame
		if randf() < flicker_chance * delta:
			is_flickering = true
			flicker_timer = randf_range(min_flicker_duration, max_flicker_duration)
			light_energy = 0.0
