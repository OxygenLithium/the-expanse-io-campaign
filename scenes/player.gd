extends CharacterBody2D

var type = "ship"
var allegiance = "MCRN"

var health = 100
var maxhealth = 100

var rng = RandomNumberGenerator.new()

var bulletFile = load("res://scenes/weapon/bullet.tscn")
var missileFile = load("res://scenes/weapon/missile.tscn")

var smallShipExplosionFile = load("res://scenes/weapon/smallShipExplosion.tscn")

var bulletMarkerFile = load("res://radar_map/bullet_marker.tscn")

var pdcPivotPath = ["/root/Node/player/pdc_pivot_upper_left", "/root/Node/player/pdc_pivot_upper_right"]
var pdcMarkerPath = ["/root/Node/player/pdc_pivot_upper_left/pdc_upper_left/pdc_marker_upper_left", "/root/Node/player/pdc_pivot_upper_right/pdc_upper_right/pdc_marker_upper_right"]

@onready var healthBar = get_node("/root/Node/hud_canvas/health_bar")

const ACCELERATION1 = 1
const ACCELERATION2 = 2

var acceleration = 0
var angVelocity = 0

var bulletSpeed = 3000
var shootTimer = 0

func _ready():
	healthBar.recalculate(health,maxhealth)

func shootPDC():
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
		bullet_marker.bullet = bullet
		$/root/Node/map_canvas/radar_map.add_child(bullet_marker)
		

	shootTimer = 3

func take_damage_missile():
	health -= 40
	print(health)
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
	if Input.is_action_pressed("key_2"):
		acceleration = ACCELERATION1
	if Input.is_action_pressed("key_3"):
		acceleration = ACCELERATION2
	
	if Input.is_action_pressed("click") && shootTimer == 0:
		shootPDC()
	if shootTimer > 0:
		shootTimer = shootTimer - 1
	
	move_and_slide()
