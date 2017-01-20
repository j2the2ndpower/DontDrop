///scr_update_auto_cache_ads_button

var status = chartboost_get_auto_cache_ads();
if status == 1 {
    o_auto_ads.sprite_index = s_auto_ads;
} else  {
    o_auto_ads.sprite_index = s_auto_ads_off;
}
o_game.auto_cache_ads = status;
