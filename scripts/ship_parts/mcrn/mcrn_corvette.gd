extends "res://scripts/ships/mcrn/friendly_ship.gd"

const displayType = "Corvette-class Frigate"
var displayName = ""

func special_init():
	health = 60
	missileShootTimes = [800, 820, 840, 860, 880, 900]
	PDCLockDistance = 2500
	dodgeChance = 60
