extends VBoxContainer

class_name QuickActionListUi
var contents:Dictionary = Dictionary()
var index:int
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_child_count() <= 0:
		index = 0
	else:
		if Input.is_action_just_pressed("ui_down"):
			index = (index+1)%get_child_count()
			reorder()
		
		if Input.is_action_just_pressed("ui_up"):
			index = (index-1)%get_child_count()
			reorder()
			
		if Input.is_action_just_pressed("action"):
			for key in contents.keys():
				if contents[key]["hbox"] == get_child(index):
					contents[key]["target"].call("do_execute")
			reorder()
			
func reorder():
	var c = 0
	for child in get_children():
		if child is HBoxContainer and ! child.is_queued_for_deletion():
			if c == index:
				child.get_child(0).visible = true
			else:
				child.get_child(0).visible = false
			c += 1
			
	
func add_action(id,label,target):
	#print_debug("add action:"+String(id))
	if ! id in contents.keys():
		var hbox:HBoxContainer = HBoxContainer.new()
		var do_label = TextureRect.new()
		do_label.texture = ResourceLoader.load("res://addons/g4climbnglide/alpha-e-box.svg")
		hbox.add_child(do_label)
		var action_label:Label = Label.new()
		action_label.text = label
		hbox.add_child(action_label)
		var row = Dictionary()
		row["hbox"] = hbox
		row["target"] = target
		contents[id] = row
		add_child(hbox)
		reorder()
	pass
	
func remove_action(id):
	if id in contents.keys():
		contents[id]["hbox"].queue_free()
		contents.erase(id)
	index = 0
	call_deferred("reorder")


