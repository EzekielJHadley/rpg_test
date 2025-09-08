extends CharacterBody2D


const SPEED = 200.0

signal follow(target: Vector2)

var accel: float = 1.0:
	set(val):
		accel = clamp(val, 0.5, 1.1)
var face: String = "down"

@export var follower: bool = false
var keep_away = 40




func _physics_process(_delta: float) -> void:
	if not follower:
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * SPEED
#		if Input.is_action_pressed("move_left"):
#			face = "left"
#			velocity.x = -1 * SPEED
#		elif Input.is_action_pressed("move_right"):
#			face = "right"
#			velocity.x = 1 * SPEED
#		elif Input.is_action_pressed("move_up"):
#			face = "up"
#			velocity.y = -1 * SPEED
#		elif Input.is_action_pressed("move_down"):
#			face = "down"
#			velocity.y = 1 * SPEED

		follow.emit(global_position)
	
	move_and_slide()
	if velocity != Vector2.ZERO:
		velocity = Vector2.ZERO
		accel -= 0.1
	
	
func follow_leader(leader_pos: Vector2):
	var new_dir: Vector2 = leader_pos - global_position 
	if new_dir.length() > keep_away:
		velocity = new_dir.normalized() * SPEED * accel
		accel += 0.1
		
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not follower:
		for obj in $interact.get_overlapping_bodies():
			if obj.has_method("interact"):
				obj.interact()
