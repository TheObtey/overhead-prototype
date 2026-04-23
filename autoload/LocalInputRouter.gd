extends Node

const MAX_PLAYERS: int = 2
const MOVE_STICK_DEADZONE: float = 0.20
const LOOK_STICK_DEADZONE: float = 0.12

var _states: Array[LocalPlayerInputState] = []
var _bindings: Array[LocalPlayerDeviceBinding] = []

func _ready() -> void:
	_InitializeStates()
	_InitializeDefaultBindings()

func _process(_iDelta: float) -> void:
	for oState in _states:
		oState.ClearFrameFlags()

func _input(oEvent: InputEvent) -> void:
	for iPlayerID in range(MAX_PLAYERS):
		var oBinding: LocalPlayerDeviceBinding = _bindings[iPlayerID]
		if oBinding == null:
			continue
		
		if _DoesEventMatchBinding(oEvent, oBinding):
			_RouteEventToPlayer(iPlayerID, oEvent, oBinding)

func GetState(iPlayerID: int) -> LocalPlayerInputState:
	if not _IsValidPlayerID(iPlayerID):
		return null
	
	return _states[iPlayerID]

func GetBinding(iPlayerID: int) -> LocalPlayerDeviceBinding:
	if not _IsValidPlayerID(iPlayerID):
		return null
	
	return _bindings[iPlayerID]

func SetBinding(iPlayerID: int, binding: LocalPlayerDeviceBinding) -> void:
	if not _IsValidPlayerID(iPlayerID):
		return
	
	_bindings[iPlayerID] = binding

func ConfigureBindings(tNewBindings: Array[LocalPlayerDeviceBinding]) -> void:
	for i in range(MAX_PLAYERS):
		_bindings[i] = null
	
	for i in range( min(tNewBindings.size(), MAX_PLAYERS) ):
		_bindings[i] = tNewBindings[i]

func ConsumeJumpJustPressed(iPlayerID: int) -> bool:
	var oState: LocalPlayerInputState = GetState(iPlayerID)
	if oState == null:
		return false
	
	return oState.ConsumeJumpJustPressed()

func ConsumeLookInput(iPlayerID: int) -> Vector2:
	var oState: LocalPlayerInputState = GetState(iPlayerID)
	if oState == null:
		return Vector2.ZERO
	
	var oBinding: LocalPlayerDeviceBinding = GetBinding(iPlayerID)
	if oBinding == null:
		return Vector2.ZERO
	
	match oBinding.enumBindingType:
		LocalPlayerDeviceBinding.BindingType.KEYBOARD_MOUSE:
			return oState.ConsumeLookDelta()
	
		LocalPlayerDeviceBinding.BindingType.JOYPAD:
			return oState.vecLookInput
	
	return Vector2.ZERO

func _InitializeStates() -> void:
	_states.clear()
	
	for i in range(MAX_PLAYERS):
		_states.append(LocalPlayerInputState.new())

func _InitializeDefaultBindings() -> void:
	_bindings.clear()
	
	for _i in range(MAX_PLAYERS):
		_bindings.append(null)

func _DoesEventMatchBinding(oEvent: InputEvent, oBinding: LocalPlayerDeviceBinding) -> bool:
	match oBinding.enumBindingType:
		LocalPlayerDeviceBinding.BindingType.KEYBOARD_MOUSE:
			return oEvent is InputEventKey or oEvent is InputEventMouseMotion
		
		LocalPlayerDeviceBinding.BindingType.JOYPAD:
			if not (oEvent is InputEventJoypadButton or oEvent is InputEventJoypadMotion):
				return false
			
			return oEvent.device == oBinding.iJoypadDeviceID
	
	return false

func _RouteEventToPlayer(iPlayerID: int, oEvent: InputEvent, oBinding: LocalPlayerDeviceBinding) -> void:
	var oState: LocalPlayerInputState = _states[iPlayerID]
	
	match oBinding.enumBindingType:
		LocalPlayerDeviceBinding.BindingType.KEYBOARD_MOUSE:
			_HandleKeyboardMouseEvent(oState, oEvent)
		
		LocalPlayerDeviceBinding.BindingType.JOYPAD:
			_HandleJoypadEvent(oState, oEvent)

func _HandleKeyboardMouseEvent(oState: LocalPlayerInputState, oEvent: InputEvent) -> void:
	if oEvent is InputEventMouseMotion:
		oState.AddMouseLookDelta(oEvent.relative)
		return
	
	if oEvent is InputEventKey:
		for sMoveAction in ["move_forward", "move_backward", "move_left", "move_right"]:
			if oEvent.is_action_pressed(sMoveAction):
				oState.SetMoveButtonState(sMoveAction, true)
			elif oEvent.is_action_released(sMoveAction):
				oState.SetMoveButtonState(sMoveAction, false)
		
		if oEvent.is_action_pressed("jump"):
			oState.SetJumpPressed(true)
		elif oEvent.is_action_released("jump"):
			oState.SetJumpPressed(false)

func _HandleJoypadEvent(oState: LocalPlayerInputState, oEvent: InputEvent) -> void:
	if oEvent is InputEventJoypadMotion:
		var vecMoveAxis: Vector2 = oState.vecMoveInput
		var vecLookAxis: Vector2 = oState.vecLookInput
		
		match oEvent.axis:
			JOY_AXIS_LEFT_X:
				vecMoveAxis.x = _ApplyDeadzoneToAxis(oEvent.axis_value, MOVE_STICK_DEADZONE)
			JOY_AXIS_LEFT_Y:
				vecMoveAxis.y = _ApplyDeadzoneToAxis(oEvent.axis_value, MOVE_STICK_DEADZONE)
			JOY_AXIS_RIGHT_X:
				vecLookAxis.x = _ApplyDeadzoneToAxis(oEvent.axis_value, LOOK_STICK_DEADZONE)
			JOY_AXIS_RIGHT_Y:
				vecLookAxis.y = _ApplyDeadzoneToAxis(oEvent.axis_value, LOOK_STICK_DEADZONE)
		
		oState.SetJoypadMoveAxis(vecMoveAxis)
		oState.SetJoypadLookAxis(vecLookAxis)
		return
	
	if oEvent is InputEventJoypadButton:
		if oEvent.is_action_pressed("jump"):
			oState.SetJumpPressed(true)
		elif oEvent.is_action_released("jump"):
			oState.SetJumpPressed(false)

func _ApplyDeadzoneToAxis(iValue: float, iDeadzone: float) -> float:
	if abs(iValue) < iDeadzone:
		return 0.0
	
	var iSign: float = sign(iValue)
	var iMagnitude: float = (abs(iValue) - iDeadzone) / (1.0 - iDeadzone)
	
	return iSign * iMagnitude

func _IsValidPlayerID(iPlayerID: int) -> bool:
	return iPlayerID >= 0 and iPlayerID < MAX_PLAYERS
