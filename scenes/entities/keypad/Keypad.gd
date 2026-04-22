extends ActivatorBase

@onready var oNumber_on_screen: Label3D = $Visuals/Pad/Screen/Number_on_screen
@export var sCorrect_code : String = "1234567"
var sCurrent_input : String = ""

@export var oTarget : Node3D

signal code_correct
signal code_incorrect

func press_key(key: String):
	sCurrent_input += key
	oNumber_on_screen.text = sCurrent_input

func clear():
	sCurrent_input = ""
	oNumber_on_screen.text = sCurrent_input

func validate():
	if sCurrent_input == sCorrect_code:
		oNumber_on_screen.text = "correct"
		emit_signal("code_correct")
		if oTarget != null:
			oTarget.Interactkey()
	else:
		oNumber_on_screen.text = "incorrect"
		emit_signal("code_incorrect")
	
	sCurrent_input = ""
