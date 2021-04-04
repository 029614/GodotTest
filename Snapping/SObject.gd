extends KinematicBody

signal clicked(object)
signal grabbed(object)
signal snapped(area)

var rotation_increment:float = 0.1
var snapped_to:Array

var selected:bool = false setget set_selected
var grabbed:bool = false setget set_grabbed
var _snapped:bool = false setget set_snapped

var just_pressed:bool = false
var just_released:bool = false

var grabbed_rotation:Vector3

export(float) var height:float = 2.0 setget set_height
export(float) var width:float = 2.0 setget set_width
export(float) var depth:float = 2.0 setget set_depth

var size:Vector3 setget ,get_size

var maximum_distance_from_mouse:float = 3.0
var unsnap_distance:float = 1.0

var corner_range:float = 0.25

var face_thickness:float = 0.125
var face_margin:float = 0.125

var smart_face
var smart_corner


# Called when the node enters the scene tree for the first time.
func _ready():
    $MeshInstance.mesh = $MeshInstance.mesh.duplicate()
    $CollisionShape.shape = $CollisionShape.shape.duplicate()
    self.height = height
    self.width = width
    self.depth = depth
    self.translation.y = height*.5
    _ready_areas()


func _ready_areas():
    smart_face = SmartFace.new()
    smart_face.configure(face_thickness, face_margin, corner_range)
    smart_face.faces_enabled = true
    smart_face.size = Vector3(width, height, depth)
    add_child(smart_face)
    smart_face.connect("collision", self, "_on_face_collision")
    smart_face.connect("unsnap", self, "_on_unsnap")
    
    smart_corner = SmartFace.new()
    smart_corner.configure(face_thickness, face_margin, corner_range)
    smart_corner.corners_enabled = true
    smart_corner.size = Vector3(width, height, depth)
    add_child(smart_corner)
    smart_corner.connect("collision", self, "_on_corner_collision")
    smart_corner.connect("unsnap", self, "_on_unsnap")
    


func move(mouse_position:Vector3):
    check_unsnap(mouse_position)
    var hv = get_holding_vector()
    if hv.length() < 1.0:
        _snapped = true
    else:
        _snapped = false
    var move_offset = Vector3(0,0,1).rotated(Vector3.UP, self.rotation.y)*size*.5
    var movector = (to_local(mouse_position)*hv)
    var mvc = movector.rotated(Vector3.UP, self.rotation.y)+move_offset
    var kc:KinematicCollision = self.move_and_collide(mvc + Vector3(1,1,1)*(get_safe_margin()*3), true, true, true)
    if kc:
        if not kc.get_collider().name == "Floor":
            self.translation += kc.get_travel()
        else:
            self.translation += mvc
    else:
        self.translation += mvc
    if translation.y < height*.5:
        translation.y = height*.5


func get_holding_vector() -> Vector3:
    var result:Vector3 = Vector3(1,1,1)
    for object in snapped_to:
        var normal = object["normal"]
        result -= Vector3(abs(normal.x),abs(normal.y),abs(normal.z))
    result = Vector3(clamp(result.x,0,1),clamp(result.y,0,1),clamp(result.z,0,1))
    return result


func check_unsnap(mouse_position:Vector3):
    for object in snapped_to:
        var plane = get_plane(object["normal"])
        print("mouse distance from plane: ",plane.distance_to(mouse_position))
        if abs(plane.distance_to(mouse_position)) > object["hold_influence"]+abs(plane.distance_to(translation)):
            snapped_to.erase(object)
                
                
func get_plane(face:Vector3) -> Plane: 
    #print("SObject.get plane(): face = ",face)
    var norm1 = get_face_normal(face)
    var distance = 0
    var ss = scalar_sign(face)
    if ss == -1:
        distance = norm1.dot(get_global_minimum())
    elif ss == 1:
        distance = norm1.dot(get_global_maximum())
    return Plane(norm1, distance)


func get_face_normal(face:Vector3) -> Vector3:
    #print("FACE: ", face, " NORMAL: ", face.rotated(Vector3(0,1,0), self.rotation.y))
    return face.rotated(Vector3(0,1,0), self.rotation.y)
    
    
func scalar_sign(vec:Vector3) -> int:
    if vec.x+vec.y+vec.z < 0:
        return -1
    elif vec.x+vec.y+vec.z > 0:
        return 1
    else:
        return 0
    
    
func get_global_minimum():
    return self.transform.xform(get_size()*-.5)
    
func get_global_maximum():
    return self.transform.xform(get_size()*.5)


func get_size() -> Vector3:
    var size = Vector3(width, height, depth)
    return size
            

func set_height(value:float):
    height = value
    $MeshInstance.mesh.size.y = value
    $CollisionShape.shape.extents.y = value*.5
    if smart_face:
        smart_face.size = Vector3(smart_face.size.x, value, smart_face.size.x)
    if smart_corner:
        smart_corner.size = Vector3(smart_corner.size.x, value, smart_corner.size.x)


