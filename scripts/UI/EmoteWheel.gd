extends Node

@onready var oWheel : Control = $Wheel
@onready var bIsOpen : bool = false
@onready var iOpenCD : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func Update(iDelta: float) -> void:
	iOpenCD += iDelta
	if (Input.is_key_pressed(KEY_E)):
		if bIsOpen and iOpenCD > 0.15:
			bIsOpen = false
			iOpenCD = 0.0
			CloseWheel()
		elif iOpenCD > 0.15:
			iOpenCD = 0.0
			bIsOpen = true
			OpenWheel()
	pass

func EmoteInterract(iEmoteID : int) -> void :
	CloseWheel()
	match iEmoteID:
		0:
			AnimationHandler.enumNewState = AnimationHandler.AnimState.POINT
	pass

func OpenWheel() -> void:
	oWheel.visible = true
	pass

func CloseWheel() -> void:
	oWheel.visible = false
	pass

func OverWheelPart(iEmoteID : int) -> void :
	var oEmoteSprite : Sprite2D = oWheel.get_child(iEmoteID)
	oEmoteSprite.modulate.a = 210;
	pass

func NotOverWheelPart(iEmoteID : int) -> void :
	var oEmoteSprite : Sprite2D = oWheel.get_child(iEmoteID)
	oEmoteSprite.modulate.a = 155;
	pass
