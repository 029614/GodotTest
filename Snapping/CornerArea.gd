class_name CornerArea
extends Area


signal corner_collision(self_normal, target_normal, target_object)

var normal:Vector3
var corner_radius:float = 0.125 setget set_corner_radius


# Called when the node enters the scene tree for the first time.
func configure(corner_position:Vector3, corner_normal:Vector3):
    normal = corner_normal
    var col = CollisionShape.new()
    var shape = SphereShape.new()
    shape.radius = corner_radius
    col.shape = shape
    add_child(col)
    self.connect("area_entered", self, "_on_area_entered")


func set_corner_radius(value:float):
    corner_radius = value
    get_child(0).shape.radius = value


func _on_area_entered(area):
    if area is CornerArea:
        emit_signal("corner_collision", normal, area.normal, area.get_parent())
