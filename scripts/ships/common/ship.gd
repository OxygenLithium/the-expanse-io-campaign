extends CharacterBody2D

@export var pdcs: Array[Node2D]

#Fields accessed by others on checks
var type = "ship"
var allegiance

#Random number generator
var rng = RandomNumberGenerator.new()

var marker = null

#Autotrack AI
var PDCAutotrack = true
var PDCTarget = null
var getPDCTargetTimer = 0

@onready var incomingMissiles = []

#Files
var bulletFile
var missileFile
var missileMarkerFile

var smallShipExplosionFile = load("res://scenes/projectiles/common/smallShipExplosion.tscn")

var bulletMarkerFile = load("res://scenes/map/bullet_marker.tscn")

#Stats
#Health stats
var health = 100

var railgunResistance = 1

#Movement stats
var ACCELERATIONS = [1,2,4,8]

var acceleration = 0
var angVelocity = 0

var timeBetweenPDC = 3
var bulletSpeed = 3000

var RCSThrust = 300
var RCSLightThrust = 30
var RCSCooldownLength = 30
var RCSLightCooldownLength = 10
var RCSCooldowns = [0,0,0,0]

#Cooldowns
var shootCooldown = 0
var missileCooldown = 0

#Weapons
var target = null

func custom_init():
	pass

func ready_functions():
	pass

func _ready():
	
	custom_init()
	ready_functions()

func getPDCTarget(enemyShips, PDCTargetingEffectiveness = 12):
	var futurePos = position + velocity + Vector2(acceleration,0).rotated(rotation)/120
	
	if incomingMissiles.size() +enemyShips.size() == 0:
		return null
	var closest = null
	var minDistance = PDCTargetingEffectiveness
	for i in range(incomingMissiles.size()):
		var relativeDisplacement = incomingMissiles[i].global_position - global_position
		var relativeVelocity = incomingMissiles[i].velocity - velocity
		if relativeDisplacement.dot(relativeVelocity)/relativeDisplacement.length()/relativeVelocity.length() < 0.5:
			if incomingMissiles[i].approxImpactTime < minDistance:
				closest = incomingMissiles[i]
				minDistance = incomingMissiles[i].approxImpactTime
	
	if closest:
		return closest
	
	minDistance *= 500
	for i in range(enemyShips.size()):
		if (enemyShips[i].position - futurePos).length() < minDistance:
			closest =enemyShips[i]
			minDistance = (enemyShips[i].position - futurePos).length()
	for i in range(incomingMissiles.size()):
		if (incomingMissiles[i].position - futurePos).length() < minDistance:
			closest = incomingMissiles[i]
			minDistance = (incomingMissiles[i].position - futurePos).length()
	return closest

func shoot_PDC():
	for i in range(pdcs.size()):
		if pdcs[i].active:
			var bullet = bulletFile.instantiate()
			bullet.allegiance = allegiance
			bullet.position = pdcs[i].marker.global_position + velocity/60
			get_parent().add_child(bullet)
			bullet.rotation = pdcs[i].pivot.rotation - pdcs[i].rotation + rotation
			bullet.rotation += rng.randf_range(-PI/60, PI/60)
			bullet.velocity = velocity
			bullet.velocity += Vector2(bulletSpeed,0).rotated(bullet.rotation)
			bullet.set_visible(true)
			
			var bullet_marker = bulletMarkerFile.instantiate()
			bullet_marker.markerTarget = bullet
			get_parent().map_canvas.radar_map.add_child(bullet_marker)

func shoot_missile(mDamage = 20):
	var missile = missileFile.instantiate()
	missile.allegiance = allegiance
	
	missile.target = target
	missile.damage = mDamage
	missile.global_position = global_position + Vector2(50,0).rotated(rotation) + velocity/60
	missile.velocity = velocity
	missile.rotation = rotation
	missile.velocity += Vector2(100,0).rotated(rotation)
	missile.velocity += Vector2(300,0).rotated(rng.randf_range(-PI/2,PI/2))
	get_parent().add_child(missile)
	
	var missile_marker = missileMarkerFile.instantiate()
	missile_marker.markerTarget = missile
	missile.marker = missile_marker
	get_parent().map_canvas.radar_map.add_child(missile_marker)

func targeted_by_railgun():
	pass

func on_take_damage():
	pass

func take_damage_missile(damage):
	health -= damage
	on_take_damage()
	
func take_damage_bullet():
	health -= 1
	on_take_damage()
	
func take_damage_railgun(damage):
	health -= damage/railgunResistance
	on_take_damage()

func death():
	pass
	
func RCSHard(direction):
	velocity += Vector2(RCSThrust,0).rotated(rotation + direction)
	
func RCSSoft(direction):
	velocity += Vector2(RCSLightThrust,0).rotated(rotation + direction)

func shipFunctions():
	pass

func _physics_process(delta: float) -> void:
	if health < 0.1:
		death()
	
	shipFunctions()
	
	# Add the gravity.
	velocity += Vector2(acceleration,0).rotated(rotation)
	rotation_degrees += angVelocity
	
	move_and_slide()
