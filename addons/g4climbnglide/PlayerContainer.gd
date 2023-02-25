extends Node3D

@export_category("Movement Settings")
@export var jump_length:float = 0.5
@export var jump_power:float = 2000;
@export var wall_jump_power:float = 2000;
@export var gravity:float = 500
@export var runspeed:float = 5
@export var climbspeed:float = 2
@export var climb_hold_force:float = 2
@export var climb_hold_time:float = 0.25
@export var air_run_time:float = 0.25
@export var wall_jump_outness:float = 0.5
@export var dash_speed:float = 3
@export var dash_length:float = 0.25
@export var air_dash:bool = true
@export var attack_time:float = 0.9*0.5

@export_category("Stamina Settings")
@export var max_stamina:float = 100
@export var current_stamina:float = 100
@export var drain_rates:Dictionary = {"CLIMB": 10.0,"DASH": 100.0,"GLIDE": 10.0}
@export var recovery_rate:float = 50.0
@export var recovery_wait_time:float = 3.0
@export var hide_wait_time:float = 0.0

@export_category("Camera Settings")
@export var follow_speed:float = 5
@export var invertX:bool = false
@export var invertY:bool = false
