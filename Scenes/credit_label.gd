extends CanvasLayer

@onready var label: Label = $CreditLabel

var credits := [
	"CREDITS",
	"",
	"Character Model:\nMale Casual\nvinrax — itch.io",
	"",
	"Environment Assets:\nCity Assets, Furniture, Bar Props\nElbolilloduro — itch.io",
	"",
	"Props & Misc Assets:\nPSX Computer\npomarf — itch.io\nHospital Assets\natomicrealm — itch.io",
	"",
	"Sound Effects:\nScream\nkrzysiunet — freesound.org\nSaw Loop\nacclivity — freesound.org\nFemur Breaker\nSCP: Containment Breach",
	"",
	"Music:\nRamza — Instagram",
	#"",
	#"Special Thanks"
]



var display_time := 3.0  # Time per credit
var fade_time := 1.0     # Time to fade in/out

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	label.modulate.a = 0.0
	show_credits()
	

func _unhandled_input(event):
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()	
			
func show_credits() -> void:
	# Start coroutine (does not block the scene)
	_run_credits()

func _run_credits() -> void:
	await get_tree().process_frame
	for text in credits:
		label.text = text
		await fade_in()
		await get_tree().create_timer(display_time).timeout
		await fade_out()

func fade_in():
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, fade_time)
	await tween.finished

func fade_out():
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, fade_time)
	await tween.finished
