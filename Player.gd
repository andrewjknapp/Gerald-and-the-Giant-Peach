extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 15
const MAXFALLSPEED = 200
const MAXSPEED = 160
const JUMPFORCE = 200
const DJUMPFORCE = 160
const ACCEL = 10

var motion = Vector2()
var djumpactive = true

var facing_right = true

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	motion.y += GRAVITY
	
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
		
	if facing_right:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1
		
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	
	## Animation
	if is_on_floor():
		if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
			$AnimationPlayer.play("Move")
		elif Input.is_action_pressed("down"):
			$AnimationPlayer.play("Crouch")
			
		else:
			$AnimationPlayer.play("Idle")
	else:
		if motion.y < 0:
			$AnimationPlayer.play("Jump")
	
	
	## Motion
	
	if Input.is_action_pressed("right"):
		motion.x += ACCEL
		facing_right = true

	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
		facing_right = false

	elif Input.is_action_pressed("down"):
		motion.x = lerp(motion.x, 0, 0.05)

	else:
		if is_on_floor():
			motion.x = lerp(motion.x, 0, 0.3)
		else:
			motion.x = lerp(motion.x, 0, 0.05)
		
	if is_on_floor():
		if !djumpactive:
			djumpactive = true
		
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE

	else:
		if Input.is_action_just_pressed("jump") and djumpactive:
			motion.y = -DJUMPFORCE
			djumpactive = false
			
	
	
	motion = move_and_slide(motion, UP)

