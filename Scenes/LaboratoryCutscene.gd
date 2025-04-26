extends Node3D
var anim_player

func _ready():
	anim_player = get_node("/root/World/SubViewportContainer/SubViewport/CutsceneController/AnimationPlayer")
	anim_player.play("PlayerWakeUp")


func horror():
	anim_player.play("Amputation")


func load_new_scene():
	get_tree().change_scene_to_file("res://Scenes/end-world.tscn")
	
func load_new_scene_from_path(path: String):
	get_tree().change_scene_to_file(path)
