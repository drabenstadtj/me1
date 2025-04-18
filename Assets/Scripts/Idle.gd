extends State

func enter():
	player.bob_timer = 0.0
	player.last_bob_sign = 0
	player.anim_player.play("Idle")

func physics_update(_delta):
	var input_vec = player.get_input_vector()
	if input_vec.length_squared() > 0.01:
		player.change_state("Move")
