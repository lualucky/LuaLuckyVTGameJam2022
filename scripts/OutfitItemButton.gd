extends Node

var path = "res://OutfitItems/"
export(String) var asset_name
export(Resource) var itemInfo
export(Vector2) var snapPoint
export(Color) var defaultColor = Color(1.0, 0.5, 0.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_TextureButton_pressed():
	print(path + asset_name + ".tscn")
	var loaded_item = load(path + asset_name + ".tscn")
	if loaded_item:
		var instance = loaded_item.instance();
		instance.global_position = snapPoint
		instance.get_child(0).get_node("Color").self_modulate = defaultColor
		var scene_root = get_tree().root.get_child(0)
		scene_root.add_child(instance)
		scene_root.get_node("DragDropController").update_candidates()
	else:
		print("Failed to spawn")
		
