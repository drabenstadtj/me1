extends Camera3D

var limit_look := false
var min_pitch := deg_to_rad(-60)
var max_pitch := deg_to_rad(60)

func restrict_view(min_angle := -10.0, max_angle := 10.0):
	limit_look = true
	min_pitch = deg_to_rad(min_angle)
	max_pitch = deg_to_rad(max_angle)

func clear_restriction():
	limit_look = false
