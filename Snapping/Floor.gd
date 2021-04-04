extends StaticBody


var mouse_position:Vector3 setget set_mouse_position
signal mouse_position_updated(mouse_position)


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
func set_mouse_position(value:Vector3):
    mouse_position = value
    emit_signal("mouse_position_updated", value)


func _on_Floor_input_event(camera, event, click_position, click_normal, shape_idx):
    if event is InputEventMouseMotion:
        self.mouse_position = click_position


func _on_Wall_input_event(camera, event, click_position, click_normal, shape_idx):
    if event is InputEventMouseMotion:
        self.mouse_position = click_position


func _on_SObject_input_event(camera, event, click_position, click_normal, shape_idx):
    if event is InputEventMouseMotion:
        self.mouse_position = click_position
