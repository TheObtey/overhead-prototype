extends Node

@export var iMouseSensitivity: float = 0.002
@export var iGamepadLookSensitivity: float = 0.03
@export var iMinPitch: float = -89.0
@export var iMaxPitch: float = 89.0

var oPlayer: CharacterBody3D
var iPlayerID: int = 0
var oCameraRoot: Node3D
var oCamera: Camera3D

var iPitch: float = 0.0

func Setup(oNewPlayer: CharacterBody3D, oNewCameraRoot: Node3D, oNewCamera: Camera3D) -> void:
	oPlayer = oNewPlayer
	iPlayerID = oPlayer.GetPlayerID()
	oCameraRoot = oNewCameraRoot
	oCamera = oNewCamera

func UpdateLook(iDelta: float) -> void:
	var oBinding: LocalPlayerDeviceBinding = LocalInputRouter.GetBinding(iPlayerID)
	if oBinding == null:
		return
	
	var vecLookInput: Vector2 = LocalInputRouter.ConsumeLookInput(iPlayerID)
	if vecLookInput == Vector2.ZERO:
		return
	
	var iYawDelta: float = 0.0
	var iPitchDelta: float = 0.0
	
	match oBinding.enumBindingType:
		LocalPlayerDeviceBinding.BindingType.KEYBOARD_MOUSE:
			iYawDelta = -vecLookInput.x * iMouseSensitivity
			iPitchDelta = -vecLookInput.y * iMouseSensitivity
		
		LocalPlayerDeviceBinding.BindingType.JOYPAD:
			iYawDelta = -vecLookInput.x * iGamepadLookSensitivity
			iPitchDelta = -vecLookInput.y * iGamepadLookSensitivity
	
	_ApplyLook(iYawDelta, iPitchDelta)

func _ApplyLook(iYawDelta: float, iPitchDelta: float) -> void:
	var vecLocalUp: Vector3 = oPlayer.transform.basis.y.normalized()
	
	oPlayer.rotate(vecLocalUp, iYawDelta)
	
	iPitch += iPitchDelta
	iPitch = clamp(iPitch, deg_to_rad(iMinPitch), deg_to_rad(iMaxPitch))
	
	oCameraRoot.rotation.x = iPitch
