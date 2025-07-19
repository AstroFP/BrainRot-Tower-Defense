class_name BobrittoBanditoUpgrades
extends Resource

# path 1 upgrades
const gun_blazing = preload("res://resources/towers/upgrades_data/bobritto_bandito/path_1/gun_blazing.tres")

# path 2 upgrades
const military_grade_bullets = preload("res://resources/towers/upgrades_data/bobritto_bandito/path_2/military_grade_bullets.tres")

# path 3 upgrades
const steady_grip = preload("res://resources/towers/upgrades_data/bobritto_bandito/path_3/steady_grip.tres")


var upgrades := {
	"path_1":{
		"upgrades":[
			gun_blazing,
		]
	},
	"path_2":{
		"upgrades":[
			military_grade_bullets,
		]
	},
	"path_3":{
		"upgrades":[
			steady_grip,
		]
	}
}

#var upgrades := {
	#"paths":{
		#"path_1":{
			#"upgrades":[
				#gun_blazing,
			#]
		#},
		#"path_2":{
			#"upgrades":[
				#{
					#"level":1,
					#"name":"Quality bullets",
					#"description":"",
					#"cost":690,
					#"effects":{
						#"attack_damage_multiplier":0.5
					#},
					#"actions":[
						#{
							#"name":"special_attack",
							#"param1":1
						#},
						#{
							#"name":"double_tap",
							#"param1":1
						#}
					#],
					#"attacks":[
						#{
							#"name": "additional_attack",
							#"delay":0.5,
							#"param2":1
						#}
					#],
					#"replacers":[
						#{
							#"name":"additional_attack",
							#"interval":3,
							#"param2":1
						#}
					#],
					#"enhancements":[
						#{
							#"name":"attack_enhancement",
							#"param1":1
						#}
					#],
					#"changers":[
						#{
							#"name":"attack_changer",
							#"param1":1
						#}
					#]
				#},
			#]
		#},
		#"path_3":{
			#"upgrades":[
				#{
					#"level":1,
					#"name":"Steady grip",
					#"description":"",
					#"cost":250,
					#"effects":{
						#"attack_radius_multiplier":0.10
					#},
					#"actions":[{}]
				#},
			#]
		#},
	#}
#}
