extends Node2D


var lines:Array
export(float) var line_width:float = 1.0
export(Color) var line_color:Color = Color(1,1,1)


func _process(delta):
    update()


func _draw():
    for line in lines:
        draw_line(line["from"], line["to"], line_color, line_width, true)
