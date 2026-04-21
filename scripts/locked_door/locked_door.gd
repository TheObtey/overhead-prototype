extends EntityBase

var isOpen = false

func Interactkey() -> void:
	toggle_door()
	
func CanInteract(oInt: Node) -> bool:
	return false

func toggle_door():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	if not isOpen:
		tween.tween_property(self, "rotation_degrees:y", 90.0, 0.6)
	else:
		tween.tween_property(self, "rotation_degrees:y", 0.0, 0.6)
	
	isOpen = !isOpen
