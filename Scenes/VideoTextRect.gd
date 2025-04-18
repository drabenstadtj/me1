extends Node3D

@onready var video_player: VideoStreamPlayer = $VideoViewport/VideoStreamPlayer
@onready var texture_rect: TextureRect = $VideoViewport/VideoPlayerUI/TextureRect
@onready var tv_screen: MeshInstance3D = $TVScreen
@onready var viewport: Viewport = $VideoViewport

func _ready():
	# Set the TextureRect to show the video
	texture_rect.texture = video_player.get_video_texture()

	# Create a ViewportTexture and apply to the TV mesh
	var vp_texture := ViewportTexture.new()
	vp_texture.viewport_path = viewport.get_path()

	var mat := StandardMaterial3D.new()
	mat.albedo_texture = vp_texture
	tv_screen.material_override = mat

	# Play the video (optional if autoplay is on)
	video_player.play()
