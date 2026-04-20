class_name ActivationTarget
extends Resource

# --------------------------------------------------
# Data container used by ActivatorBase.
# Stores a reference to a target node and the extra
# arguments that will be passed when triggering it.
# --------------------------------------------------
@export var TargetPath: NodePath
# Extra args appended after the interactor argument.
@export var tExtraArgs: Array = []
