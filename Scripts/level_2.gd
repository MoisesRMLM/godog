extends Node2D


@export var win_interface : CanvasLayer
@export var all_bones : Node2D 
@export_file("menu.tscn") var next_level

func _process(_delta):
	if all_bones.get_child_count() == 0:
		change_level()

func change_level():
	set_process(false) 
	win_interface.show()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file(next_level)
