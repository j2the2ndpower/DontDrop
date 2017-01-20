global.displayHeight = display_get_height();
global.displayWidth = display_get_width();
window_set_size(global.displayWidth, global.displayHeight);
window_set_position(0,0);

chartboost_init_sdk("58812ac543150f69800abe29", "5bf92e11e1663564bad927ef2e4aaa75824592f9");
global.showingAd = false;
global.loseCount = 0;
