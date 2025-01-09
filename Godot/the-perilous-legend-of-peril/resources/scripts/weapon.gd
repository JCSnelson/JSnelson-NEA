extends Equipable

class_name Weapon

@export_enum("Ranged", "Magic", "Melee") var weapon_type: int
@export var attack_power: int
@export var attack_range: int
@export_enum("Ice", "Fire", "Cursed", "Divine","Poison") var damage_type: int
