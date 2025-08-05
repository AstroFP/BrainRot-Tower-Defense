class_name BobrittoBanditoUpgrades
extends Resource

# path 1 upgrades
const gun_blazing = preload("res://resources/towers/bobritto_bandito/upgrades/path_1/upgrade_bobritto_gun_blazing.tres")

# path 2 upgrades
const military_grade_bullets = preload("res://resources/towers/bobritto_bandito/upgrades/path_2/upgrade_bobritto_military_grade_bullets.tres")

# path 3 upgrades
const steady_grip = preload("res://resources/towers/bobritto_bandito/upgrades/path_3/upgrade_bobritto_steady_grip.tres")


# test
const test_upgrade = preload("res://resources/towers/bobritto_bandito/upgrades/test_upgrade.tres")

var upgrades := {
	"path_1":{
		"upgrades":[
			gun_blazing,
			test_upgrade,
			test_upgrade,
			test_upgrade,
			test_upgrade,
		]
	},
	"path_2":{
		"upgrades":[
			military_grade_bullets,
			test_upgrade,
			test_upgrade,
			test_upgrade,
			test_upgrade,
		]
	},
	"path_3":{
		"upgrades":[
			steady_grip,
			test_upgrade,
			test_upgrade,
			test_upgrade,
			test_upgrade,
		]
	}
}
