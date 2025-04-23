extends Node3D

@export var sway_amount := 0.1         # How far side to side
@export var sway_speed := 1.5          # How fast the side-to-side swaying is
@export var bump_amount := 0.05        # Vertical bumpiness
@export var bump_speed := 6.0          # Frequency of bumps
@export var lag_strength := 0.2        # How much the camera trails behind

var sway_timer := 0.0
var target_offset := Vector3.ZERO
var velocity := Vector3.ZERO

func _process(delta):
	sway_timer += delta

	# Horizontal sway (like leaning during turns or road curve)
	var sway = sin(sway_timer * sway_speed) * sway_amount

	# Vertical bumps (simulate small suspension bounce)
	var bump = sin(sway_timer * bump_speed) * bump_amount

	# Target local offset
	target_offset = Vector3(sway, bump, 0)

	# Smooth follow to simulate heavy suspension / lag
	velocity = lerp(velocity, target_offset, lag_strength)
	transform.origin = velocity
