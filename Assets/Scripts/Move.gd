extends State

func enter():
	player.last_bob_sign = 0
	player.bob_timer = 0.0

func exit():
	player.reset_camera_height()

func physics_update(delta):
	var input_vec = player.get_input_vector()
	var direction = (player.transform.basis * Vector3(input_vec.x, 0, input_vec.y)).normalized()

	player.velocity.x = direction.x * player.MOVE_SPEED
	player.velocity.z = direction.z * player.MOVE_SPEED

	if not player.is_on_floor():
		player.velocity.y -= player.GRAVITY * delta
	else:
		player.velocity.y = 0.0

	player.move_and_slide()

	# FOV lerping
	player.camera.fov = lerp(player.camera.fov, player.MOVE_FOV, delta * player.FOV_LERP_SPEED)

	# Bobbing
	player.bob_timer += delta * player.BOB_SPEED
	var bob_sin = sin(player.bob_timer)
	var bob_offset = bob_sin * player.BOB_AMOUNT
	var current_sign = sign(bob_sin)

	# 👣 Footstep when sine crosses from negative to positive (approximate footstep timing)
	if current_sign > 0 and player.last_bob_sign <= 0:
		print_debug("Playing Footstep.")
		if player.footstep_player.playing:
			player.footstep_player.stop()
		player.footstep_player.play()

	player.last_bob_sign = current_sign

	var cam_transform = player.camera.transform
	cam_transform.origin.y = player.camera_base_height + bob_offset
	player.camera.transform = cam_transform

	if input_vec.length_squared() <= 0.01:
		player.change_state("Idle")
