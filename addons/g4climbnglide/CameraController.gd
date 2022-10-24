extends Node3D

@export var follow_object:NodePath
@export var follow_speed:float
var follow:Node3D
@export var invertX:bool = false
@export var invertY:bool = false


var mousev:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	follow = get_node(follow_object)
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		mousev = Input.get_last_mouse_velocity()*0.00001
	if event is InputEventJoypadMotion:
		mousev = Input.get_vector("camera_left","camera_right","camera_up","camera_down")*0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	rotate_y(mousev.x if invertX else mousev.x*-1)
	rotate_object_local(Vector3.LEFT,(mousev.y if invertY else mousev.y*-1))
	rotation.x = clamp(rotation.x, -15, 15)
	if follow != null:
		var goto = follow.position+Vector3(0,1,0)
		position = position + ((goto-position)*delta*follow_speed)
	mousev = Vector2.ZERO
	
	pass
