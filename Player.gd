extends KinematicBody2D

enum{
	Moving,
	Attacking,
	Idle,
	Dead
}


const ACCEL = 600
const MAXSPEED = 400

var state = Moving

var Motion = Vector2.ZERO
var Direction = 1
var Health = 1

onready var hitbox = $Hitbox/CollisionShape2D

var Xinput
var Yinput

func _process(delta):
	print(Health)
	match state:
		Moving:
			Move(delta)
		Attacking:
			Attack(delta)
		Idle:
			Idling(delta)
		Dead:
			pass

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
	
	if Xinput == 1:
		hitbox.position.x = 32
	elif Xinput == -1:
		hitbox.position.x = -112
	
	if Xinput == 0:
		if Yinput == 0:
			state = Idle
	
	if Input.is_action_just_pressed("Input_attack"):
		state = Attacking
	
	move_and_slide(Motion)

func Idling(_delta):
	$AnimationPlayer.play("Idle")
	hitbox.disabled = true
	
	Motion.x = lerp(Motion.x, 0, 0.22)
	Motion.y = lerp(Motion.y, 0, .27)
	
	if Input.is_action_pressed("Input_right") || Input.is_action_just_pressed("Input_left") || Input.is_action_just_pressed("Input_up") || Input.is_action_just_pressed("Input_down"):
		state = Moving
	if Input.is_action_pressed("Input_attack"):
		state = Attacking
	move_and_slide(Motion)

func Attack(_delta):
	$AnimationPlayer.play("Attack")
	Motion.x = lerp(Motion.x, 0, .1)
	Motion.y = lerp(Motion.y, 0, .25)
	
	
	move_and_slide(Motion)


func _on_AnimationPlayer_animation_finished(Attack):
	if state == Attacking:
		state = Moving

func _on_Area2D_body_entered(body):
	Health -= 1
