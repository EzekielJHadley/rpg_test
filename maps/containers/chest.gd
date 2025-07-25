@tool
extends ContainerRoot
class_name Chest

enum STYLE {PLAIN=1, WEATHERED = 4, FANCEY = 7, ROYAL = 10}

@export var type: STYLE = STYLE.PLAIN


func _ready() -> void:
	if not Engine.is_editor_hint():
		super()
		$container_base.frame = int(type) - int(current_state)
	
	
func interact():
	super()
	$container_base.frame = $container_base.frame - current_state


func _get_configuration_warnings():
	var warnings = []
	if get_parent().name != "Containers":
		warnings = ["Needs to be under the Containers node"]
	return warnings