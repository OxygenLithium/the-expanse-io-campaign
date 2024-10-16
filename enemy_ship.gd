extends CharacterBody2D

const type = "ship"
const allegiance = "UNN"

var rng = RandomNumberGenerator.new()

@onready var player = get_node("/root/Node/player")
@onready var target = player

var missileFile = load("res://scenes/weapon/missile.tscn")
var missileMarkerFile = load("res://radar_map/unn_missile_marker.tscn")

var shoot_timer = 0
var acceleration = 1

#AI Distance Control
const minDistance = 1500
const maxDistance = 10000

#AI Navigation
var desiredRotation = 0

# Telemetry
var targetPosition
var targetVelocity
var relativeDisplacement
var relativeVelocity
var currTargetDirection
var prevTargetDirection

func getTelemetry():
	targetPosition = target.position
	targetVelocity = target.velocity
	relativeDisplacement = targetPosition - position
	relativeVelocity = targetVelocity - velocity
	currTargetDirection = relativeDisplacement.angle()

func shoot_missile():
	var missile = missileFile.instantiate()
	missile.allegiance = "UNN"
	missile.target = $/root/Node/player
	missile.set_collision_layer_value(10, true)
	missile.set_collision_mask_value(1, true)
	missile.set_collision_mask_value(2, true)
	missile.global_position = global_position
	get_parent().add_child(missile)
	missile.rotation = rotation
	missile.velocity = Vector2(300,0).rotated(rotation)
	
	var missile_marker = missileMarkerFile.instantiate()
	missile_marker.markerTarget = missile
	$/root/Node/map_canvas/radar_map.add_child(missile_marker)

func take_damage_missile():
	pass

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

func proportionalNavigation():
	if relativeVelocity.dot(relativeDisplacement) < 0:
		#multiplied by 60 to convert to degrees/sec, since Godot physics ticks are 60/sec
		var LOSRate = (currTargetDirection-prevTargetDirection)
		var closingVelocity = getClosingVelocity()
		var desiredAccel
		desiredAccel = 4*LOSRate*closingVelocity
		if (desiredAccel > acceleration):
			desiredRotation = relativeVelocity.angle() + PI + PI/2
		elif (desiredAccel < -acceleration):
			desiredRotation = relativeVelocity.angle() + PI - PI/2
		else:
			desiredRotation = relativeVelocity.angle() + PI + asin(desiredAccel/acceleration)
			
	else:
		if velocity.length() < acceleration:
			velocity = Vector2(0,0)
			desiredRotation = relativeDisplacement.angle()
		else:
			desiredRotation = relativeVelocity.angle()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !player:
		move_and_slide()
		return
	
	if shoot_timer == 300:
		shoot_missile()
	if shoot_timer == 330:
		shoot_missile()
	if shoot_timer == 360:
		shoot_missile()
	if shoot_timer == 390:
		shoot_missile()
	if shoot_timer == 420:
		shoot_missile()
	if shoot_timer > 450:
		shoot_missile()
		shoot_timer = 0
	
	shoot_timer += 1
	
	getTelemetry()
	
	if relativeDisplacement.length() > maxDistance:
		proportionalNavigation()
	elif relativeDisplacement.length() < minDistance:
		desiredRotation = relativeDisplacement.angle() + PI
	elif relativeVelocity != Vector2(0,0):
		desiredRotation = relativeVelocity.angle()

	rotation = fmod(rotation, 2*PI)
	desiredRotation = fmod(desiredRotation, 2*PI)
	
	var diffRotation = fmod(desiredRotation - rotation, 2*PI)
	if diffRotation < -PI:
		diffRotation += 2*PI
	elif diffRotation > PI:
		diffRotation -= 2*PI
	if diffRotation >= 0:
		rotation += min(diffRotation, 0.5)
	else:
		rotation += max(diffRotation, -0.5)
	
	
	rotation = desiredRotation

	velocity += Vector2(min(acceleration,relativeVelocity.length()),0).rotated(rotation)

	move_and_slide()
