extends CharacterBody2D

#Fields accessed by others on checks
var type = "ship"
var allegiance = "MCRN"

#Random number generator
var rng = RandomNumberGenerator.new()

#Files
var bulletFile = load("res://scenes/weapon/bullet.tscn")
var missileFile = load("res://scenes/weapon/missile.tscn")
var missileMarkerFile = load("res://radar_map/mcrn_missile_marker.tscn")

var smallShipExplosionFile = load("res://scenes/weapon/smallShipExplosion.tscn")

var bulletMarkerFile = load("res://radar_map/bullet_marker.tscn")

var pdcPivotPath = ["/root/Node/player/pdc_pivot_upper_left", "/root/Node/player/pdc_pivot_upper_right"]
var pdcMarkerPath = ["/root/Node/player/pdc_pivot_upper_left/pdc_upper_left/pdc_marker_upper_left", "/root/Node/player/pdc_pivot_upper_right/pdc_upper_right/pdc_marker_upper_right"]

#Healthbar
@onready var healthBar = get_node("/root/Node/hud_canvas/health_bar")

#Stats
#Health stats
var health = 100
var maxhealth = 100

#Movement stats
const ACCELERATION1 = 1
const ACCELERATION2 = 2

var acceleration = 0
var angVelocity = 0

var bulletSpeed = 3000

#Cooldowns
var shootCooldown = 0
var missileCooldown = 0

func _ready():
	healthBar.recalculate(health,maxhealth)

func shoot_PDC():
	for i in range(2):
		var bullet = bulletFile.instantiate()
		bullet.position = get_node(pdcMarkerPath[i]).global_position + velocity/60
		get_parent().add_child(bullet)
		bullet.rotation = get_node(pdcPivotPath[i]).rotation + rotation
		bullet.rotation += rng.randf_range(-PI/180, PI/180)
		bullet.velocity = velocity
		bullet.velocity += Vector2(bulletSpeed,0).rotated(bullet.rotation)
		bullet.set_visible(true)
		
		var bullet_marker = bulletMarkerFile.instantiate()
		bullet_marker.markerTarget = bullet
		$/root/Node/map_canvas/radar_map.add_child(bullet_marker)
		

func shoot_missile():
	var missile = missileFile.instantiate()
	missile.allegiance = "MCRN"
	if "allegiance" in $/root/Node/mainCamera.target and $/root/Node/mainCamera.target.allegiance != "MCRN":
		missile.target = $/root/Node/mainCamera.target
	else:
		missile.target = $/root/Node/enemy_ship
	missile.set_collision_layer_value(2, true)
	missile.set_collision_mask_value(9, true)
	missile.set_collision_mask_value(10, true)
	missile.global_position = global_position + Vector2(50,0).rotated(rotation)
	missile.velocity = velocity
	missile.rotation = rotation
	missile.velocity += Vector2(300,0).rotated(rotation)
	get_parent().add_child(missile)
	
	var missile_marker = missileMarkerFile.instantiate()
	missile_marker.markerTarget = missile
	$/root/Node/map_canvas/radar_map.add_child(missile_marker)

func take_damage_missile():
	health -= 1
	healthBar.recalculate(health,maxhealth)

func death():
	var small_ship_explosion = smallShipExplosionFile.instantiate()
	small_ship_explosion.position = global_position
	small_ship_explosion.velocity = velocity
	get_parent().add_child(small_ship_explosion)
	queue_free()

func _physics_process(delta: float) -> void:
	if health < 0:
		death()
	
	# Add the gravity.
	velocity += Vector2(acceleration,0).rotated(rotation)
	rotation_degrees += angVelocity
	
	if Input.is_action_pressed("key_w"):
		velocity.x += cos(rotation)*10
		velocity.y += sin(rotation)*10
	if Input.is_action_pressed("key_a"):
		velocity.x += sin(rotation)*10
		velocity.y -= cos(rotation)*10
	if Input.is_action_pressed("key_s"):
		velocity.x -= cos(rotation)*10
		velocity.y -= sin(rotation)*10
	if Input.is_action_pressed("key_d"):
		velocity.x -= sin(rotation)*10
		velocity.y += cos(rotation)*10
	
	
	if Input.is_action_pressed("key_e"):
		angVelocity += 0.04
	if Input.is_action_pressed("key_q"):
		angVelocity -= 0.04
	if Input.is_action_pressed("ui_right"):
		angVelocity += 0.1
	if Input.is_action_pressed("ui_left"):
		angVelocity -= 0.1
		
		
	if Input.is_action_pressed("key_r"):
		angVelocity = 0

	if Input.is_action_pressed("key_1"):
		acceleration = 0
		$ship_sprite.texture = load("res://sprites/ship_and_parts/player/roci_drive_off.png")
	if Input.is_action_pressed("key_2"):
		acceleration = ACCELERATION1
		$ship_sprite.texture = load("res://sprites/ship_and_parts/player/roci_drive_on.png")
	if Input.is_action_pressed("key_3"):
		acceleration = ACCELERATION2
		$ship_sprite.texture = load("res://sprites/ship_and_parts/player/roci_drive_on.png")
	
	if Input.is_action_pressed("click") && shootCooldown == 0:
		shoot_PDC()
		shootCooldown = 3
	if Input.is_action_pressed("key_space") && missileCooldown == 0:
		shoot_missile()
		missileCooldown = 60
		
	if shootCooldown > 0:
		shootCooldown -= 1
		
	if missileCooldown > 0:
		missileCooldown -= 1
	
	move_and_slide()
