extends AnimationTree

var last_state:CharacterController.state
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func state_changed(new_state:CharacterController.state):
	set("parameters/Air/blend_amount",0.0)
	set("parameters/Climb/blend_amount",0.0)
	set("parameters/Glide/blend_amount",0.0)
	set("parameters/Speed/scale",1.0)
	set("parameters/Run/blend_amount",0.0)
	set("parameters/Dash/blend_amount",0.0)
	if new_state == CharacterController.state.CLIMB:
		set("parameters/Climb/blend_amount",1.0)
	if new_state == CharacterController.state.GLIDE:
		set("parameters/Glide/blend_amount",1.0)
		set("parameters/Air/blend_amount",1.0)
	if new_state == CharacterController.state.FALL:
		set("parameters/Air/blend_amount",1.0)
	if new_state == CharacterController.state.JUMP:
		set("parameters/Air/blend_amount",1.0)
	if new_state == CharacterController.state.RUN:
		set("parameters/Run/blend_amount",1.0)
	if new_state == CharacterController.state.DASH:
		set("parameters/Dash/blend_amount",1.0)
	if new_state == CharacterController.state.HANG:
		set("parameters/Climb/blend_amount",1.0)
		set("parameters/Speed/scale",0.0)
	last_state = new_state
