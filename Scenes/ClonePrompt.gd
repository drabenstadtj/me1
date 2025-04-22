extends Area3D

@export var thought_label_path: NodePath  # Path to the ThoughtLabel node
@export var thought_text: String = "What the fuck? Is that... me?"
@export var char_delay: float = 0.04
@export var animation_name: String = ""  # Leave empty if no animation should play

var _label: Label
var _is_typing = false
var _skip_typing = false
var _has_been_triggered = false
var animator: AnimationPlayer

func _ready():
	_label = get_node(thought_label_path)
	animator = get_tree().get_root().get_node("World/SubViewportContainer/SubViewport/CutsceneController/AnimationPlayer")
	self.body_entered.connect(_on_body_entered)

func _input(event):
	if event.is_action_pressed("click") and not _is_typing and _label.visible:
		_label.visible = false

func _on_body_entered(body):
	if _has_been_triggered:
		return
	if body.name == "Player":
		_has_been_triggered = true
		show_thought(thought_text)

func show_thought(text: String) -> void:
	_label.text = ""
	_label.visible = true
	_is_typing = true
	_skip_typing = false
	await typewriter(text)
	_is_typing = false
	if animation_name != "" and animator.has_animation(animation_name):
		await get_tree().create_timer(4.0).timeout
		animator.play(animation_name)

func typewriter(text: String) -> void:
	for c in text:
		if _skip_typing:
			break
		_label.text += c
		await get_tree().create_timer(char_delay).timeout
	if _skip_typing:
		_label.text = text
