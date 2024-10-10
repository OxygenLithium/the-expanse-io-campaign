extends CharacterBody2D

var type = "bullet"
var allegiance = "MCRN"

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	timer += 1
	if timer > 90:
		queue_free()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if not "type" in collider:
			continue
		
		if (collider.type == "missile"):
			collider.hit_by_bullet()
		
		queue_free()
		break
	
	move_and_slide()
