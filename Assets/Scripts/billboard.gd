extends Node3D

@onready var camera = get_viewport().get_camera_3d()

func _process(_delta):
	if camera:
		var look_pos = camera.global_position
		look_pos.y = global_position.y  # lock Y level to avoid jitter
		look_at(look_pos, Vector3.UP)
