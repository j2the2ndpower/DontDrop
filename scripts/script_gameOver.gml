global.gameOver = true;
global.loseCount++;
if (global.loseCount >= 3) {
    global.loseCount = 0;
    global.showingAd = true;
    chartboost_show_interstitial(CBLocationDefault);
}
