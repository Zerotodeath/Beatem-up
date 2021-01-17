extends KinematicBody2D

enum{
	Moving
	Attacking
}

const ACCEL = 600
const MAXSPEED = 400

var state = Attacking

var Motion = Vector2.ZERO
var Direction = 1

signal Attacked

func _physics_process(delta):
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
	
	
	if Input.is_action_just_pressed("Input_attack"):
		emit_signal("Attacked")
		$AnimationPlayer.play("New Anim")
	else:
		$AnimationPlayer.play("Idle")
	
	move_and_slide(Motion)


