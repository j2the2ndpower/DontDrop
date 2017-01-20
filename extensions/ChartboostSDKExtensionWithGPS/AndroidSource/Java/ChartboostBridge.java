package ${YYAndroidPackageName};

		import com.chartboost.sdk.*;
		import com.chartboost.sdk.Chartboost;
		import com.chartboost.sdk.CBLocation;
		import com.chartboost.sdk.ChartboostDelegate;
		import com.chartboost.sdk.Libraries.CBLogging.Level;
		import com.chartboost.sdk.Model.CBError.CBClickError;
		import com.chartboost.sdk.Model.CBError.CBImpressionError;
		import com.chartboost.sdk.Tracking.CBAnalytics;
		import com.chartboost.sdk.CBImpressionActivity;
		import com.chartboost.sdk.Model.CBError.CBImpressionError;
		import android.util.Log;
		import android.os.Bundle;
		import android.app.Activity;
		import android.content.Context;
		import android.net.ConnectivityManager;
		import android.net.NetworkInfo;
		import ${YYAndroidPackageName}.R;
		import ${YYAndroidPackageName}.RunnerActivity;
		import com.yoyogames.runner.RunnerJNILib;

/**
 *
 * @author Josep Gonzalez Fernandez (Dreams Corner);
 */
//public class ChartBoostExt extends Activity{
public class ChartboostBridge extends Activity {

	final int CBLocationStartupExt = 101;
	final int CBLocationHomeScreenExt = 102;
	final int CBLocationMainMenuExt = 103;
	final int CBLocationGameScreenExt = 104;
	final int CBLocationAchievementsExt = 105;
	final int CBLocationQuestsExt = 106;
	final int CBLocationPauseExt = 107;
	final int CBLocationLevelStartExt = 108;
	final int CBLocationLevelCompleteExt = 109;
	final int CBLocationTurnCompleteExt = 110;
	final int CBLocationIAPStoreExt = 111;
	final int CBLocationItemStoreExt = 112;
	final int CBLocationGameOverExt = 113;
	final int CBLocationLeaderBoardExt = 114;
	final int CBLocationSettingsExt = 115;
	final int CBLocationQuitExt = 116;
	final int CBLocationDefaultExt = 117;

	final int CBDidDisplayInterstitial = 201;
	final int CBDidCacheInterstitial = 202;
	final int CBDidFailToLoadInterstitial = 203;
	final int CBDidDismissInterstitial = 204;
	final int CBDidCloseInterstitial = 205;
	final int CBDidClickInterstitial = 206;
	final int CBDidDisplayMoreApps = 207;
	final int CBDidCacheMoreApps = 208;
	final int CBDidFailToLoadMoreApps = 209;
	final int CBDidDismissMoreApps = 210;
	final int CBDidCloseMoreApps = 211;
	final int CBDidClickMoreApps = 212;
	final int CBDidDisplayRewardedVideo = 213;
	final int CBDidCacheRewardedVideo = 214;
	final int CBDidFailToLoadRewardedVideo = 215;
	final int CBDidDismissRewardedVideo = 216;
	final int CBDidCloseRewardedVideo = 217;
	final int CBDidClickRewardedVideo = 218;
	final int CBDidCompleteRewardedVideo = 219;
	final int CBDidInitialize = 220;
  final int CBDidFailToInitialize = 221;

	final int CBLoadErrorNetworkFailure = 5;

	final int EVENT_OTHER_SOCIAL = 70;

	public String getLocationConstant(int location) {
		switch (location) {
			case CBLocationStartupExt:
				return CBLocation.LOCATION_STARTUP;
			case CBLocationHomeScreenExt:
				return CBLocation.LOCATION_HOME_SCREEN;
			case CBLocationMainMenuExt:
				return CBLocation.LOCATION_MAIN_MENU;
			case CBLocationGameScreenExt:
				return CBLocation.LOCATION_GAME_SCREEN;
			case CBLocationAchievementsExt:
				return CBLocation.LOCATION_ACHIEVEMENTS;
			case CBLocationQuestsExt:
				return CBLocation.LOCATION_QUESTS;
			case CBLocationPauseExt:
				return CBLocation.LOCATION_PAUSE;
			case CBLocationLevelStartExt:
				return CBLocation.LOCATION_LEVEL_START;
			case CBLocationLevelCompleteExt:
				return CBLocation.LOCATION_LEVEL_COMPLETE;
			case CBLocationTurnCompleteExt:
				return CBLocation.LOCATION_TURN_COMPLETE;
			case CBLocationIAPStoreExt:
				return CBLocation.LOCATION_IAP_STORE;
			case CBLocationItemStoreExt:
				return CBLocation.LOCATION_ITEM_STORE;
			case CBLocationGameOverExt:
				return CBLocation.LOCATION_GAMEOVER;
			case CBLocationLeaderBoardExt:
				return CBLocation.LOCATION_LEADERBOARD;
			case CBLocationSettingsExt:
				return CBLocation.LOCATION_SETTINGS;
			case CBLocationQuitExt:
				return CBLocation.LOCATION_QUIT;

			default:
				return CBLocation.LOCATION_DEFAULT;
		}
	}

