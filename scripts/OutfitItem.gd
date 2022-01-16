extends Resource

export(Vector2) var snapPos
export(Array, Resource) var sprites
export(Vector3) var hue


func _init(p_snapPos = Vector2(), p_sprites = null, p_hue = Vector3()):
	snapPos = p_snapPos
	sprites = p_sprites
	hue = p_hue
