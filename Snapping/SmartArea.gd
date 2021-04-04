class_name SmartFace
extends Area


signal collision(subject_face_normal, target_edge_normal, target_object)
signal unsnap(subject_face_normal, target_object)

var face_thickness:float = 0.25
var face_margin:float = 0.5
var corner_radius:float = 0.25

var faces_enabled:bool = false
var corners_enabled:bool = false

var size:Vector3 = Vector3(1,1,1) setget set_size


func _ready():
    #_construct_colliders()
    self.input_ray_pickable = false
    self.connect("area_shape_entered", self, "_on_area_shape_entered")
    self.connect("area_shape_exited", self, "_on_area_shape_exited")


func configure(f_thickness:float, f_margin:float, c_radius:float):
    face_thickness = f_thickness
    face_margin = f_margin
    corner_radius = c_radius


func set_size(value:Vector3):
    size = value
    _reconstruct_colliders()


func _construct_colliders():
    print("constructing colliders")
    
    # Construct Faces
    if faces_enabled:
        for axis in ["x","y","z"]:
            for direction in [1,-1]:
                var area = CollisionArea.new()
                var collider = SmartCollider.new()
                var shape = BoxShape.new()
                var vector = Vector3(0,0,0)
                vector[axis] = direction
                
                shape.extents = size*.5 - Vector3(1,1,1)*face_margin
                shape.extents[axis] = face_thickness*.5
                collider.shape = shape
                
                collider.translation = ((size*.5)*vector) + (shape.extents*.5)*vector
                collider.type = 0
                collider.normal = vector
                area.add_child(collider)
                add_child(area)
                area.input_ray_pickable = false
                area.connect("area_collision", self, "_on_area_collided")
                area.connect("area_decollide", self, "_on_area_decollide")
                #area.connect("area_exited", self, "_on_area_exited")
                area.set_collision_layer(0b00000000000000001000)
                area.set_collision_mask(0b00000000000000001000)
    
    # Construct Edges
    
    if corners_enabled:
        var corners:Array
        var remaining_axis = ["x","y","z"]
        for x in [1,-1]:
            for y in [1,-1]:
                for z in [1,-1]:
                    corners.append(Vector3(x,y,z))
                    print("new corner is corner number: ", corners.size())
    
        for corner in corners:
            var area = CollisionArea.new()
            var collider = SmartCollider.new()
            var shape = SphereShape.new()
            var vector = corner
            
            shape.radius = corner_radius
            collider.shape = shape
            
            var collider_position = ((size*.5)*vector)
            collider.translation = collider_position
            collider.normal = vector
            area.add_child(collider)
            add_child(area)
            area.input_ray_pickable = false
            area.connect("area_collision", self, "_on_area_collided")
            area.connect("area_decollide", self, "_on_area_decollide")
            area.set_collision_layer(0b00000000000000000100)
            area.set_collision_mask(0b00000000000000000100)
            collider.type = 1


func _reconstruct_colliders():
    print("deconstructing colliders")
    if get_child_count() > 0:
        for child in get_children():
            child.queue_free()
    _construct_colliders()


func _on_area_collided(subject_area, target_area):
    if not target_area.get_parent() == self:
        var subject_normal:Vector3 = subject_area.get_child(0).normal
        var target_normal:Vector3 = target_area.get_child(0).normal
        var target_object = target_area.get_parent().get_parent()
        emit_signal("collision", subject_normal, target_normal, target_object)


func _on_area_exited(area):
    if not area.get_parent() == self:
        emit_signal("area_exited",area)


func _on_area_decollide(subject_area, target_area):
    if not target_area.get_parent() == self:
        var subject_normal:Vector3 = subject_area.get_child(0).normal
        var target_object = target_area.get_parent().get_parent()
        emit_signal("unsnap", subject_normal, target_object)
