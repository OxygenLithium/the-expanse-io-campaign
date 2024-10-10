extends CharacterBody2D

var type = "missile"
var allegiance = "UNN"

var target = "/root/Node/player"
var explosionFile = load("res://scenes/weapon/explosion.tscn")

var targetPosition
var targetVelocity
var relativeDisplacement
var relativeVelocity
var currTargetDirection
var prevTargetDirection
var hiddenRotation

var velocityDirection

var acceleration = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currTargetDirection = 0
	prevTargetDirection = 0
	hiddenRotation = 0
	pass # Replace with function body.

func getVelocityDirection():
	var fixedVX = velocity.x
	if fixedVX == 0:
		fixedVX = 0.01
	var angle = atan(velocity.y/fixedVX)
	if (sign(velocity.x) == -1):
		angle += PI
	return angle
	

func getTargetDirection():
	var fixedDX = position.x-targetPosition.x
	if fixedDX == 0:
		fixedDX = 0.01
	var angle = atan((position.y-targetPosition.y)/fixedDX)
	if (sign(position.x-targetPosition.x) == 1):
		angle += PI
	return angle

func getClosingVelocity():
	#vector projection of rel. velocity onto rel. displacement
	var closingVelocityVector = relativeVelocity.dot(relativeDisplacement)/relativeDisplacement.dot(relativeDisplacement)*relativeDisplacement
	return sqrt(closingVelocityVector.dot(closingVelocityVector))

func proportionalNavigation():
	#multiplied by 60 to convert to degrees/sec, since Godot physics ticks are 60/sec
	var LOSRate = (currTargetDirection-prevTargetDirection)
	var closingVelocity = getClosingVelocity()
	var desiredAccel = 4*LOSRate*closingVelocity
	if velocity.dot(relativeDisplacement) > 0:
		if (desiredAccel > acceleration):
			hiddenRotation = velocityDirection + PI/2
		elif (desiredAccel < -acceleration):
			hiddenRotation = velocityDirection - PI/2
		else:
			hiddenRotation = velocityDirection + asin(desiredAccel/acceleration)
	else:
		#A messes up when the velocity is close to 0. Perhaps make the chosen algorithm persist for a bit?
		print("backwards")
		if (desiredAccel > acceleration/2):
			hiddenRotation = velocityDirection + PI + PI/6
		elif (desiredAccel < -acceleration/2):
			hiddenRotation = velocityDirection + PI - PI/6
		else:
			hiddenRotation = velocityDirection + PI + asin(desiredAccel/acceleration)

func hit_by_bullet():
	var explosion = explosionFile.instantiate()
	explosion.position = global_position
	explosion.velocity = velocity
	get_parent().add_child(explosion)	
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#fetches and calculates parameters about the target
	if !get_node(target):
		velocity += Vector2(acceleration,0).rotated(hiddenRotation)
		move_and_slide()
		return
	targetPosition = get_node(target).position
	targetVelocity = get_node(target).velocity
	relativeDisplacement = targetPosition - position
	relativeVelocity = targetVelocity - velocity
	currTargetDirection = getTargetDirection()
	
	velocityDirection = getVelocityDirection()
	
	rotation = velocityDirection
	
	velocity.x += cos(hiddenRotation)*acceleration
	velocity.y += sin(hiddenRotation)*acceleration
	
	proportionalNavigation()
	
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if not "type" in collider:
			continue
		
		if (collider.type == "missile"):
			var explosion = explosionFile.instantiate()
			explosion.position = global_position
			explosion.velocity = velocity
			get_parent().add_child(explosion)
			collider.hit_by_bullet()
		
		if (collider.type == "ship"):
			var explosion = explosionFile.instantiate()
			explosion.position = global_position
			explosion.velocity = collider.velocity
			get_parent().add_child(explosion)
			
			collider.take_damage_missile()
		queue_free()
		break
	
	prevTargetDirection = currTargetDirection

	move_and_slide()
