extends Node2D

signal rotation_complete
signal rotation_canceled

export(float,0,100,0.1) var rotation_speed:float = 1.0
export(float,0,360,0.1) var rotation_arc_deg:float = 360
export(bool) var rotation_wrapping:bool = true

enum input_modes {RADIANS, DEGREES}
enum states {STOPPED, ROTATING}
enum directions {CLOCKWISE, COUNTER_CLOCKWISE}

var input_mode = input_modes.RADIANS
var state = states.STOPPED
var direction = directions.CLOCKWISE


func _ready():
    set_physics_process(false)


func _physics_process(delta):
    if input_mode == input_modes.RADIANS:
        _process_radians(delta)
    elif input_mode == input_modes.DEGREES:
        _process_degrees(delta)
        

func _process_radians(delta):
    pass


func _process_degrees(delta):
    pass


func rotate_radians(value:float):
    set_physics_process(true)


func rotate_degrees(value:float):
    set_physics_process(true)


func rotate_to_radian(value:float):
    set_physics_process(true)


func rotate_to_degree(value:float):
    set_physics_process(true)


func rotate_complete():
    emit_signal("rotation_complete")
    state = states.STOPPED
    set_physics_process(false)


func rotate_cancel():
    emit_signal("rotation_canceled")
    state = states.STOPPED
    set_physics_process(false)
