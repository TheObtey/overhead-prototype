extends Area3D

@export var vecGravityDirection: Vector3 = Vector3.DOWN

func _ready() -> void:
	body_entered.connect(_OnBodyEntered)
	body_exited.connect(_OnBodyExited)

func _OnBodyEntered(oBody: Node3D) -> void:
	var oGravityReceiver: GravityReceiverComponent = _GetGravityReceiver(oBody)
	
	if oGravityReceiver == null:
		return
	
	oGravityReceiver.ReceiveGravityFromField(self, vecGravityDirection)

func _OnBodyExited(oBody: Node3D) -> void:
	var oGravityReceiver: GravityReceiverComponent = _GetGravityReceiver(oBody)
	
	if oGravityReceiver == null:
		return
	
	oGravityReceiver.ClearGravityFromField(self)

func _GetGravityReceiver(oBody: Node) -> GravityReceiverComponent:
	if oBody == null:
		return null
	
	var oReceiver := oBody.get_node_or_null("Components/GravityReceiverComponent")
	
	if oReceiver != null:
		return oReceiver as GravityReceiverComponent
	
	return null
