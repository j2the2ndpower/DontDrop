var t_x = argument0;
var t_y = argument1;
var text = argument2;
var w = argument3;
var h = argument4;

if (w) {
    var ow = string_width(text);
    var scale = global.displayWidth*w/ow;
    draw_text_transformed(t_x, t_y, text, scale, scale, 0);
} else {
    var oh = string_width(text);
    var scale = global.displayHeight*h/oh;
    draw_text_transformed(t_x, t_y, text, scale, scale, 0);
}
