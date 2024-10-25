extends "res://scripts/unn_ships/enemy_ship.gd"

func ready():
	health = 200

func missile_cooldowns():
	if missileCooldown == 500:
		shoot_missile()
	if missileCooldown == 510:
		shoot_missile()
	if missileCooldown == 600:
		shoot_missile()
	if missileCooldown == 610:
		shoot_missile()
	if missileCooldown == 700:
		shoot_missile()
	if missileCooldown > 710:
		shoot_missile()
		missileCooldown = rng.randi_range(0,250)