	public double getLocationDoubleConstant(String location) {
		if (location.equals(CBLocation.LOCATION_STARTUP)) {
			return CBLocationStartupExt;
		} else if (location.equals(CBLocation.LOCATION_HOME_SCREEN)) {
			return CBLocationHomeScreenExt;
		} else if (location.equals(CBLocation.LOCATION_MAIN_MENU)) {
			return CBLocationMainMenuExt;
		} else if (location.equals(CBLocation.LOCATION_GAME_SCREEN)) {
			return CBLocationGameScreenExt;
		} else if (location.equals(CBLocation.LOCATION_ACHIEVEMENTS)) {
			return CBLocationAchievementsExt;
		} else if (location.equals(CBLocation.LOCATION_QUESTS)) {
			return CBLocationQuestsExt;
		} else if (location.equals(CBLocation.LOCATION_PAUSE)) {
			return CBLocationPauseExt;
		} else if (location.equals(CBLocation.LOCATION_LEVEL_START)) {
			return CBLocationLevelStartExt;
		} else if (location.equals(CBLocation.LOCATION_LEVEL_COMPLETE)) {
			return CBLocationLevelCompleteExt;
		} else if (location.equals(CBLocation.LOCATION_TURN_COMPLETE)) {
			return CBLocationTurnCompleteExt;
		} else if (location.equals(CBLocation.LOCATION_IAP_STORE)) {
			return CBLocationIAPStoreExt;
		} else if (location.equals(CBLocation.LOCATION_ITEM_STORE)) {
			return CBLocationItemStoreExt;
		} else if (location.equals(CBLocation.LOCATION_GAMEOVER)) {
			return CBLocationGameOverExt;
		} else if (location.equals(CBLocation.LOCATION_LEADERBOARD)) {
			return CBLocationLeaderBoardExt;
		} else if (location.equals(CBLocation.LOCATION_SETTINGS)) {
			return CBLocationSettingsExt;
		} else if (location.equals(CBLocation.LOCATION_QUIT)) {
			return CBLocationQuitExt;
		} else {
			return CBLocationDefaultExt;
		}
	}

	public boolean isNetworkAvailable() {
    ConnectivityManager connectivityManager = (ConnectivityManager)RunnerActivity.CurrentActivity.getApplicationContext().getSystemService(Context.CONNECTIVITY_SERVICE);
    NetworkInfo activeNetworkInfo = connectivityManager
            .getActiveNetworkInfo();
    return activeNetworkInfo != null;
	}

