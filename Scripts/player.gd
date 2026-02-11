extends CharacterBody2D

@export var animation: Node

var _walk_speed: float = 150.0
var _run_speed: float = 200.0
var _jump_speed: float = -400.0
var _bone_speed: float = 1

func _physics_process(delta: float) -> void:

	#dog gravity
	velocity += get_gravity() * delta

	#dog jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _jump_speed

	#dog movement
	var _current_speed = _walk_speed * _bone_speed

	if Input.is_action_pressed("run"):
		_current_speed = _run_speed * _bone_speed

	if Input.is_action_pressed("right"):
		velocity.x = _current_speed
		animation.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -_current_speed
		animation.flip_h = true
	else:
		velocity.x = 0
	move_and_slide()

	#dog animation
	if !is_on_floor():
		animation.play("jump")
	elif velocity.x != 0:
		if Input.is_action_pressed("run"):
			animation.play("run")
		else:
			animation.play("walk")
	else:
		animation.play("idle")

#Whenever godog collects a bone, its speed increases
func collect_bone():
	_bone_speed += 0.3 #Change the value if the increase in speed seems too high
