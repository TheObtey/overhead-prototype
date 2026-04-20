class_name LocalPlayerInputState
extends RefCounted

var vecMoveInput: Vector2 = Vector2.ZERO
var vecLookInput: Vector2 = Vector2.ZERO
var vecLookDelta: Vector2 = Vector2.ZERO

var bMoveForwardPressed: bool = false
var bMoveBackwardPressed: bool = false
var bMoveLeftPressed: bool = false
var bMoveRightPressed: bool = false

var bJumpPressed: bool = false
var bJumpJustPressed: bool = false
var bJumpJustReleased: bool = false

func SetMoveButtonState(sAction: StringName, bPressed: bool) -> void:
	match sAction:
		"move_forward":
			bMoveForwardPressed = bPressed
		"move_backward":
			bMoveBackwardPressed = bPressed
		"move_left":
			bMoveLeftPressed = bPressed
		"move_right":
			bMoveRightPressed = bPressed
		_:
			return
	
	_RebuildKeyboardMoveVector()

func SetJumpPressed(bPressed: bool) -> void:
	if bJumpJustPressed == bPressed:
		return
	
	bJumpPressed = bPressed
	
	if bPressed:
		bJumpJustPressed = true
	else:
		bJumpJustReleased = true

func AddMouseLookDelta(vecDelta: Vector2) -> void:
	vecLookDelta += vecDelta

func SetJoypadMoveAxis(vecAxis: Vector2) -> void:
	vecMoveInput = vecAxis

func SetJoypadLookAxis(vecAxis: Vector2) -> void:
	vecLookInput = vecAxis

func ConsumeJumpJustPressed() -> bool:
	var bValue: bool = bJumpJustPressed
	bJumpJustPressed = false
	return bValue

func ConsumeLookDelta() -> Vector2:
	var vecDelta: Vector2 = vecLookDelta
	vecLookDelta = Vector2.ZERO
	return vecDelta

func ClearFrameFlags() -> void:
	bJumpJustReleased = false

func _RebuildKeyboardMoveVector() -> void:
	vecMoveInput = Vector2(
		int(bMoveRightPressed) - int(bMoveLeftPressed),
		int(bMoveBackwardPressed) - int(bMoveForwardPressed)
	).normalized()
