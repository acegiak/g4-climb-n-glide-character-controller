extends Area3D

@export var action_label:String

signal add_action(int,String,Node)
signal remove_action
signal execute

var action_list:QuickActionListUi
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",enter)
	connect("body_exited",exit)
	connect("tree_exiting",destruct)
	call_deferred("hook_up_UI")
	
func hook_up_UI():
	action_list = QuickActionList.GetUI().find_child("ActionList",true,false)
	connect("add_action",action_list.add_action)
	connect("remove_action",action_list.remove_action)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func enter(body):
	emit_signal("add_action",get_instance_id(),action_label,self)

func exit(body):
	emit_signal("remove_action",get_instance_id())

func do_execute():
	emit_signal("execute")

func destruct():
	emit_signal("remove_action",get_instance_id())
