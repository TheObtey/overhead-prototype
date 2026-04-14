extends Node3D

@onready var number_on_screen: Label3D = $Pad/Screen/Number_on_screen
@export var correct_code : String = "1234567"
var current_input : String = ""

@export var target : Node3D

signal code_correct
signal code_incorrect

func press_key(key: String):
	current_input += key
	number_on_screen.text = current_input
	print("Input:", current_input)

func clear():
	current_input = ""
	number_on_screen.text = current_input
	print("Cleared")

func validate():
	if current_input == correct_code:
		number_on_screen.text = "correct"
		print("Code correct !")
		emit_signal("code_correct")
		if target != null:
			target.Interactkey()
	else:
		number_on_screen.text = "incorrect"
		print("Code incorrect")
		emit_signal("code_incorrect")
	
	current_input = ""
