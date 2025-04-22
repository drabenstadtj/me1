extends CharacterBody3D

const MOVE_SPEED = 5.0
const GRAVITY = 9.8
const MOUSE_SENSITIVITY = 0.004

const BASE_FOV = 70.0
const MOVE_FOV = 75.0
const FOV_LERP_SPEED = 8.0

const BOB_SPEED = 15.0
const BOB_AMOUNT = 0.05

var input_enabled := true

var distortion_active := false
var distortion_strength := 1.0
var shake_time := 0.0

@onready var camera = $Camera3D
@onready var footstep_player = $FootstepPlayer

@onready var raycast = $Camera3D/RayCast3D
var last_prompt_target: Node = null

var pitch = 0.0
var bob_timer = 0.0
var camera_base_height = 0.0
var last_bob_sign = 0

var prompts_enabled := false


var current_state: State
var states = {}

var mat: ShaderMaterial
@onready var anim_player = $Model/AnimationPlayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_base_height = camera.transform.origin.y
	camera.fov = BASE_FOV

	states["Idle"] = preload("res://Assets/Scripts/Idle.gd").new()
	states["Move"] = preload("res://Assets/Scripts/Move.gd").new()

	for state in states.values():
		state.player = self
		add_child(state)

	await get_tree().process_frame 
	await get_tree().process_frame 


	change_state("Idle")


func _unhandled_input(event):
	if not input_enabled:
		if event.is_action_pressed("ui_cancel"):
			get_tree().quit()	
		return
		


	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		pitch = clamp(pitch - event.relative.y * MOUSE_SENSITIVITY, deg_to_rad(-60), deg_to_rad(60))
		camera.rotation.x = pitch

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func _process(delta):
	if current_state:
		current_state.update(delta)

	if not prompts_enabled:
		_clear_prompt()
		return

	if distortion_active:
		shake_time += delta
		var base_pitch = deg_to_rad(-15.0)
		var shake_x = sin(shake_time * 2.3) * deg_to_rad(0.5) * distortion_strength
		var shake_z = cos(shake_time * 1.8) * deg_to_rad(0.3) * distortion_strength
		camera.rotation.x = base_pitch + shake_x
		camera.rotation.z = shake_z

	# Raycast prompt detection
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var hit = raycast.get_collider()

		if hit.has_method("show_prompt"):
			if last_prompt_target and last_prompt_target != hit:
				if last_prompt_target.has_method("hide_prompt"):
					last_prompt_target.hide_prompt()

			hit.show_prompt()
			last_prompt_target = hit
		else:
			_clear_prompt()
	else:
		_clear_prompt()

func _clear_prompt():
	if last_prompt_target and last_prompt_target.has_method("hide_prompt"):
		last_prompt_target.hide_prompt()
	last_prompt_target = null





func change_state(new_state_name: String):
	if current_state:
		current_state.exit()
	current_state = states[new_state_name]
	current_state.enter()

func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)

func reset_camera_height():
	var cam_transform = camera.transform
	cam_transform.origin.y = lerp(cam_transform.origin.y, camera_base_height, 0.1)
	camera.transform = cam_transform
	
func look_at_customer(path: NodePath):
	var target = get_node(path)

	var to_target_flat = target.global_position - global_position
	to_target_flat.y = 0
	var target_yaw = atan2(-to_target_flat.x, -to_target_flat.z)

	var cam_origin = camera.global_transform.origin
	var to_target = (target.global_position - cam_origin).normalized()
	var cam_forward = -camera.global_transform.basis.z.normalized()

	var dot = cam_forward.dot(to_target)
	dot = clamp(dot, -1.0, 1.0)
	#var angle_between = acos(dot)
	#var direction = sign(to_target.y)
	#var raw_pitch = direction * angle_between
	#var clamped_pitch = clamp(raw_pitch, deg_to_rad(-10), deg_to_rad(10))

	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation:y", target_yaw, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var slight_down = deg_to_rad(-15.0)
	tween.tween_property(camera, "rotation:x", slight_down, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func start_drunk_effect():
	var fade_controller = get_node("/root/World/SubViewportContainer/SubViewport/FadeController")
	distortion_active = true
	distortion_strength = 3.0  # Or however intense you want

	# Step 1: Fade in blur
	var tween := get_tree().create_tween()

	#Delay, then trigger fade to black
	tween.tween_callback(Callable(fade_controller, "fade_out")).set_delay(2.5)
	
	tween.tween_property(self, "rotation:x", deg_to_rad(-30), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Step 3: Fade blur off *after* fade out finishes (e.g. 1s fade)
	tween.tween_callback(func(): distortion_active = false).set_delay(4.5)

func switch_to_scene(path: String):
	get_tree().change_scene_to_file(path)


func enable_prompt():
	prompts_enabled = true
	
	
func disable_prompt():
	prompts_enabled = false
