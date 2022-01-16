extends Node

var path = "res://OutfitItems/"
export(String) var asset_name
export(Resource) var itemInfo
export(Vector2) var snapPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	print(path + asset_name + ".tscn")
	var loaded_item = load("res://OutfitItems/MaidDress.tscn")
	if loaded_item:
		var instance = loaded_item.instance();
		instance.global_position = snapPoint
		var scene_root = get_tree().root.get_child(0)
		scene_root.add_child(instance)
		scene_root.get_node("DragDropController").update_candidates()
	else:
		print("Failed to spawn")
		
