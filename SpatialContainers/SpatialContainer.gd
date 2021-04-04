extends Node
class_name SpatialContainer

enum alignments {BEGIN, CENTER, END}
enum axis {X, Y, Z}

var alignment:int = alignments.BEGIN setget set_alignment
var size_flags = {
    "X":{
        "FILL":false,
        "EXPAND":false,
        "SHRINK_CENTER":false,
        "SHRINK_END":false
       },
    "Y":{
        "FILL":false,
        "EXPAND":false,
        "SHRINK_CENTER":false,
        "SHRINK_END":false
       },
    "Z":{
        "FILL":false,
        "EXPAND":false,
        "SHRINK_CENTER":false,
        "SHRINK_END":false
       }
   }
var seperation:float = 0.0 setget set_seperation
var size:Vector3 setget set_size
var axis_lock:int setget set_axis_lock


func add_child(node, value=false):
    .add_child(node, value)
    _on_child_added(node)


func remove_child(node):
    .remove_child(node)
    _on_child_removed(node)


func set_alignment(value:int):
    alignment = value


func set_seperation(value:float):
    seperation = value


func set_size(value:Vector3):
    size = value


func set_axis_lock(value:int):
    axis_lock = value


func _on_child_added(node):
    pass


func _on_child_removed(node):
    pass
