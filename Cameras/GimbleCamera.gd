extends Spatial


var moving:bool = false setget set_moving
var previous_mouse_position:Vector2
var mouse_movement_speed:float = 0.01
export(float) var camera_distance:float = 1.0
export(float) var zoom_speed:float = 0.25


# Called when the node enters the scene tree for the first time.
func _ready():
    $Camera.translation.z += camera_distance


func move_camera_relative():
    var new_mouse_position = get_viewport().get_mouse_position()
    var relative_mouse_position = new_mouse_position-previous_mouse_position
    self.rotation.x += -relative_mouse_position.y*mouse_movement_speed
    self.rotation.y += -relative_mouse_position.x*mouse_movement_speed
    previous_mouse_position = new_mouse_position


func set_moving(value:bool):
    moving = value
    previous_mouse_position = get_viewport().get_mouse_position()


func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_MIDDLE:
            if event.pressed:
                print("middle pressed")
                self.moving = true
            elif not event.pressed:
                print("middle released")
                self.moving = false
        if event.button_index == BUTTON_WHEEL_UP and event.pressed:
            $Camera.translation.z -= zoom_speed
        elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
            $Camera.translation.z += zoom_speed
        
    if event is InputEventMouseMotion and moving:
        move_camera_relative()
