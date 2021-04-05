extends Spatial


var selected_object = null setget set_selected_object
var selected_object_is_grabbed:bool = false

var maximum_mouse_distance:float = 5


# Called when the node enters the scene tree for the first time.
func _ready():
    pass


func _input(event):
    if Input.is_action_just_released("primary_click") and selected_object_is_grabbed:
        selected_object_is_grabbed = false
        selected_object.grabbed = false


func set_selected_object(object):
    if selected_object:
        selected_object.selected = false
    if object:
        selected_object = object
        selected_object.selected = true
    else:
        selected_object = null
    selected_object_is_grabbed = false


func move_sobject_to_position(position:Vector3, sobject):
    sobject.move(position)
    


func _on_Floor_mouse_position_updated(mouse_position):
    if selected_object_is_grabbed:
        move_sobject_to_position(mouse_position, selected_object)


func _on_SObject_clicked(object):
    if not object == selected_object:
        set_selected_object(object)
    else:
        set_selected_object(null)


func _on_SObject_grabbed(object):
    if selected_object_is_grabbed:
        return
    selected_object_is_grabbed = true
    selected_object.grabbed = true


func _on_SObject_snapped(object, snap_data):
    pass
    #var line_length:float = 5.0
    #var plane_center = snap_data.center()
    #var from = plane_center*(snap_data.normal.rotated(Vector3.UP, deg2rad(90)*line_length))
    #var to = plane_center*(snap_data.normal.rotated(Vector3.UP, deg2rad(-90)*line_length))
    #from = get_viewport().get_camera().unproject_position(from)
    #to = get_viewport().get_camera().unproject_position(to)
    #$CanvasLayer/Draw.lines.append({"from":from, "to":to})
