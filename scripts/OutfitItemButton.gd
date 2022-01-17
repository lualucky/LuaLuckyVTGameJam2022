extends Node

var path = "res://OutfitItems/"
export(String) var asset_name
export(Resource) var itemInfo
export(Vector2) var snapPoint
export(Color) var defaultColor = Color(.95, 0.5, 0.05, 1.0)

signal object_spawned

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_TextureButton_pressed():
	var scene_root = get_tree().root.get_child(0)
	var select_controller = scene_root.get_node("SelectedObjectController")
	
	var loaded_item = load(path + asset_name + ".tscn")
	if loaded_item:
		var instance = loaded_item.instance();
		instance.global_position = snapPoint
		if instance.get_child(0).has_node("Color"):
			var color_item = instance.get_child(0).get_node("Color")
			color_item.self_modulate = defaultColor
			
		scene_root.get_node("OutfitItems").add_child(instance)
		
		select_controller.deselect_object()
		
		select_controller.update_candidates()
		select_controller.get_node("SpawnAudio").play()
		
		emit_signal("object_spawned", false)
		
