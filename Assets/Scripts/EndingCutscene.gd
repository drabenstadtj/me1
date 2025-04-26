extends Node3D


@onready var cutscene: AnimationPlayer = $AnimationPlayer

func _ready():
	cutscene.play("Outro")

func quit_game():
	get_tree().quit()
