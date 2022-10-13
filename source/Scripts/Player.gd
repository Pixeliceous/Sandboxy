extends KinematicBody

#-----------------------------------------------------------
# Set variables
var speed = 40
var gravity = 9.8
var jump = 4
var cameraAcceleration = 50
var sense = .1
var snap

var direction  = Vector3()
var vel = Vector3()
var gravityVector = Vector3()
var movement = Vector3()

#-----------------------------------------------------------
# Set object variables
#-----------------------------------------------------------
onready var head = $Head
onready var camera = $Head/Camera

#-----------------------------------------------------------
# Keep the mouse within the viewport
#-----------------------------------------------------------
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


#-----------------------------------------------------------
# Look around with the mouse in 1st person view
#-----------------------------------------------------------
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * sense))
		head.rotate_x(deg2rad(-event.relative.y * sense))
		
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))


#-----------------------------------------------------------
# Walk and jump around with set inputs
#-----------------------------------------------------------
func _physics_process(delta: float) -> void:
	direction = Vector3.ZERO
	var horizontalRot = global_transform.basis.get_euler().y
	var forwardInput = Input.get_action_strength("moveBack") - Input.get_action_strength("moveForward")
	var horizontalInput = Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")
	direction = Vector3(horizontalInput, 0, forwardInput).rotated(Vector3.UP,horizontalRot).normalized()
	
	if is_on_floor():
		snap = -get_floor_normal()
		gravityVector = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		gravityVector += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravityVector = Vector3.UP * jump
		
	vel = vel.linear_interpolate(direction * speed, delta * 6)
	movement = vel + gravityVector
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	
