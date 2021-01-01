extends Resource
class_name AttackPatternData

export(float, 0, 360) var rotation_per_attack = 0
export(float, 0.1, 0.5) var inbetween_delay = 0.1

export(Array, Resource) var attack_datas = []
