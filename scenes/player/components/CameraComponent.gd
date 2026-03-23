extends Node

@export var mouse_sensitivity: float = 0.002
@export var min_pitch: float = -89.0
@export var max_pitch: float = 89.0

var player: CharacterBody3D
var camera_root: Node3D
var camera: Camera3D

var pitch: float = 0.0

func setup(p_player: CharacterBody3D, p_camera_root: Node3D, p_camera: Camera3D) -> void:
	player = p_player
	camera_root = p_camera_root
	camera = p_camera

func handle_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * mouse_sensitivity)
		
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
		
		camera_root.rotation.x = pitch
