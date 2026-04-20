class_name LocalPlayerInputState
extends RefCounted

var vecMoveInput: Vector2 = Vector2.ZERO
var vecLookInput: Vector2 = Vector2.ZERO

var bMoveForwardPressed: bool = false
var bMoveBackwardPressed: bool = false
var bMoveLeftPressed: bool = false
var bMoveRightPressed: bool = false

var bJumpPressed: bool = false
var bJumpJustPressed: bool = false
var bJumpJustReleased: bool = false

func BeginFrame() -> void:
	vecLookInput = Vector2.ZERO
	bJumpJustPressed = false
	bJumpJustReleased = false
