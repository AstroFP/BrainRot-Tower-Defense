class_name  BasicUpgrade
extends Resource

## Name of an upgrade
@export var name : String = ""

## Short description of an upgrade
@export_multiline var description : String = ""

## Detailed description of an upgrade. Should list everything the upgrade does
@export_multiline var details : String = ""

## Cost of an upgrade
@export var cost : int = 0

## Array of effects gained from an upgrade
@export var effects : Array[Effect]

## Array of actions gaind from an upgrade
@export var actions : Array[Action] = []

## Array of extra attacks gained from an upgrade
@export var attacks : Array[ExtraAttack] = []

## Array of attack replacers gained from an upgrade
@export var replacers : Array[AttackReplacer] = []

## Array of attack enhancements gained from an upgrade
@export var enhancements : Array[AttackEnhancement] = []

## Attack changer - changes tower's default attack
@export var changer : AttackChanger

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
#}
