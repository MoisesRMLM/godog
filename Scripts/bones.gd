extends Area2D

var _bone_color: int = 0

#The bones _bone_color changes depending on the level you are in
func _process(delta):
	match _bone_color:
		0:
			%AnimatedSprite2D.play("blue")
		1:
			%AnimatedSprite2D.play("green")
		2:
			%AnimatedSprite2D.play("red")

#When a bone is touched by the dog it calls for the collect_bone() method in the dog, then deletes itself
func _on_body_entered(body):
	if body.has_method("collect_bone"):
		body.collect_bone()
		
		queue_free()
