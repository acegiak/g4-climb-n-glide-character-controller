extends TextureProgressBar

@export var max_stamina:float = 100
@export var current_stamina:float = 100
@export var drain_rates:Dictionary
@export var recovery_rate:float
@export var recovery_wait_time:float
@export var hide_wait_time:float

signal lockout(Array)

var wait:float = 0
var hide_wait:float = 0
var current_state = null
var draining:float = 0
var last_stamina = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	if drain_rates.size() > 0:
		for key in drain_rates.keys():
			assert (key is String)
			assert (key in CharacterController.state.keys())
			assert (drain_rates[key] is float)
	pass # Replace with function body.

func change_state(new_state:CharacterController.state):
	current_state = new_state
	if CharacterController.state.keys()[current_state] in drain_rates.keys():
		draining = drain_rates[CharacterController.state.keys()[current_state]]
	else:
		draining = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draining>0:
		current_stamina -= draining*delta
		wait = recovery_wait_time
	else:
		if wait > 0:
			wait -= delta
		else:
			current_stamina += recovery_rate*delta
	current_stamina = clamp(current_stamina,0,max_stamina)
	
	if current_stamina >= max_stamina:
		if hide_wait <= 0:
			hide()
		else:
			hide_wait -= delta
	else:
		hide_wait = hide_wait_time
		show()
		
	
	if current_stamina <= 0 && last_stamina > 0:
		emit_signal("lockout",drain_rates.keys())
	if last_stamina <= 0 && current_stamina > 0:
		emit_signal("lockout",[])
		
	last_stamina = current_stamina
	value = int((current_stamina/max_stamina)*100)



