extends StaticBody2D
class_name ContainerRoot

signal Event(character, event_type: String, data: Dictionary)
	
@export var items_contained: Array[ItemSelect] 

enum STATE {CLOSED = 0, OPEN}

var global_name: String
var current_state: STATE = STATE.CLOSED
var display_msg: String = 'You recieved:\n%s'
var display_dialogue: Dictionary = {'_start':{'speaker':'', 'dialogue':""}} 
var PORTRAIT : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path: String = owner.scene_file_path  
	var uid: int = ResourceLoader.get_resource_uid(path)
	var uid_string := ResourceUID.id_to_text(uid).replace("uid://", "")
	print("Chest {%s} is owned by %s" % [name, uid_string])
	global_name = "%s:%s" % [uid_string, name]
	current_state = GameFlags.get_flag(global_name)


func interact():
	if GameFlags.compare_flag(global_name, 'eq', STATE.CLOSED):
		var msg: String = ""
		for item: ItemSelect in items_contained:
			PlayerTeam.inventory.add_item(item.consumable_item, item.quantity)
			msg += "%3dx %s\n" % [item.quantity, ConsumableGen.enum_to_string(item.consumable_item)]
		display_dialogue["_start"]["dialogue"] = display_msg % msg
		print(display_dialogue)
		Event.emit(self, "start_dialogue", {"conversation": Conversation.new(display_dialogue)})
		GameFlags.set_flag(global_name, STATE.OPEN)
		current_state = STATE.OPEN
		print(PlayerTeam.inventory.consumables)
