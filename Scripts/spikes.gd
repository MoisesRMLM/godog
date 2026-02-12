extends Area2D

#If the dog touches the spikes, it will take damage



func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
			body.take_damage()
