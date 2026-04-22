extends EntityBase


@onready var oKeypad: Node3D = $"../../../.."

@export var sValue : String = "0"

func GetPrompt() -> String:
	return sValue


func Interact(oInt: Node) -> void:
	if sValue == "*":
		oKeypad.clear()
	elif sValue == "#":
		oKeypad.validate()
	else :
		oKeypad.press_key(sValue)
