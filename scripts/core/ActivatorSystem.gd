extends Node

@export var tActivators: Array[NodePath] = []

func _ready():
	for path in tActivators:
		var node = get_node(path)
		if node and node.has_signal("sActivated"):
			node.sActivated.connect(OnActivated)
		else:
			push_warning("'%s' n'a pas de signal sActivated" % [node])

func OnActivated():
	for child in get_children():
		if not child is ActorConfig:
			continue
		var config := child as ActorConfig
		var node: Node = config.oTarget
		if not node or not node.has_method("Toggle"):
			push_warning("'%s' n'a pas de méthode Toggle" % [node])
			continue

		var arg_count := _getFuncArgCount(node, "Toggle")
		if arg_count == 0:
			node.call("Toggle")
		else:
			node.callv("Toggle", config.tFuncArgs)

func _getFuncArgCount(node: Node, method: String) -> int:
	for m in node.get_method_list():
		if m["name"] == method:
			return m["args"].size()
	return -1
