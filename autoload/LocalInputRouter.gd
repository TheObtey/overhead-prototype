extends Node

const MAX_PLAYERS: int = 2
const MOVE_STICK_DEADZONE: float = 0.20
const LOOK_STICK_DEADZONE: float = 0.12

var _states: Array[LocalPlayerInputState] = []
var _bindings: Array[LocalPlayerDeviceBinding] = []

func _ready() -> void:
	for i in range(MAX_PLAYERS):
		_states.append(LocalPlayerInputState.new())
		_bindings.append(null)
	
	# TEMP setup (TODO: remove this temp shit)
	_bindings[0] = LocalPlayerDeviceBinding.CreateKeyboardMouse()
	_bindings[1] = LocalPlayerDeviceBinding.CreateJoypad(0)

func ConsumeLookInput(iPlayerID: int) -> Vector2:
	if iPlayerID < 0 or iPlayerID >= _states.size():
		return Vector2.ZERO
	
	var oBinding = GetBinding(iPlayerID)
	if oBinding == null:
		return Vector2.ZERO
	
	if oBinding.enumBindingType == LocalPlayerDeviceBinding.BindingType.KEYBOARD_MOUSE:
		var vecLookInput: Vector2 = _states[iPlayerID].vecLookInput
		_states[iPlayerID].vecLookInput = Vector2.ZERO
		return vecLookInput
	
	if oBinding.enumBindingType == LocalPlayerDeviceBinding.BindingType.JOYPAD:
		return _states[iPlayerID].vecLookInput
	
	return Vector2.ZERO

func ConsumeJumpJustPressed(iPlayerID: int) -> bool:
	if iPlayerID < 0 or iPlayerID >= _states.size():
		return false
	
	var bWasJustPressed: bool = _states[iPlayerID].bJumpJustPressed
	_states[iPlayerID].bJumpJustPressed = false
	
	return bWasJustPressed

func _input(oEvent: InputEvent) -> void:
	for i in range(MAX_PLAYERS):
		var binding = _bindings[i]
		if binding == null:
			continue
		
		match binding.enumBindingType:
			LocalPlayerDeviceBinding.BindingType.KEYBOARD_MOUSE:
				_HandleKeyboardMouseEvent(i, oEvent)
			
			LocalPlayerDeviceBinding.BindingType.JOYPAD:
				_HandleJoypadEvent(i, oEvent, binding.iJoypadDeviceID)

func _ApplyDeadzoneToAxis(iValue: float, iDeadzone: float) -> float:
	if abs(iValue) < iDeadzone:
		return 0.0
	
	return iValue

func _HandleKeyboardMouseEvent(iPlayerID: int, oEvent: InputEvent) -> void:
	var state = _states[iPlayerID]
	
	if oEvent is InputEventMouseMotion:
		state.vecLookInput += oEvent.relative
	
	if oEvent is InputEventKey:
		if oEvent.is_action_pressed("move_forward"):
			state.bMoveForwardPressed = true
		if oEvent.is_action_released("move_forward"):
			state.bMoveForwardPressed = false
		
		if oEvent.is_action_pressed("move_backward"):
			state.bMoveBackwardPressed = true
		if oEvent.is_action_released("move_backward"):
			state.bMoveBackwardPressed = false
		
		if oEvent.is_action_pressed("move_left"):
			state.bMoveLeftPressed = true
		if oEvent.is_action_released("move_left"):
			state.bMoveLeftPressed = false
		
		if oEvent.is_action_pressed("move_right"):
			state.bMoveRightPressed = true
		if oEvent.is_action_released("move_right"):
			state.bMoveRightPressed = false
		
		if oEvent.is_action_pressed("jump"):
			state.bJumpPressed = true
			state.bJumpJustPressed = true
		
		if oEvent.is_action_released("jump"):
			state.bJumpPressed = false
			state.bJumpJustReleased = true
	
	state.vecMoveInput = Vector2(
		int(state.bMoveRightPressed) - int(state.bMoveLeftPressed),
		int(state.bMoveBackwardPressed) - int(state.bMoveForwardPressed)
	).normalized()

func _HandleJoypadEvent(iPlayerID: int, oEvent: InputEvent, iDeviceID: int) -> void:
	if not (oEvent is InputEventJoypadButton or oEvent is InputEventJoypadMotion):
		return
	
	if oEvent.device != iDeviceID:
		return
	
	var state = _states[iPlayerID]
	
	if oEvent is InputEventJoypadMotion:
		match oEvent.axis:
			# LOOK (right stick)
			JOY_AXIS_RIGHT_X:
				state.vecLookInput.x = _ApplyDeadzoneToAxis(oEvent.axis_value, LOOK_STICK_DEADZONE)
			JOY_AXIS_RIGHT_Y:
				state.vecLookInput.y = _ApplyDeadzoneToAxis(oEvent.axis_value, LOOK_STICK_DEADZONE)
			
			# MOVE (left stick)
			JOY_AXIS_LEFT_X:
				state.vecMoveInput.x = _ApplyDeadzoneToAxis(oEvent.axis_value, MOVE_STICK_DEADZONE)
			JOY_AXIS_LEFT_Y:
				state.vecMoveInput.y = _ApplyDeadzoneToAxis(oEvent.axis_value, MOVE_STICK_DEADZONE)
	
	if oEvent.is_action_pressed("jump"):
		state.bJumpPressed = true
		state.bJumpJustPressed = true
	
	if oEvent.is_action_released("jump"):
		state.bJumpPressed = false
		state.bJumpJustReleased = true

func _UpdateKeyboardMouse() -> void:
	for i in range(MAX_PLAYERS):
		var binding = _bindings[i]
		if binding == null:
			continue
		
		if binding.enumBindingType != LocalPlayerDeviceBinding.BindingType.KEYBOARD_MOUSE:
			continue
		
		var state = _states[i]
		
		state.vecMoveInput = Input.get_vector(
			"move_left",
			"move_right",
			"move_forward",
			"move_backward"
		)

func GetState(iPlayerID: int) -> LocalPlayerInputState:
	if iPlayerID < 0 or iPlayerID >= _states.size():
		return null
	
	return _states[iPlayerID]

func GetBinding(iPlayerID: int) -> LocalPlayerDeviceBinding:
	if iPlayerID < 0 or iPlayerID >= _bindings.size():
		return null
	
	return _bindings[iPlayerID]

func SetBinding(iPlayerID: int, binding: LocalPlayerDeviceBinding) -> void:
	if iPlayerID < 0 or iPlayerID >= _bindings.size():
		return
	
	_bindings[iPlayerID] = binding
