extends KinematicBody

var speed = 10
var gravity = 9.8
var jump = 7
var cameraAcceleration = 50
var sense = .1
var snap

var direction  = Vector3()
var vel = Vector3()
var gravityVector = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * sense))
		head.rotate_x(deg2rad(-event.relative.y * sense))
		
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

