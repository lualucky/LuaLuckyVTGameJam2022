extends Node

var current = null
var drag_offset = Vector2()

var candidates = []

export var drag_group = "draggable"
export var deselect_group = "bg"

export var snap = 20

var draggables = []

var selected_obj

var selected_width = 50

export(ShaderMaterial) var outline_shader

signal object_selected
signal object_deselected


func _ready():
	var bglist = get_tree().get_nodes_in_group(deselect_group)
	for bg in bglist:
		if bg is CollisionObject2D:
			bg.connect("mouse_entered",self,"mouse_entered",[bg])
			bg.connect("mouse_exited",self,"mouse_exited",[bg])
			bg.connect("input_event",self,"input_event",[bg])
			
	update_candidates()
	
	get_tree().root.get_child(0).get_node("Trash Button").connect("enable_button", self, "object_selected")

func update_candidates():
	var cands = get_tree().get_nodes_in_group(drag_group)
	for dragable in cands:
		if dragable is CollisionObject2D && !(dragable in draggables):
			draggables.append(dragable)
			dragable.connect("mouse_entered",self,"mouse_entered",[dragable])
			dragable.connect("mouse_exited",self,"mouse_exited",[dragable])
			dragable.connect("input_event",self,"input_event",[dragable])

func _process(_delta):
	if current is Node2D:
		current.global_position = current.get_global_mouse_position() - drag_offset

func mouse_entered(which):
	candidates.append(which)
	pass

func mouse_exited(which):
	candidates.erase(which)
	pass

func input_event(_viewport: Node, event: InputEvent, _shape_idx: int,_which:Node2D):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			candidates.sort_custom(self,"depth_sort")
			var last = candidates.back()
			if last:
				last.raise()
				if(current != last || last.is_in_group(deselect_group)):
					deselect_object()
					if last.is_in_group(deselect_group):
						return
				current = last
				selected_obj = last
				select_object()
				drag_offset = current.get_global_mouse_position() - current.global_position
				if current.has_method("on_drag_start"):
					current.on_drag_start()
			else:
				deselect_object()
		else:
			var can_drop = true
			if current:
				if current.has_method("on_drop"):
					var on_drop_result = current.on_drop()
					can_drop = on_drop_result == null || on_drop_result
				if can_drop:
					if abs(current.position.x) <= snap && abs(current.position.y) <= snap:
						current.position.x = 0
						current.position.y = 0
					current = null

func select_object():
	if selected_obj:
		var color = selected_obj.get_node("Outline")
		color.material = outline_shader;
	emit_signal("object_selected")
	
func deselect_object():
	if selected_obj:
		var color = selected_obj.get_node("Outline")
		if color:
			color.material = null;
	selected_obj = null;
	emit_signal("object_deselected")

func depth_sort(a,b):
	return b.get_index()<a.get_index()

func color_changed(color):
	if selected_obj:
		var obj = selected_obj.get_node("Color")
		if obj:
			obj.self_modulate = color
			
func trash_selected():
	selected_obj.queue_free()
	selected_obj = null
	emit_signal("object_deselected")
