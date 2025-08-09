extends CharacterBody2D
class_name NpcRoot

signal Event(character, event_type: String, data: Dictionary)

var PORTRAIT: String = "res://resource/Sprites/red.png"

func interact():
	print("Hello world")
	var conv = FileManager.load_json("res://stats/conversations/hello_world.json")
	Event.emit(self, "start_dialogue", {"conversation": Conversation.new(conv)})