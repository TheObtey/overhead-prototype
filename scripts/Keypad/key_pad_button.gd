extends EntityBase


@onready var keypad: Node3D = $"../../.."

@export var value : String = "0"

func GetPrompt() -> String:
	return value


func Interact(pPlayer: CharacterBody3D) -> void:
	if value == "*":
		keypad.clear()
	elif value == "#":
		keypad.validate()
	else :
		keypad.press_key(value)
