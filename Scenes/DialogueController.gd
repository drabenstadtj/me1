extends Node

var thought_label

@export var dialogue_lines = [
]

var current_index = 0
var is_typing = false
var char_delay := 0.04  # delay per character
var skip_typing = false

var started = false
@export var autoplay = false
@export var start_delay = 0.0

func _ready():
	thought_label = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/UI/ThoughtLabel")
	if autoplay:
		start()
	

func start():
	await get_tree().create_timer(start_delay).timeout
	started = true
	
	thought_label.visible = false
	show_next_line()

func show_next_line():
	if current_index >= dialogue_lines.size():
		thought_label.visible = false
		return

	var line = dialogue_lines[current_index]
	current_index += 1
	await type_text(line)

func _input(event):
	if started:
		if event.is_action_pressed("click"):
			if is_typing:
				skip_typing = true
			else:
				show_next_line()

func type_text(line: String) -> void:
	is_typing = true
	skip_typing = false
	thought_label.text = ""
	thought_label.visible = true

	for i in line.length():
		if skip_typing:
			break
		thought_label.text += line[i]
		await get_tree().create_timer(char_delay).timeout

	# If skipped, show full line instantly
	if skip_typing:
		thought_label.text = line

	is_typing = false
