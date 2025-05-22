extends CharacterBody2D
class_name NpcRoot

signal Event(event_type: String, data: Dictionary)

var PORTRAIT: String = "res://resource/Sprites/red.png"

func interact():
	print("Hello world")
	Event.emit("start_dialogue", {"conversation": Conversation.new("res://stats/conversations/hello_world.json")})