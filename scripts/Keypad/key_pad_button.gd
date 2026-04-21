extends EntityBase


#@onready var keypad: Node3D = $"../../.."
@onready var keypad: Node3D = $"../../../.."

@export var value : String = "0"

func GetPrompt() -> String:
	return value


func Interact(oInt: Node) -> void:
	if value == "*":
		keypad.clear()
	elif value == "#":
		keypad.validate()
	else :
		keypad.press_key(value)
