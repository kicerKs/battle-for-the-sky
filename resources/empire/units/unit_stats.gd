class_name UnitStats
extends Resource

@export var name:String
@export var description: String
@export var level:= 1
@export var training_cost:={"wood": 1, "food":1, "gold":1, "iron":1, "stone":1} 
@export var training_time:=15 #seconds i guess


@export var max_hp:= 100
@export var armor:=10
@export var range:=1 #more than 1 => range unit

@export var singleTarget:=true
@export var attack:int
@export var attackspeed:int


@export var heal:int
 
