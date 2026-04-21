extends Node

class_name AnimationHandler

var animLauncher :AnimationPlayer;
@onready var oEmptyHand: Node3D = $charNode01/globalMove01/joints01/Skeleton3D/CameraOverlay/Hand_R
@onready var oGunPart1: Node3D = $charNode01/globalMove01/joints01/Skeleton3D/CameraOverlay/HandGun_R
@onready var oGunPart2: Node3D = $charNode01/globalMove01/joints01/Skeleton3D/CameraOverlay/Battery_and_Tape
@onready var oGunHand: Node3D = $charNode01/globalMove01/joints01/Skeleton3D/CameraOverlay/Canon
@onready var oHandsPivot: Node3D = $charNode01/globalMove01/joints01/Skeleton3D/CameraOverlay

static var bHasGun : bool = true
static var iCamPitch :float = 0.0
static var bChangeCamPitch :bool = false
@onready var bIsGunDisplayed : bool = false

enum AnimState {WALK, RUN, JUMP, POINT, SHOOT, IDLE, NONE}

static var enumNewState : AnimState = AnimState.NONE;
var enumCurrentState : AnimState;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animLauncher = $AnimationPlayer
	enumCurrentState = AnimState.IDLE
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bIsGunDisplayed != AnimationHandler.bHasGun:
		SwitchDisplayedHand()
	if AnimationHandler.bChangeCamPitch == true:
		ChangeCameraPitch(-AnimationHandler.iCamPitch)
	
	if animLauncher.is_playing() == false:
		enumCurrentState = AnimState.NONE
	if AnimationHandler.enumNewState == enumCurrentState:
		pass
	match AnimationHandler.enumNewState:
		AnimState.JUMP:
			JumpAnimation()
		AnimState.POINT:
			PointAnimation()
		AnimState.SHOOT:
			ShootAnimation()
		AnimState.RUN:
			StartRunningAnim()
		AnimState.WALK:
			StartWalkingAnim()
		AnimState.IDLE:
			StartIdleAnim()
	pass

func ChangeCameraPitch(iPitch : float) -> void :
	oHandsPivot.rotation.x = iPitch
	AnimationHandler.bChangeCamPitch = false
	pass

static func SetCamPitch(iPitch : float) -> void :
	bChangeCamPitch = true
	iCamPitch = iPitch
	pass

func SwitchDisplayedHand() -> void:
	match AnimationHandler.bHasGun:
		true:
			bIsGunDisplayed = true
			oGunPart1.visible = true
			oGunPart2.visible = true
			oGunHand.visible = true
			oEmptyHand.visible = false
		false:
			bIsGunDisplayed = false
			oEmptyHand.visible = true
			oGunPart1.visible = false
			oGunPart2.visible = false
			oGunHand.visible = false

func ShootAnimation() -> void :
	# wait for anim
	pass

func PointAnimation() -> void :
	if enumCurrentState != AnimState.IDLE:
		pass
	enumCurrentState = AnimState.POINT;
	animLauncher.play("PlayerAnimation/Point");
	pass

func JumpAnimation() -> void :
	if enumCurrentState == AnimState.JUMP:
		pass
	enumCurrentState = AnimState.JUMP
	animLauncher.play("PlayerAnimation/Jump");
	pass
	
func StartWalkingAnim() -> void :
	match enumCurrentState:
		AnimState.JUMP:
			return
		AnimState.SHOOT:
			return
	enumCurrentState = AnimState.WALK
	animLauncher.play("PlayerAnimation/Walk");
	pass

func StartRunningAnim() -> void :
	match enumCurrentState:
		AnimState.JUMP:
			return
		AnimState.SHOOT:
			return
	enumCurrentState = AnimState.RUN
	animLauncher.play("PlayerAnimation/Run");
	pass

func StartIdleAnim() -> void :
	match enumCurrentState:
		AnimState.JUMP:
			return
	enumCurrentState = AnimState.IDLE
	animLauncher.play("PlayerAnimation/Idle");
	pass
	
func StopCurrentAnim() -> void :
	animLauncher.stop();
	enumCurrentState = AnimState.NONE
	pass
	
