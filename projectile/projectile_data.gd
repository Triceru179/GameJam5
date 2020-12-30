extends Resource
class_name ProjectileData

export(float) var speed = 0
export(int) var damage_multiplier = 1

# Extend AttackData
# nome: ataque tridente
#
# Array de Dict
#[
#	{ProjectileData: reto, rotation_offset: 45}
#	{ProjectileData: reto, rotation_offset: 0}
#	{ProjectileData: reto, rotation_offset: -45}
#]

#=============================================

# AttackPatternData
#
# Shoot at target = false
# Array de AttackData [
#	ataque tridente,
#	ataque tridente,
#	ataque tridente,
#]
# Delay entre tiros = 1s
# E rotação por segundo