func set_width(value:float):
    width = value
    $MeshInstance.mesh.size.x = value
    $CollisionShape.shape.extents.x = value*.5
    if smart_face:
        smart_face.size = Vector3(value, smart_face.size.y, smart_face.size.x)
    if smart_corner:
        smart_corner.size = Vector3(value, smart_corner.size.y, smart_corner.size.x)


func set_depth(value:float):
    depth = value
    $MeshInstance.mesh.size.z = value
    $CollisionShape.shape.extents.z = value*.5
    if smart_face:
        smart_face.size = Vector3(smart_face.size.x, smart_face.size.y, value)
    if smart_corner:
        smart_corner.size = Vector3(smart_corner.size.x, smart_corner.size.y, value)


func set_y_rotation(value:float):
    value = wrapf(value, 0, deg2rad(359.9999))
    self.rotation.y = value


func set_selected(value:bool):
    selected = value
    if value:
        $MeshInstance.mesh.material.albedo_color.a = .5
    else:
        $MeshInstance.mesh.material.albedo_color.a = 1


func set_grabbed(value:bool):
    grabbed = value
    if value:
        self.input_ray_pickable = false
        grabbed_rotation = self.rotation
    else:
        self.input_ray_pickable = true


func set_snapped(value:bool):
    _snapped = value
    if value == false:
        set_y_rotation(grabbed_rotation.y)


func snap_to_target(subject_face_normal, target_face_normal, target_object):
    if not snapped_has(target_object):
        set_y_rotation(normalize_rotation_to_target(self.rotation.y, target_object.rotation.y))
        var target_object_size:Vector3 = Vector3(target_object.width, target_object.height, target_object.depth)
        var self_size:Vector3 = Vector3(width, height, depth)
        var target_vector:Vector3 = to_local(target_object.to_global((target_object_size*.5)*target_face_normal))
        var subject_point:Vector3 = (self_size*.5)*subject_face_normal
        var vector_mod = Vector3()
        for axis in ["x","y","z"]:
            if subject_face_normal[axis] == 0:
                vector_mod[axis] = 1
            else:
                vector_mod[axis] = subject_face_normal[axis]
        target_vector = (target_vector*target_face_normal) + subject_point*vector_mod
        move(to_global(target_vector))
        var snap = {"object":target_object, "normal":subject_face_normal, "hold_influence":.25}
        snapped_to.append(snap)


func snap_to_target_corner(subject_corner_normal, target_corner_normal, target_object):
    if not snapped_has(target_object):
        set_y_rotation(normalize_rotation_to_target(self.rotation.y, target_object.rotation.y))
        
        var canceled_normal:Vector3 = (subject_corner_normal+target_corner_normal)*.5
        
        
        var self_size:Vector3 = Vector3(width, height, depth)
        var target_point:Vector3 = target_object.to_global((target_object.size*.5)*target_corner_normal)
        var subject_point:Vector3 = to_global((self_size*.5)*subject_corner_normal)
        
        var target_vector = target_point-subject_point
        move(translation + target_vector)
        var snap = {"object":target_object, "normal":subject_corner_normal, "hold_influence":.25}
        snapped_to.append(snap)


func normalize_rotation_to_target(subject_rotation:float, target_rotation:float) -> float:
    var final_rotation:float = target_rotation
    var additional_rotation:float = stepify(subject_rotation, deg2rad(90))
    return wrapf(final_rotation + additional_rotation,0,deg2rad(359.9999))


func snapped_has(object) -> bool:
    for obj in snapped_to:
        if obj["object"] == object:
            return true
    return false


func _on_SObject_input_event(camera, event, click_position, click_normal, shape_idx):
    if event.is_action("primary_click"):
        if Input.is_action_just_pressed("primary_click") and not selected:
            emit_signal("clicked", self)
            just_pressed = true
        elif Input.is_action_just_released("primary_click") and selected:
            if just_pressed or just_released:
                if just_pressed:
                    just_pressed = false
                if just_released:
                    just_released = false
            elif selected and not grabbed:
                emit_signal("clicked", self)
    if not Input.is_action_just_pressed("primary_click") and Input.is_action_pressed("primary_click") and selected:
        emit_signal("grabbed", self)
    
    if selected:
        if event.is_action("mouse_wheel_up"):
            if _snapped:
                set_y_rotation(rotation.y + deg2rad(45))
            else:
                set_y_rotation(rotation.y + rotation_increment)
        elif event.is_action("mouse_wheel_down"):
            if _snapped:
                set_y_rotation(rotation.y - deg2rad(45))
            else: 
                set_y_rotation(rotation.y - rotation_increment)


func _on_corner_collision(subject_edge_normal:Vector3, target_edge_normal:Vector3, target_object):
    if grabbed:
        snap_to_target_corner(subject_edge_normal, target_edge_normal, target_object)


func _on_face_collision(subject_face_normal:Vector3, target_face_normal:Vector3, target_object):
    if grabbed:
        snap_to_target(subject_face_normal, target_face_normal, target_object)


func _on_unsnap(snapped_face_normal, object_snapped_to):
    if grabbed:
        for snap in snapped_to:
            if snap["object"]==object_snapped_to:
                snapped_to.erase(snap)
