extends Control

@export var scGameScene : PackedScene

@onready var uiBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer
@onready var uiPlayer1Icon = $MarginContainer/HBoxContainer/VBoxContainer2/TextureRect
@onready var uiPlayer1Label = $MarginContainer/HBoxContainer/VBoxContainer2/Label
@onready var uiPlayer2Icon = $MarginContainer/HBoxContainer/VBoxContainer/TextureRect
@onready var uiPlayer2Label = $MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var uiStartButton = $MarginContainer/TextureButton

var tBindings: Array[LocalPlayerDeviceBinding] = []
var bAcceptingNewBindings: bool = true
var iLastRegisteredJoypad: int = -999
var iLastRegisteredFrame: int = -1

func _ready() -> void:
	LocalSession.Reset()
	tBindings.clear()
	uiBoxContainer.visible = true
	uiStartButton.visible = true
	RefreshUI()

func _input(oEvent: InputEvent) -> void:
	if not bAcceptingNewBindings:
		return
	
	if tBindings.size() >= 2:
		return
	
	var oBinding = _BuildBindingFromEvent(oEvent)
	if oBinding == null:
		return
	
	if _IsBindingAlreadyRegistered(oBinding):
		return
	
	bAcceptingNewBindings = false
	tBindings.append(oBinding)
	RefreshUI()
	
	await get_tree().process_frame
	bAcceptingNewBindings = true

func RefreshUI() -> void:
	_UpdatePlayerSlot(uiPlayer1Label, 0)
	_UpdatePlayerSlot(uiPlayer2Label, 1)
	
	uiStartButton.visible = tBindings.size() == 2

func _IsBindingAlreadyRegistered(oBinding: LocalPlayerDeviceBinding) -> bool:
	for oExistingBinding in tBindings:
		if oExistingBinding.enumBindingType != oBinding.enumBindingType:
			continue
		
		match oBinding.enumBindingType:
			LocalPlayerDeviceBinding.BindingType.KEYBOARD_MOUSE:
				return true
			
			LocalPlayerDeviceBinding.BindingType.JOYPAD:
				if oExistingBinding.iJoypadDeviceID == oBinding.iJoypadDeviceID:
					return true
	
	return false

func _UpdatePlayerSlot(uiLabel: Label, iSlot: int) -> void:
	if iSlot >= tBindings.size():
		uiLabel.text = "Waiting for input..."
		return
	
	var oBinding: LocalPlayerDeviceBinding = tBindings[iSlot]
	
	match oBinding.enumBindingType:
		LocalPlayerDeviceBinding.BindingType.KEYBOARD_MOUSE:
			uiLabel.text = "Keyboard / Mouse"
		LocalPlayerDeviceBinding.BindingType.JOYPAD:
			uiLabel.text = "Gamepad " + str(oBinding.iJoypadDeviceID)

func _BuildBindingFromEvent(oEvent: InputEvent) -> LocalPlayerDeviceBinding:
	if oEvent is InputEventKey:
		if oEvent.pressed and not oEvent.echo:
			return LocalPlayerDeviceBinding.CreateKeyboardMouse()
	
	if oEvent is InputEventMouseButton:
		if oEvent.pressed:
			return LocalPlayerDeviceBinding.CreateKeyboardMouse()
	
	if oEvent is InputEventJoypadButton:
		if oEvent.pressed:
			return LocalPlayerDeviceBinding.CreateJoypad(oEvent.device)
	
	if oEvent is InputEventJoypadMotion:
		if abs(oEvent.axis_value) > 0.5:
			return LocalPlayerDeviceBinding.CreateJoypad(oEvent.device)
	
	return null

func _HasBindingAlready(oNewBinding: LocalPlayerDeviceBinding) -> bool:
	for oBinding in tBindings:
		if oBinding.enumBindingType != oNewBinding.enumBindingType:
			continue
		
		if oBinding.enumBindingType == LocalPlayerDeviceBinding.BindingType.KEYBOARD_MOUSE:
			return true
		
		if oBinding.enumBindingType == LocalPlayerDeviceBinding.BindingType.JOYPAD:
			return true
		
	return false

func _on_texture_button_pressed() -> void:
	if tBindings.size() != 2:
		return
	
	LocalSession.StartLocalSession(tBindings)
	get_tree().change_scene_to_packed(scGameScene)
	InGameMenu.bCanOpen = true
