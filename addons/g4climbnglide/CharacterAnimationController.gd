extends AnimationTree

var last_state:CharacterController.state
var destinationStates:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	destinationStates["parameters/Air/blend_amount"]= 0.0
	destinationStates["parameters/Climb/blend_amount"]= 0.0
	destinationStates["parameters/Glide/blend_amount"]= 0.0
	destinationStates["parameters/Speed/scale"]= 1.0
	destinationStates["parameters/Run/blend_amount"]= 0.0
	destinationStates["parameters/Dash/blend_amount"]= 0.0
	destinationStates["parameters/JumpStart/active"]= 0.0
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for stringname in destinationStates.keys():
		if get(stringname) is bool:
			set(stringname,destinationStates[stringname])
			continue
		var diff = destinationStates[stringname] - get(stringname) #destination 1, current 0.4, diff 0.6
		var dir = 1
		if diff > 0:
			dir = 1
		else:
			dir = -1
			
		if diff != 0:
			var result = clampf(get(stringname)+(delta*dir/0.1),0,1)
			set(stringname,result)

	
func state_changed(new_state:CharacterController.state):
	destinationStates["parameters/Air/blend_amount"]= 0.0
	destinationStates["parameters/Climb/blend_amount"]= 0.0
	destinationStates["parameters/Glide/blend_amount"]= 0.0
	destinationStates["parameters/Speed/scale"]= 1.0
	destinationStates["parameters/Run/blend_amount"]= 0.0
	destinationStates["parameters/Dash/blend_amount"]= 0.0
	destinationStates["parameters/JumpStart/active"]= 0.0
	if new_state == CharacterController.state.CLIMB:
		destinationStates["parameters/Climb/blend_amount"]= 1.0
	if new_state == CharacterController.state.GLIDE:
		destinationStates["parameters/Glide/blend_amount"]= 1.0
		destinationStates["parameters/Air/blend_amount"]= 1.0
	if new_state == CharacterController.state.FALL:
		destinationStates["parameters/Air/blend_amount"]= 1.0
	if new_state == CharacterController.state.JUMP:
		destinationStates["parameters/Air/blend_amount"]= 1.0
		destinationStates["parameters/JumpStart/active"]= 1.0
	if new_state == CharacterController.state.RUN:
		destinationStates["parameters/Run/blend_amount"]= 1.0
	if new_state == CharacterController.state.DASH:
		destinationStates["parameters/Dash/blend_amount"]= 1.0
	if new_state == CharacterController.state.HANG:
		destinationStates["parameters/Climb/blend_amount"]= 1.0
		destinationStates["parameters/Speed/scale"]= 0.0
	last_state = new_state
