class_name BobrittoBanditoUpgrades
extends Resource

var upgrades := {
	"paths":{
		"path_1":{
			"upgrades":[
				{
					"level":1,
					"name":"Gun blazing",
					"description":"",
					"cost":420,
					"effects":{
						"attack_speed_multiplier": 0.15
					},
					"actions":[{}]
				},
			]
		},
		"path_2":{
			"upgrades":[
				{
					"level":1,
					"name":"Quality bullets",
					"description":"",
					"cost":690,
					"effects":{
						"attack_damage_multiplier":0.5
					},
					"actions":[
						{
							"name":"special_attack",
							"param1":1
						},
						{
							"name":"double_tap",
							"param1":1
						}
					],
					"attacks":[
						{
							"name": "additional_attack",
							"delay":0.5,
							"param2":1
						}
					],
					"replacers":[
						{
							"name":"additional_attack",
							"interval":3,
							"param2":1
						}
					],
					"enhancements":[
						{
							"name":"attack_enhancement",
							"param1":1
						}
					],
					"changers":[
						{
							"name":"attack_changer",
							"param1":1
						}
					]
				},
			]
		},
		"path_3":{
			"upgrades":[
				{
					"level":1,
					"name":"Steady grip",
					"description":"",
					"cost":250,
					"effects":{
						"attack_radius_multiplier":0.10
					},
					"actions":[{}]
				},
			]
		},
	}
}