	public boolean checkInternetConnection(int event) {
    if (!isNetworkAvailable()) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", event );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "error", CBLoadErrorNetworkFailure);

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
			return false;
    }
		return true;
	}

	public void initSDK(String appId, String appSignature) {
		final String appID_ = appId;
		final String appSignature_ = appSignature;
		RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
			public void run() {
				checkInternetConnection(CBDidFailToInitialize);
				Chartboost.startWithAppId(RunnerActivity.CurrentActivity, appID_, appSignature_);
				Chartboost.setDelegate(delegate);
				Chartboost.onCreate(RunnerActivity.CurrentActivity);
				Chartboost.onStart(RunnerActivity.CurrentActivity);
			}
		});

		Log.i("yoyo", "*** initChartBoost");
	}

	public double showInterstitial(double location){
		final int location_ = (int)location;
		RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
			public void run() {
				if (checkInternetConnection(CBDidFailToLoadInterstitial)) {
						Chartboost.showInterstitial(getLocationConstant(location_));
				}
			}
		});
		return 1.0;
	}

	public void cacheInterstitial(double location){
		final int location_ = (int)location;
		RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
			public void run() {
				if (checkInternetConnection(CBDidFailToLoadInterstitial)) {
						Chartboost.cacheInterstitial(getLocationConstant(location_));
				}
			}
		});
	}

	public double hasInterstitial(double location){
		final int location_ = (int)location;
		return Chartboost.hasInterstitial(getLocationConstant(location_)) ? 1 : 0;
	}

	public double showMoreApps(double location){
		final int location_ = (int)location;
		RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
			public void run() {
				if (checkInternetConnection(CBDidFailToLoadMoreApps)) {
						Chartboost.showMoreApps(getLocationConstant(location_));
				}
			}
		});
		return 1.0;
	}

	public void cacheMoreApps(double location) {
		final int location_ = (int)location;
		RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
			public void run() {
				if (checkInternetConnection(CBDidFailToLoadMoreApps)) {
						Chartboost.cacheMoreApps(getLocationConstant(location_));
				}
			}
		});
	}

	public double hasMoreApps(double location) {
		final int location_ = (int)location;
		return Chartboost.hasMoreApps(getLocationConstant(location_)) ? 1 : 0;
	}

	public double showRewardedVideo(double location){
		final int location_ = (int)location;
		RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
			public void run() {
				if (checkInternetConnection(CBDidFailToLoadRewardedVideo)) {
						Chartboost.showRewardedVideo(getLocationConstant(location_));
				}
			}});
		return 1.0;
	}

	public void cacheRewardedVideo(double location) {
		final int location_ = (int)location;
		RunnerActivity.CurrentActivity.runOnUiThread(new Runnable() {
			public void run() {
				if (checkInternetConnection(CBDidFailToLoadRewardedVideo)) {
						Chartboost.cacheRewardedVideo(getLocationConstant(location_));
				}
			}
		});
	}

	public double hasRewardedVideo(double location) {
		final int location_ = (int)location;
		return Chartboost.hasRewardedVideo(getLocationConstant(location_)) ? 1 : 0;
	}

	public void setAutoCacheAds(double enable) {
		Chartboost.setAutoCacheAds(enable == 1);
	}

	public double getAutoCacheAds() {
		return Chartboost.getAutoCacheAds() ? 1 : 0;
	}

	public String getSDKVersion() {
		return Chartboost.getSDKVersion();
	}

	public double hasInternetConnection() {
    return isNetworkAvailable() ? 1 : 0;
	}

	private ChartboostDelegate delegate = new ChartboostDelegate() {

		@Override
		public void didDisplayInterstitial(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidDisplayInterstitial );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didCacheInterstitial(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidCacheInterstitial );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didFailToLoadInterstitial(String location, CBImpressionError error) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidFailToLoadInterstitial);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));
			RunnerJNILib.DsMapAddDouble(dsMapIndex, "error", error.ordinal());

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didDismissInterstitial(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidDismissInterstitial );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didCloseInterstitial(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidCloseInterstitial );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didClickInterstitial(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidClickInterstitial );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didDisplayMoreApps(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidDisplayMoreApps );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didCacheMoreApps(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidCacheMoreApps );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didFailToLoadMoreApps(String location, CBImpressionError error) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidFailToLoadMoreApps);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));
			RunnerJNILib.DsMapAddDouble(dsMapIndex, "error", error.ordinal());

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didDismissMoreApps(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidDismissMoreApps );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didCloseMoreApps(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidCloseMoreApps );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didClickMoreApps(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidClickMoreApps );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didDisplayRewardedVideo(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidDisplayRewardedVideo );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didCacheRewardedVideo(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidCacheRewardedVideo );
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didFailToLoadRewardedVideo(String location, CBImpressionError error) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble(dsMapIndex, "type", CBDidFailToLoadRewardedVideo);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));
			RunnerJNILib.DsMapAddDouble(dsMapIndex,"error", error.ordinal());

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didDismissRewardedVideo(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble(dsMapIndex, "type", CBDidDismissRewardedVideo);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didCloseRewardedVideo(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble(dsMapIndex, "type", CBDidCloseRewardedVideo);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didClickRewardedVideo(String location) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble(dsMapIndex, "type", CBDidClickRewardedVideo);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didCompleteRewardedVideo(String location, int reward) {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidCompleteRewardedVideo);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "location", getLocationDoubleConstant(location));
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "reward", reward);

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}

		@Override
		public void didInitialize() {
			int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "type", CBDidInitialize);
			RunnerJNILib.DsMapAddDouble( dsMapIndex, "status", 1);

			RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
		}
	};

}
