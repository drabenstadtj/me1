extends Node3D

@export var light_node_path: NodePath
@export var energy_step: float = 5.0     # Energy increase per second
@export var decay_speed: float = 2.0     # Energy decrease per second
@export var min_energy: float = 0.0
@export var max_energy: float = 0.5

var light_node: Light3D
var holding_click := false

func _ready():
	light_node = $CigLight

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		holding_click = event.pressed

func _process(delta):
	if holding_click:
		light_node.light_energy = clamp(light_node.light_energy + energy_step * delta, min_energy, max_energy)
	else:
		light_node.light_energy = clamp(light_node.light_energy - decay_speed * delta, min_energy, max_energy)
