class_name Gen_Assiete
extends EntityBase

@export var spawnY: float = 1.0
@export var assiete = preload("res://assets/models/restaurant/Placeable3D/assiete.tscn")

func Interact(oInteractor: Node) -> void:
	if not CanInteract(oInteractor):
		return
	
	super.Interact(oInteractor)
	Toggle(null)

func GetPrompt() -> String:
	if not CanInteract(null):
		return super.GetPrompt()
	
	return "Interact"

func Toggle(oInteractor: Node):
	var instance = assiete.instantiate()
	add_child(instance)
	instance.global_position = global_position - Vector3(0, spawnY, 0)
	instance.scale = Vector3(2, 2, 2)
	
	print("Position new assiete:", global_position - Vector3(0, spawnY, 0))
	return
