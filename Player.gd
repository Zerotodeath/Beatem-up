extends KinematicBody2D

enum{
	Moving,
	Attacking,
	Idle
}


const ACCEL = 600
const MAXSPEED = 400

var state = Moving

var Xinput
var Yinput

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
	Xinput = Input.get_action_strength("Input_right") - Input.get_action_strength("Input_left")
	Yinput = Input.get_action_strength("Input_down") - Input.get_action_strength("Input_up")
	
	if Xinput != 0:
		Motion.x += Xinput * ACCEL * delta
		Motion.x = clamp(Motion.x, -MAXSPEED, MAXSPEED)
		$AnimationPlayer.play("Run")
	
	if Xinput == 0:
		state = Idle
	
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
	
	Motion.x = lerp(Motion.x, 0, 0.22)
	
	if Input.is_action_just_pressed("Input_right") || Input.is_action_just_pressed("Input_left"):
		state = Moving
	if Input.is_action_just_pressed("Input_attack"):
		state = Attacking
	move_and_slide(Motion)

func Attack(delta):
	$AnimationPlayer.play("Attack")
	Motion.x = 0
	Motion.y = 0
	
	if Input.is_action_just_pressed("Input_right") || Input.is_action_just_pressed("Input_left"):
		state = Moving
	
	move_and_slide(Motion)


func _on_AnimationPlayer_animation_finished(Attack):
	if state == Attacking:
		state = Idle
