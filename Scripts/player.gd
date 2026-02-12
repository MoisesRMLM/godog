extends CharacterBody2D

@export var animation: AnimatedSprite2D
@export var checkpoint_scene: PackedScene

@onready var checkpoint_label = get_node("/root/Mundo/CanvasLayer/CheckpointLabel")

var _walk_speed: float = 150.0
var _run_speed: float = 200.0
var _jump_speed: float = -400.0

var bone_speed: float = 1
var spawn_point = Vector2.ZERO 
var doing_pop = false
var hp = 100
var immune = false

func _ready():
	do_pop()

var pop_count = 0
var max_pops = 3


func _physics_process(delta: float) -> void:

	#pop-animation stop
	if doing_pop:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	#dog gravity
	velocity += get_gravity() * delta

	#dog jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _jump_speed

	#dog movement
	var _current_speed = _walk_speed * bone_speed

	if Input.is_action_pressed("run"):
		_current_speed = _run_speed * bone_speed

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
	if doing_pop:
		velocity.x=0
		move_and_slide()
		return
	
	if !is_on_floor():
		animation.play("jump")
	elif velocity.x != 0:
		if Input.is_action_pressed("run"):
			animation.play("run")
		else:
			animation.play("walk")
	else:
		animation.play("idle")
	if Input.is_action_just_pressed("pop") and !doing_pop and is_on_floor() and pop_count < max_pops:
		do_pop()	
		
	#map limit 
	if global_position.y >=1000:
		spawn_player(spawn_point)
	
	
#initial checkpoint	
func spawn_player(spawn_point):
	hp = 100
	%AnimatedSprite2D.modulate.a = 0.5
	%ImmuneTimer.start()
	
	if spawn_point == Vector2.ZERO:
		get_tree().reload_current_scene()	
		return	
	global_position = spawn_point	

#checkpoint
func set_checkpoint(position):
	spawn_point = position		

func make_checkpoint():
	var c = checkpoint_scene.instantiate()
	get_parent().add_child(c)
	c.global_position = global_position
	c.get_node("AnimatedSprite2D").play("idle")
	set_checkpoint(global_position)

func do_pop():
	doing_pop = true
	pop_count += 1
	animation.play("pop")
	await animation.animation_finished
	make_checkpoint()
	doing_pop = false

#Whenever godog collects a bone, its speed increases
func collect_bone():
	bone_speed += 0.3 #Change the value if the increase in speed seems too high

func take_damage():
	if !immune:
		hp -= 25
		if hp > 0:
			immune = true
			
			%AnimatedSprite2D.modulate.a = 0.5
			%ImmuneTimer.start()
		else:
			spawn_player(spawn_point)

func _on_immune_timer_timeout() -> void:
	%AnimatedSprite2D.modulate.a = 1
	immune = false
