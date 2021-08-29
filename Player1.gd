extends KinematicBody

var direction = Vector3()
var fall = Vector3()
var velocity = Vector3()
var wall_normal = Vector3()

#Ground
var GRAV = 10
var GRAV_on_floor = 1
var SPEED = 7
var ACCEL = 5
var Jump = 4

#Wall
var Wall_Speed = SPEED + 3

var mouse_sens = 1

onready var head = $Head

func _ready():
	pass

func _input(event):
	#Mouse Movement of character head
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp (head.rotation.x, deg2rad(-90), deg2rad(90))
		
func _wall_run():
		#Meant to push player against wall when wall running
	if Input.is_action_pressed("Jump"):
		if Input.is_action_pressed("Foward"):
			if is_on_wall():
				wall_normal = get_slide_collision(0)
				fall.y = 0
				direction = -wall_normal.normal * SPEED
		
func _physics_process(delta):
	_wall_run()
	
	#Calls gravity and resets motions based on direction
	fall.y -= GRAV * delta
	direction = Vector3()
		#Jump
	if Input.is_action_pressed("Jump") and is_on_floor():
		fall.y = Jump
		
	#Moving F&B
	if Input.is_action_pressed("Foward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("Backward"):
		direction += transform.basis.z
	#Strafe
	if Input.is_action_pressed("S_Left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("S_Right"):
		direction += transform.basis.x
	
	
	#Makes speed not exceed max SPEED var
	direction = direction.normalized()
	
	#defines velocity based on max SPEED var
	velocity = velocity.linear_interpolate(direction * SPEED, ACCEL * delta)
	velocity = move_and_slide(velocity, Vector3())
	
	#Calls on fall variable to create gravity and is_on_floor detection
	fall = move_and_slide(fall, Vector3.UP, true)
	
	if is_on_floor():
		print("Floor")
	elif is_on_wall():
		print("Wall")
	else:
		print(("False"))
