extends Node3D

@onready var interact_label: Label = $InteractLabel
var current_interactions: Array[Area3D] = []
var can_interact := true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if current_interactions.is_empty():
			return

		current_interactions.sort_custom(_sort_by_nearest)

		var target: Area3D = current_interactions[0]

		if not target.has_method("interact"):
			return

		can_interact = false
		interact_label.hide()

		await target.interact.call()

		can_interact = true


func _process(_delta: float) -> void:
	if current_interactions.is_empty() or not can_interact:
		interact_label.hide()
		return

	current_interactions.sort_custom(_sort_by_nearest)

	var target: Area3D = current_interactions[0]

	if not target.has_meta("interactable_checked"):
		pass

	if target.get("is_interactable") == null:
		interact_label.hide()
		return

	if not target.is_interactable:
		interact_label.hide()
		return

	var interact_name_value = target.get("interact_name")
	if interact_name_value == null:
		interact_label.hide()
		return

	interact_label.text = str(interact_name_value)
	interact_label.show()


func _sort_by_nearest(area1: Area3D, area2: Area3D) -> bool:
	var area1_dist: float = global_position.distance_to(area1.global_position)
	var area2_dist: float = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist


func _on_interact_range_area_entered(area: Area3D) -> void:
	if area.get("is_interactable") == null:
		return

	current_interactions.push_back(area)


func _on_interact_range_area_exited(area: Area3D) -> void:
	current_interactions.erase(area)
