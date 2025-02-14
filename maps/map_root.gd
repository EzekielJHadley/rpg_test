extends Level_root


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var doors: Array[Node] = get_tree().get_nodes_in_group("doors")
	for doorway in doors:
		print(doorway)
		doorway.change_scene.connect(change_scene)

func set_up(data: Dictionary):
	if data.has("door"):
		$PCs/player1.position = get_node("door/" + data["door"]).position
