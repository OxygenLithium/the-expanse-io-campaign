extends "res://scripts/ships/mcrn/friendly_ship.gd"

const displayType = "Corvette-class Frigate"
var displayName = ""

func special_init():
	missileShootTimes = [500, 520, 540, 560, 580, 600]
	PDCLockDistance = 2500
