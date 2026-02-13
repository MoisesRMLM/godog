extends Button

@export var level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_play)

func _play():
	get_tree().change_scene_to_packed(level)
