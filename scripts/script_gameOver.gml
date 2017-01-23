global.gameOver = true;
global.loseCount++;
if (global.loseCount >= 3) {
    global.loseCount = 0;
    global.showingAd = true;
    chartboost_show_interstitial(CBLocationDefault);
}

if (global.score > global.highScore) {
    global.highScore = global.score;
    
    ini_open("data.ini");
    ini_write_real("Scores", "high", global.highScore);
    ini_close();
}
