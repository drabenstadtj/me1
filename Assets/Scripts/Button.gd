extends StaticBody3D

@export var prompt_text: String = "Press to create a clone"
var prompt_label

func _ready():
	# Reference your global UI prompt
	prompt_label = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/UI/PromptLabel")
	prompt_label.visible = false

func show_prompt():
	prompt_label.text = prompt_text
	prompt_label.visible = true

func hide_prompt():
	prompt_label.visible = false
