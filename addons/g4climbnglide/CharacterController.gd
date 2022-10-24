extends CharacterBody3D
class_name CharacterController
@export var jump_length:float = 0.5
@export var jump_power:float = 2000;
@export var wall_jump_power:float = 2000;
@export var gravity:float = 500
@export var runspeed:float = 5
@export var climbspeed:float = 2
@export var camera_object:NodePath
@export var climb_hold_force:float = 2
@export var climb_hold_time:float = 0.25
@export var air_run_time:float = 0.25
@export var wall_jump_outness:float = 0.5
@export var dash_speed:float = 3
@export var dash_length:float = 0.25
@export var air_dash:bool = true
@export var attack_time:float = 0.9*0.5


enum state{RUN,JUMP,FALL,GLIDE,CLIMB,HANG,IDLE,DASH,ATTACK}
signal change_state(state)

var camera:Node3D
var control_direction:Vector2 = Vector2(0,0)
var fallspeed = 0
var movement:Vector3 = Vector3(0,0,0)
var jumptime:float = 0
var dashtime:float = 0
var dashdir:Vector3
var last_facing:Vector2 = Vector2(0,1)
var glidable = false
var current_state:state = state.IDLE
var previous_state:state = state.IDLE
var locked:Array = []

var last_on_wall:float = 0
var last_wall_normal:Vector3 = Vector3.FORWARD
var last_on_floor:float = 0


var climbing:bool = false


var last_attacked:float = 10
var next_attack:float = 0

#grab the camera so we can use it for relative movement
func _ready():
	camera = get_node(camera_object)
	

#Emit signals when we change player state
func _process(delta):
	if current_state != previous_state:
		emit_signal("change_state",current_state)
		previous_state = current_state
		
#	last_attacked += delta
#	if Input.is_action_just_pressed("attack"):
#		last_attacked = 0
#	if next_attack <= 0:
#
#		var weapons = find_children("*","Weapon",true,false)
#
#		if last_attacked < attack_time:
#			next_attack = attack_time
#			move("back_weapon","hand_weapon")
#			$AnimationTree.set("parameters/Attack/active",1.0)
#			if weapons.size()>0:
#				weapons[0].active = true
#			$DamageHitbox.do_damage()
#		else:
#			$AnimationTree.set("parameters/Attack/active",0.0)
#			move("hand_weapon","back_weapon")
#			if weapons.size()>0:
#				weapons[0].active = false
#	next_attack -= delta

func move(from,to):
	var fnode = find_child(from,true,false)
	var tnode = find_child(to,true,false)
	if fnode.get_child_count() > 0:
		var moved = fnode.get_child(0)
		fnode.remove_child(moved)
		tnode.add_child(moved)
		return moved

func _physics_process(delta):
	#don't do anythng till the camera is ready or we'll crash
	if camera == null:
		return
	
	#zero movement out before we start
	movement = Vector3.ZERO;
	
	
	#get directional input
	if ! state.RUN in locked:
		var vertical = Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
		var horizontal = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
		control_direction = Vector2(horizontal,vertical).normalized()
	
	#save that directional input in case we need it later
	if control_direction.length()>0.1:
		last_facing = control_direction
		
	
	#give a little bit of buffer for on_wall and on_floor
	if is_on_wall():
		last_on_wall = 0
		last_wall_normal = get_wall_normal()
	else:
		last_on_wall += delta
		
	if is_on_floor():
		last_on_floor = 0
	else:
		last_on_floor += delta

	
	#get jump/climb button input. If we're not climbing then store jump for later
	if Input.is_action_just_pressed("jump") and ! state.JUMP in locked:
		if last_on_wall<climb_hold_time and !climbing:
			climbing = true
		elif last_on_floor < air_run_time or last_on_wall<climb_hold_time:
			jumptime = jump_length
		
		
	#if we're climbing then set our state and move the player on the wall
	if climbing and last_on_wall < climb_hold_time and !state.CLIMB in locked:
		if control_direction.length() > 0:
			current_state = state.CLIMB
		else:
			current_state = state.HANG
		movement += last_wall_normal*-1*climb_hold_force
		look_at(position+last_wall_normal,Vector3.UP)
		var wallangle = (last_facing).rotated(PI*1.5).angle()
		var camera_relative = Vector3(0,climbspeed*control_direction.length(),0).rotated(last_wall_normal*-1,wallangle)
		movement += camera_relative
		
		#if we're climbing and we've stored a jump, that's a wall jump. Do it!
		if jumptime > 0:
			jumptime -= delta
			movement += jumptime*delta*wall_jump_power*((last_wall_normal*0.5)+(Vector3.UP)).normalized()
		
		#cause climbing is a weird exception space, we do the movement and
		# then return so we don't accidentally do regular movement as well
		velocity = movement
		move_and_slide()
		return
	
	
	#if we're not climbing then stand up straight and end the climb time
	rotation.x = 0
	climbing = false
	
	
	#now that we know we're not climbing, let's do horizontal movement!
	if control_direction.length()>0.1 and ! state.RUN in locked:
		rotation.y = (last_facing*Vector2(-1,1)).rotated(PI*1.5).angle()+camera.rotation.y
		var camera_relative = Vector3(0,0,runspeed*control_direction.length()).rotated(Vector3.UP,rotation.y)
		movement += camera_relative
		
	#dash input and set direction
	if Input.is_action_just_pressed("dash") and dashtime <= 0  and (last_on_floor< air_run_time || air_dash) and ! state.DASH in locked:
		dashtime = dash_length
		rotation.y = (last_facing*Vector2(-1,1)).rotated(PI*1.5).angle()+camera.rotation.y
		dashdir = Vector3(0,0,dash_speed*runspeed*control_direction.length()).rotated(Vector3.UP,rotation.y)

	#extra movement in dash direction
	if dashtime > 0:
		current_state = state.DASH
		movement += dashdir
		dashtime -= delta
	
	#process falling and gliding, as long as we're not on the floor
	if is_on_floor():
		fallspeed = 0;
		glidable = false
	else:
		if Input.is_action_pressed("jump") and ! state.GLIDE in locked and glidable:
			fallspeed = gravity*0.1
			current_state = state.GLIDE
		else:
			glidable = true
			fallspeed += gravity*delta
			current_state = state.FALL
		movement.y -= fallspeed*delta
	
	#jumping make go up
	if jumptime > 0:
		jumptime -= delta
		current_state = state.JUMP
		movement.y += jumptime*delta*jump_power
		
	#set the states for run/idle if we're not doing any of the other fancy stuff
	if is_on_floor() && dashtime <= 0:
		if control_direction.length()>0.1:
			current_state = state.RUN
		else:
			current_state = state.IDLE
	
		#do the actual movement
	velocity = movement
	move_and_slide()


#function to allow other systems to prevent certain kinds of movement
#that Array passed in needs to be string names of state enums eg "GLIDE"
#because I don't know how to specify an array of a particular enum
func lockout(new_locked:Array):
	locked.clear()
	for state_name in state.keys():
		if state_name in new_locked:
			locked.append(state[state_name])
	print_debug(locked)



