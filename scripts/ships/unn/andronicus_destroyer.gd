extends "res://scripts/ships/unn/enemy_ship.gd"

const displayType = "Andronicus-class Destroyer"
var displayName = ""

func missile_cooldowns():
	if missileCooldown == 1155:
		shoot_missile()
	if missileCooldown == 1170:
		shoot_missile()
	if missileCooldown == 1185:
		shoot_missile()
	if missileCooldown > 1200:
		shoot_missile()
		missileCooldown = rng.randi_range(-150,150)

func special_init():
	PDCLockDistance = 2500
