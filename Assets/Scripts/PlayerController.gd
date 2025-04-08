extends CharacterBody3D

const MOVE_SPEED = 5.0
const GRAVITY = 9.8
const MOUSE_SENSITIVITY = 0.004

const BASE_FOV = 70.0
const MOVE_FOV = 75.0
const FOV_LERP_SPEED = 8.0

const BOB_SPEED = 15.0
const BOB_AMOUNT = 0.05

@onready var camera = $Camera3D
@onready var footstep_player = $AudioStreamPlayer

var pitch = 0.0
var bob_timer = 0.0
var camera_base_height = 0.0
var last_bob_sign = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_base_height = camera.transform.origin.y
	camera.fov = BASE_FOV
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		pitch = clamp(pitch - event.relative.y * MOUSE_SENSITIVITY, deg_to_rad(-89), deg_to_rad(89))
		camera.rotation.x = pitch

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	var input_vec = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)

	var is_moving = input_vec.length_squared() > 0.01
	var direction = (transform.basis * Vector3(input_vec.x, 0, input_vec.y)).normalized()

	velocity.x = direction.x * MOVE_SPEED
	velocity.z = direction.z * MOVE_SPEED

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0.0

	move_and_slide()

	# FOV increase while moving
	var target_fov = MOVE_FOV if is_moving else BASE_FOV
	camera.fov = lerp(camera.fov, target_fov, delta * FOV_LERP_SPEED)

	# Bobbing and footstep
	if is_moving and is_on_floor():
		bob_timer += delta * BOB_SPEED
		var bob_offset = sin(bob_timer) * BOB_AMOUNT

		var current_sign = sign(sin(bob_timer))
		if last_bob_sign > 0 and current_sign <= 0:
			footstep_player.stop()
			footstep_player.play()
			
		last_bob_sign = current_sign

		var cam_transform = camera.transform
		cam_transform.origin.y = camera_base_height + bob_offset
		camera.transform = cam_transform
	else:
		# Reset
		bob_timer = 0.0
		last_bob_sign = 0
		var cam_transform = camera.transform
		cam_transform.origin.y = lerp(cam_transform.origin.y, camera_base_height, delta * 10.0)
		camera.transform = cam_transform
