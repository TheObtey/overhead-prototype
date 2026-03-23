extends Node

@onready var ray := $RayCast3D
@onready var hud := $InteractionHUD

var current_interactable: Interactable = null

func _process(_delta):
	_check_interaction()
	if Input.is_action_just_pressed("interact") and current_interactable:
		current_interactable.interact(self)

func _check_interaction():
	if ray.is_colliding():
		var hit = ray.get_collider()
		var target = _find_interactable(hit)
		if target and target.can_interact(self):
			_set_interactable(target)
			return
	_set_interactable(null)

func _find_interactable(node: Node) -> Interactable:
	var current = node
	while current:
		if current is Interactable:
			return current
		current = current.get_parent()
	return null

func _set_interactable(target: Interactable):
	if target == current_interactable:
		return
	current_interactable = target
	hud.visible = target != null
	if target:
		hud.set_prompt(target.get_prompt())
