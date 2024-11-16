extends Sprite2D
class_name Animation_engine

var tween_base: Tween

func _ready() -> void:
	tween_base = get_tree().create_tween()

func set_animation(image_file: String, h_frames: int, v_frames: int, animation_length:float):
	visible = false
	texture = load(image_file)
	hframes = h_frames
	vframes = v_frames
	tween_base.tween_property(self, "frame", (h_frames*v_frames)-1, animation_length)
	
func add_behavior(property: String, final_value, animation_length:float):
	tween_base.chain().tween_property(self, property, final_value, animation_length)

func run():
	visible = true
	tween_base.play()
	await tween_base.finished
	print("animation done!")
	queue_free()
