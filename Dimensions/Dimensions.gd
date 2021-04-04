extends Node2D


var lines:Array
var current_line:Array

var drawing_line:bool = false

var line_color_primary:Color = Color(1,1,1)
var line_color_secondary:Color = Color(.5,.5,.5)
var line_width:int = 2


func _ready():
    pass


func _process(delta):
    if Input.is_action_just_pressed("primary_click") and not drawing_line:
        var new_label = Label.new()
        var crect = ColorRect.new()
        crect.color = Color(0,0,0)
        crect.set_anchors_preset(15)
        crect.show_behind_parent = true
        $Labels.add_child(new_label)
        new_label.add_child(crect)
        current_line=[get_viewport().get_mouse_position(),get_viewport().get_mouse_position(),new_label]
        drawing_line = true
    elif Input.is_action_just_pressed("primary_click") and drawing_line:
        drawing_line = false
        lines.append(current_line)
    if drawing_line:
        current_line[1] = get_viewport().get_mouse_position()
    update()


func _draw():
    draw_set_transform_matrix(transform.inverse())
    for line in lines:
        draw_dashed_line(line[0], line[1], line_color_primary, line_width, 10)
    if drawing_line:
        draw_dashed_line(current_line[0], current_line[1], line_color_primary, line_width, 10)
        var mid_point = current_line[0] - (current_line[0]-current_line[1]).normalized()*current_line[0].distance_to(current_line[1])*.5
        current_line[2].rect_position = mid_point - Vector2(current_line[2].rect_size.x*.5, current_line[2].rect_size.y*.5)
        current_line[2].text = String(current_line[0].distance_to(current_line[1]))
        
        draw_dashed_line(current_line[0], Vector2(current_line[1].x,current_line[0].y), line_color_secondary, line_width, 10)
        draw_line(Vector2(current_line[1].x,current_line[0].y), current_line[1], line_color_secondary, line_width, true)
        draw_dashed_line(current_line[0], Vector2(current_line[0].x,current_line[1].y), line_color_secondary, line_width, 10)
        draw_line(Vector2(current_line[0].x,current_line[1].y), current_line[1], line_color_secondary, line_width, true)


func draw_dashed_line(from, to, color, width, dash_length = 5, cap_end = false, antialiased = true):
    var length = (to - from).length()
    var normal = (to - from).normalized()
    var dash_step = normal * dash_length
    
    if length < dash_length: #not long enough to dash
        draw_line(from, to, color, width, antialiased)
        return

    else:
        var draw_flag = true
        var segment_start = from
        var steps = floor(length/dash_length)
        var last_step:bool = false
        var iterations:int = 0
        for start_length in range(0, steps+1):
            iterations+=1
            var segment_end = segment_start + dash_step
            if iterations == steps+1:
                draw_line(segment_start,to,color,width,antialiased)
            else:
                if draw_flag:
                    draw_line(segment_start, segment_end, color, width, antialiased)

            segment_start = segment_end
            draw_flag = !draw_flag
        
        if cap_end:
            draw_line(segment_start, to, color, width, antialiased)
