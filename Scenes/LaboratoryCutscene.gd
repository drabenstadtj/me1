extends Node3D

func _ready():
	var anim_player = get_node("/root/World/SubViewportContainer/SubViewport/CutsceneController/AnimationPlayer")
	anim_player.play("PlayerWakeUp")
