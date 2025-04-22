extends Node3D


@onready var cutscene: AnimationPlayer = $AnimationPlayer

func _ready():
	cutscene.play("Cutscene")
