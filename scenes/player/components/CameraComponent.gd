extends Node

@export var iMouseSensitivity: float = 0.002
@export var iMinPitch: float = -89.0
@export var iMaxPitch: float = 89.0

var oPlayer: CharacterBody3D
var oCameraRoot: Node3D
var oCamera: Camera3D

var iPitch: float = 0.0

func Setup(oNewPlayer: CharacterBody3D, oNewCameraRoot: Node3D, oNewCamera: Camera3D) -> void:
	oPlayer = oNewPlayer
	oCameraRoot = oNewCameraRoot
	oCamera = oNewCamera

func HandleInput(oEvent: InputEvent) -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	
	if oEvent is InputEventMouseMotion:
		HandleMouseLook(oEvent)

func HandleMouseLook(oEvent: InputEventMouseMotion) -> void:
	var vecLocalUp: Vector3 = oPlayer.transform.basis.y.normalized()
	
	oPlayer.rotate(vecLocalUp, -oEvent.relative.x * iMouseSensitivity)
	
	iPitch -= oEvent.relative.y * iMouseSensitivity
	iPitch = clamp(iPitch, deg_to_rad(iMinPitch), deg_to_rad(iMaxPitch))
	
	oCameraRoot.rotation.x = iPitch
	AnimationHandler.SetCamPitch(iPitch,oPlayer.iPlayerID)
