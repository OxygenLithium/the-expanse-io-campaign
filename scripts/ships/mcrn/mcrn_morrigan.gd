extends "res://scripts/ships/mcrn/friendly_ship.gd"

const displayType = "Morrigan-class Patrol Destroyer"
var displayName = ""

func special_init():
	health = 40
	missileShootTimes = [ 580, 600]
	PDCLockDistance = 2500
	dodgeChance = 80
