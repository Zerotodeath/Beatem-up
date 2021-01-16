extends KinematicBody2D

enum{
	Moving
	Attacking
}

const ACCEL = 600
const MAXSPEED = 400

var state = Moving

var Motion = Vector2.ZERO
var Direction = 1

func _process(delta):
	match state:
		Moving:
			Moving(delta)
		Attacking:
			Attacking()

func Moving(delta):
	var Xinput = Input.get_action_strength("Input_right") - Input.get_action_strength("Input_left")
	var Yinput = Input.get_action_strength("Input_down") - Input.get_action_strength("Input_up")
	
	if Xinput != 0:
		Motion.x += Xinput * ACCEL * delta
		Motion.x = clamp(Motion.x, -MAXSPEED, MAXSPEED)
	else:
		Motion.x = lerp(Motion.x, 0, 0.22)
	
	if Yinput != 0:
		Motion.y = 250 * Yinput
	else:
		Motion.y = 0
	
	move_and_slide(Motion)

func Attacking():
	pass
