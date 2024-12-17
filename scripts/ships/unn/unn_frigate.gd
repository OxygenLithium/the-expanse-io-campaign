extends "res://scripts/ships/unn/enemy_ship.gd"

const displayType = "Mulan-class Gunship"
var displayName = ""

func special_init():
	health = 25
	acceleration = 2
	missileShootTimes = [580, 600]
	PDCLockDistance = 2500
