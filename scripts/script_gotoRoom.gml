var r = argument0;

room_set_height(r, global.displayHeight);
room_set_width(r, global.displayWidth);
room_set_view(r, 0, true, 0, 0, global.displayWidth, global.displayHeight, 0, 0, global.displayWidth, global.displayHeight, 0, 0, 4, 4, -1);
room_goto(r);
