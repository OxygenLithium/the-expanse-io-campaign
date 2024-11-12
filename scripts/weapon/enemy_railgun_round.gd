extends CharacterBody2D

var type = "bullet"
var allegiance

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for j in range(16):
				#print(j+1)
				#print(get_collision_mask_value(j+1))
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
			collider.hit_by_railgun()
		elif (collider.type == "ship"):
			collider.take_damage_railgun(20)
		
		queue_free()
		break
	
	move_and_slide()
