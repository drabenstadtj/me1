extends StaticBody3D

@export var prompt_text: String = "Press to create a clone"
var prompt_label
var anim_player
@export var animation_name: String

func _ready():
	# Reference your global UI prompt
	anim_player = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/CutsceneController/AnimationPlayer")
	prompt_label = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/UI/PromptLabel")
	prompt_label.visible = false

func show_prompt():
	prompt_label.text = prompt_text
	prompt_label.visible = true

func hide_prompt():
	prompt_label.visible = false

func interact():
	if anim_player.has_animation(animation_name):
		anim_player.play(animation_name)
