extends Node3D

func _process(_delta):
	var player_cam = get_node("/root/World/SubViewportContainer/SubViewport/Player/Camera3D")
	var mirror_cam = $MirrorViewportContainer/MirrorSubViewport/Camera3D
	

	var mirror = global_transform  # the mirror's transform
	var normal = mirror.basis.z.normalized()  # assuming mirror faces +Z
	
	# Step 1: Mirror the position
	var cam_pos = player_cam.global_transform.origin
	var to_mirror = cam_pos - mirror.origin
	var distance = to_mirror.dot(normal)
	var mirrored_pos = cam_pos - 2.0 * distance * normal
	
	# Step 2: Mirror the basis (rotation)
	basis = player_cam.global_transform.basis
	var mirrored_basis = Basis(
		basis.x - 2.0 * basis.x.dot(normal) * normal,
		basis.y - 2.0 * basis.y.dot(normal) * normal,
		basis.z - 2.0 * basis.z.dot(normal) * normal
	)
	
	# Step 3: Apply the transform to mirror camera
	var mirrored_transform = Transform3D(mirrored_basis, mirrored_pos)
	mirror_cam.global_transform = mirrored_transform
