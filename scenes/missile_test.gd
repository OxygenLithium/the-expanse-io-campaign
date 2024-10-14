extends CharacterBody2D

var type = "missile"
var allegiance

var target
var explosionFile = load("res://scenes/weapon/explosion.tscn")

var targetPosition
var targetVelocity
var relativeDisplacement
var relativeVelocity
var currTargetDirection
var prevTargetDirection

var velocityDirection
var relativeVelocityDireciton

const lifespan = 1800
const accelerations = [0,4,8]

var acceleration
var accelerationGrade

var cutAcceleration
const cutAccelerationSpeed = 500
const cutAccelerationDistance = 3000

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currTargetDirection = 0
	prevTargetDirection = 0
	accelerationGrade = 1
	pass # Replace with function body.

func getTelemetry():
	targetPosition = target.position
	targetVelocity = target.velocity
	relativeDisplacement = targetPosition - position
	relativeVelocity = targetVelocity - velocity
	currTargetDirection = relativeDisplacement.angle()
	velocityDirection = velocity.angle()
	

func getVelocityDirection():
	var fixedVX = velocity.x
	if fixedVX == 0:
		fixedVX = 0.01
	var angle = atan(velocity.y/fixedVX)
	if (sign(velocity.x) == -1):
		angle += PI
	return angle

func getClosingVelocity():
	#vector projection of rel. velocity onto rel. displacement
	var closingVelocityVector = relativeVelocity.dot(relativeDisplacement)/relativeDisplacement.dot(relativeDisplacement)*relativeDisplacement
	return sqrt(closingVelocityVector.dot(closingVelocityVector))

func validCutAcceleration():
	return (relativeVelocity.length() < cutAccelerationSpeed && relativeDisplacement.length() < cutAccelerationDistance)

func proportionalNavigation():
	if relativeVelocity.dot(relativeDisplacement) < 0:
		#multiplied by 60 to convert to degrees/sec, since Godot physics ticks are 60/sec
		var LOSRate = (currTargetDirection-prevTargetDirection)
		var closingVelocity = getClosingVelocity()
		var desiredAccel
		desiredAccel = 4*LOSRate*closingVelocity
		if (desiredAccel > acceleration):
			rotation = relativeVelocity.angle() + PI + PI/2
		elif (desiredAccel < -acceleration):
			rotation = relativeVelocity.angle() + PI - PI/2
		else:
			rotation = relativeVelocity.angle() + PI + asin(desiredAccel/acceleration)
		if (desiredAccel < accelerations[accelerationGrade]/4 && validCutAcceleration()):
			cutAcceleration = true
			
	else:
		if velocity.length() < acceleration:
			velocity = Vector2(0,0)
			rotation = relativeDisplacement.angle()
		else:
			rotation = relativeVelocity.angle()

func hit_by_bullet():
	var explosion = explosionFile.instantiate()
	explosion.position = global_position
	explosion.velocity = velocity
	get_parent().add_child(explosion)	
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#fetches and calculates parameters about the target
	cutAcceleration = false
	
	if !target:
		velocity += Vector2(acceleration,0).rotated(rotation)
		move_and_slide()
		return
		
	getTelemetry()
	
	if timer >= 30:
		proportionalNavigation()
		
	if timer == 30:
		accelerationGrade = 2
	elif timer == lifespan:
		queue_free()
		return
		
	acceleration = accelerations[accelerationGrade]
	if (!cutAcceleration):
		velocity += Vector2(acceleration,0).rotated(rotation)
	
	timer += 1
	
	
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
