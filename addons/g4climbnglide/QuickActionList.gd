extends Node

var QuickActionUi:CanvasLayer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func GetUI():
	if QuickActionUi == null:
		var canvas = CanvasLayer.new()
		var list = QuickActionListUi.new()
		list.name = "ActionList"
		list.anchor_left = 0.5
		list.anchor_top = 0.5
		list.anchor_right = 0.5
		list.anchor_bottom = 0.5
		list.offset_left = 50
		list.offset_top = -25
		get_tree().root.add_child(canvas)
		canvas.add_child(list)
		QuickActionUi = canvas
	return QuickActionUi

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
