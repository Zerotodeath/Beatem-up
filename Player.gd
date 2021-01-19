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

var Xinput
var Yinput

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
	if Yinput != 0:
		Motion.y += 550 * Yinput * delta
		Motion.y = clamp(Motion.y, -300, 300)
	
	if Xinput == 0:
		if Yinput == 0:
			state = Idle
	
	if Input.is_action_just_pressed("Input_attack"):
		state = Attacking
	move_and_slide(Motion)

func Idling(delta):
	$AnimationPlayer.play("Idle")
	$Hitbox/CollisionShape2D.disabled = true
	
	Motion.x = lerp(Motion.x, 0, 0.22)
	Motion.y = lerp(Motion.y, 0, .27)
	
	if Input.is_action_pressed("Input_right") || Input.is_action_just_pressed("Input_left") || Input.is_action_just_pressed("Input_up") || Input.is_action_just_pressed("Input_down"):
		state = Moving
	if Input.is_action_pressed("Input_attack"):
		state = Attacking
	move_and_slide(Motion)

func Attack(delta):
	$AnimationPlayer.play("Attack")
	Motion.x = lerp(Motion.x, 0, .1)
	Motion.y = lerp(Motion.y, 0, .12)
	
	if Xinput != 0:
		if Yinput != 0:
			state = Moving
	
	move_and_slide(Motion)


func _on_AnimationPlayer_animation_finished(Attack):
	if state == Attacking:
		state = Moving
