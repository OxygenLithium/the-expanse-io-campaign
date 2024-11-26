extends CharacterBody2D

var type = "missile"
var displayType = "Missile"
var allegiance

var target
var explosionFile = load("res://scenes/projectiles/common/explosion.tscn")

var targetPosition
var targetVelocity
var relativeDisplacement
var relativeVelocity
var currTargetDirection
var prevTargetDirection

var velocityDirection
var relativeVelocityDireciton

const lifespan = 1800
const accelerations = [0,9,27]

var acceleration = 4
var accelerationGrade

var desiredRotation = 0

var cutAcceleration
const cutAccelerationSpeed = 6000
const cutAccelerationDistance = 3000

var approxImpactTime = INF

#seconds
const finalManeuverTime = 3

var timer = 0

var proportionalNavTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if target:
		getTelemetry()
	prevTargetDirection = currTargetDirection
	accelerationGrade = 1
	
	if target and "incomingMissiles" in target:
		target.incomingMissiles.push_back(self)
	pass # Replace with function body.

func getTelemetry():
	targetPosition = target.position
	targetVelocity = target.velocity
	relativeDisplacement = targetPosition - position
	relativeVelocity = targetVelocity - velocity
	currTargetDirection = relativeDisplacement.angle()
	velocityDirection = velocity.angle()

func getClosingVelocity():
	#vector projection of rel. velocity onto rel. displacement
	return -relativeVelocity.dot(relativeDisplacement)/relativeDisplacement.dot(relativeDisplacement)*relativeDisplacement.length()
	
func getPerpendicularVelocityVector():
	#vector projection of rel. velocity onto rel. displacement
	return -relativeVelocity+relativeVelocity.dot(relativeDisplacement)/relativeDisplacement.dot(relativeDisplacement)*relativeDisplacement
	
func getClosingAcceleration():
	#vector projection of rel. velocity onto rel. displacement
	if not "acceleration" in target:
		return 0
	return -Vector2(target.acceleration,0).rotated(target.rotation).dot(relativeDisplacement)/relativeDisplacement.dot(relativeDisplacement)*relativeDisplacement.length()

func approximateImpactTime(closingVelocity):
	return (-(closingVelocity*60) + sqrt((closingVelocity*60)**2 + 4*(acceleration+getClosingAcceleration())*relativeDisplacement.length()))/2*acceleration

func nonzeroAcceleration():
	if acceleration == 0:
		return 9
	return acceleration

func proportionalNavigation():
	if relativeVelocity.dot(relativeDisplacement) < 0:
		#multiplied by 60 to convert to degrees/sec, since Godot physics ticks are 60/sec
		var LOSRate = (currTargetDirection-prevTargetDirection)
		var closingVelocity = getClosingVelocity()
		approxImpactTime = approximateImpactTime(closingVelocity)
		var desiredAccel
		desiredAccel = 4*LOSRate*closingVelocity
		if (desiredAccel > acceleration):
			desiredRotation = relativeVelocity.angle() + PI + PI/2
		elif (desiredAccel < -acceleration):
			desiredRotation = relativeVelocity.angle() + PI - PI/2
		else:
			desiredRotation = relativeVelocity.angle() + PI + asin(desiredAccel/acceleration)
			if closingVelocity > cutAccelerationSpeed:
				cutAcceleration = true
				velocity += Vector2(0,desiredAccel).rotated(relativeVelocity.angle())
	else:
		if velocity.length() < acceleration:
			velocity = Vector2(0,0)
			desiredRotation = relativeDisplacement.angle()
		else:
			desiredRotation = relativeVelocity.angle()


func hit_by_railgun():
	var explosion = explosionFile.instantiate()
	explosion.position = global_position
	explosion.velocity = velocity
	get_parent().add_child(explosion)
	
	if is_instance_valid(target) && "incomingMissiles" in target:
		target.incomingMissiles.erase(self)
	queue_free()

func hit_by_bullet():
	var explosion = explosionFile.instantiate()
	explosion.position = global_position
	explosion.velocity = velocity
	get_parent().add_child(explosion)
	
	if is_instance_valid(target) && "incomingMissiles" in target:
		target.incomingMissiles.erase(self)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#fetches and calculates parameters about the target
	cutAcceleration = false
	
	if !is_instance_valid(target):
		target = null
	
	if !target:
		velocity += Vector2(acceleration,0).rotated(rotation)
		move_and_slide()
		return
		
	getTelemetry()
	
	if timer >= 30:
		if approxImpactTime < finalManeuverTime:
			accelerationGrade = 2
			proportionalNavigation()
			proportionalNavTimer = 0
		if proportionalNavTimer > 5:
			proportionalNavigation()
			#var shouldBrake = getClosingVelocity() > cutAccelerationSpeed
			#print(shouldBrake)
			#if shouldBrake:
				#velocity -= Vector2(acceleration*5,0).rotated(relativeDisplacement.angle())
			#var desiredAccel = proportionalNavigation(shouldBrake)
			#
			#if desiredAccel < 9:
				#cutAcceleration = true
				#desiredRotation = relativeVelocity.angle()
				#velocity += Vector2(0,desiredAccel).rotated(relativeVelocity.angle())
			
			proportionalNavTimer = 0
		
	if timer == 30:
		accelerationGrade = 2
	if timer == 120:
		accelerationGrade = 1
	elif timer == lifespan:
		if "incomingMissiles" in target:
			target.incomingMissiles.erase(self)
		queue_free()
		return
	
	rotation = fmod(rotation, 2*PI)
	desiredRotation = fmod(desiredRotation, 2*PI)
	
	var diffRotation = fmod(desiredRotation - rotation, 2*PI)
	
	if diffRotation < -PI:
		diffRotation += 2*PI
	elif diffRotation > PI:
		diffRotation -= 2*PI
	if timer > 30:
		if timer < 60:
			if diffRotation >= 0:
				rotation += min(diffRotation, PI/60)
			else:
				rotation += max(diffRotation, -PI/60)
		else:
			if diffRotation >= 0:
				rotation += min(diffRotation, PI/90)
			else:
				rotation += max(diffRotation, -PI/90)
	
	if abs(diffRotation) > PI/18:
		cutAcceleration = true
	
		
	acceleration = accelerations[accelerationGrade]
	if !cutAcceleration:
		velocity += Vector2(acceleration,0).rotated(rotation)
	
	timer += 1
	
	proportionalNavTimer += 1
	
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
			
		if "incomingMissiles" in target:
			target.incomingMissiles.erase(self)
		queue_free()
		break
	
	prevTargetDirection = currTargetDirection

	move_and_slide()