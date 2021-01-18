extends KinematicBody2D

enum{
	Moving,
	Attacking,
	Idle
}


const ACCEL = 600
const MAXSPEED = 400

var state = Moving

var Motion = Vector2.ZERO
var Direction = 1

signal Attacked

func _process(delta):
	match state:
		Moving:
			Move(delta)
		Attacking:
			Attack(delta)
		Idle:
			Idling(delta)

func Move(delta):
	var Xinput = Input.get_action_strength("Input_right") - Input.get_action_strength("Input_left")
	var Yinput = Input.get_action_strength("Input_down") - Input.get_action_strength("Input_up")
	
	if Xinput != 0:
		Motion.x += Xinput * ACCEL * delta
		Motion.x = clamp(Motion.x, -MAXSPEED, MAXSPEED)
		$AnimationPlayer.play("Run")
	else:
		Motion.x = lerp(Motion.x, 0, 0.22)
	
	if Yinput != 0:
		Motion.y = 250 * Yinput
	else:
		Motion.y = 0
	
	if Motion.x == 0:
		state = Idle
	
	if Input.is_action_just_pressed("Input_attack"):
		state = Attacking
	move_and_slide(Motion)

func Idling(delta):
	$AnimationPlayer.play("Idle")
	
	Motion.x = 0
	
	if Input.is_action_just_pressed("Input_right") || Input.is_action_just_pressed("Input_left"):
		state = Moving
	if Input.is_action_just_pressed("Input_attack"):
		state = Attacking
	move_and_slide(Motion)

func Attack(delta):
	emit_signal("Attacked")
	$AnimationPlayer.play("Attack")
	Motion.x = 0
	Motion.y = 0
	
	if Input.is_action_just_pressed("Input_right") || Input.is_action_just_pressed("Input_left"):
		state = Moving
	
	move_and_slide(Motion)
