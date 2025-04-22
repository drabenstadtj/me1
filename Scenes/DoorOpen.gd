extends Node3D  # DoorPivot

@export var open_angle_degrees := -90.0
@export var open_speed := 2.0  # radians per second
@export var trigger_area: Area3D
@export var audio_player: AudioStreamPlayer3D

var is_open := false
var target_angle := 0.0
var cracked_angle := deg_to_rad(-10.0)  # Slight crack open

func _ready():
	rotation.y = cracked_angle  # Visually crack open
	target_angle = cracked_angle  # So it doesn't animate shut
	trigger_area.body_entered.connect(_on_body_entered)

func _process(delta):
	var current = rotation.y
	var new_angle = lerp_angle(current, target_angle, delta * open_speed)
	rotation.y = new_angle

func toggle_door():
	is_open = !is_open
	target_angle = deg_to_rad(open_angle_degrees) if is_open else cracked_angle
	audio_player.play()

func _on_body_entered(body):
	if body.name == "Player" and not is_open:
		toggle_door()
