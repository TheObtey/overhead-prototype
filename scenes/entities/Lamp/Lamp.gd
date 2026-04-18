extends EntityBase

@onready var oMesh := $Visuals/CSGBox3D
var oMat: StandardMaterial3D
var bisOn = false

func _ready():
	oMat = oMesh.material
	
func Toggle(cNewOnColor: Color, cNewOffColor: Color):
	if bisOn:
		oMat.albedo_color = cNewOnColor
	else:
		oMat.albedo_color = cNewOffColor
	bisOn = !bisOn
