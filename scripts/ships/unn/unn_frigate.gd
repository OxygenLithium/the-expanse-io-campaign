extends "res://scripts/ships/unn/enemy_ship.gd"

const displayType = "Mulan-class Gunship"
var displayName = ""

func special_init():
	missileShootTimes = [580, 600]
	PDCLockDistance = 2500
