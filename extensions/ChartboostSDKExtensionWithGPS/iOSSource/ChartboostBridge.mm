//
//  ChartboostBridge.m
//  Chartboost_Example
//
//  Created by Josep Gonzalez Fernandez on 27/8/16.
//  Copyright © 2016 YoYo Games Ltd. All rights reserved.
//

#import "ChartboostBridge.h"
#include <asl.h>
#include <stdio.h>

@implementation ChartboostBridge

const int EVENT_OTHER_SOCIAL = 70;
extern UIView *g_glView;

extern "C" NSString* findOption( const char* _key );
extern bool F_DsMapAdd_Internal(int _index, char* _pKey, double _value);
extern bool F_DsMapAdd_Internal(int _index, char* _pKey, char* _pValue);
extern int CreateDsMap( int _num, ... );
extern void CreateAsynEventWithDSMap(int dsmapindex, int event_index);

typedef NS_ENUM(NSUInteger, CBLocationExt) {
    CBLocationStartupExt = 101,
    CBLocationHomeScreenExt,
    CBLocationMainMenuExt,
    CBLocationGameScreenExt,
    CBLocationAchievementsExt,
    CBLocationQuestsExt,
    CBLocationPauseExt,
    CBLocationLevelStartExt,
    CBLocationLevelCompleteExt,
    CBLocationTurnCompleteExt,
    CBLocationIAPStoreExt,
    CBLocationItemStoreExt,
    CBLocationGameOverExt,
    CBLocationLeaderBoardExt,
    CBLocationSettingsExt,
    CBLocationQuitExt,
    CBLocationDefaultExt
};

typedef NS_ENUM(NSUInteger, DelegateType) {
    CBDidDisplayInterstitial = 201,
    CBDidCacheInterstitial = 202,
    CBDidFailToLoadInterstitial = 203,
    CBDidDismissInterstitial = 204,
    CBDidCloseInterstitial = 205,
    CBDidClickInterstitial = 206,
    CBDidDisplayMoreApps = 207,
    CBDidCacheMoreApps = 208,
    CBDidFailToLoadMoreApps = 209,
    CBDidDismissMoreApps = 210,
    CBDidCloseMoreApps = 211,
    CBDidClickMoreApps = 212,
    CBDidDisplayRewardedVideo = 213,
    CBDidCacheRewardedVideo = 214,
    CBDidFailToLoadRewardedVideo = 215,
    CBDidDismissRewardedVideo = 216,
    CBDidCloseRewardedVideo = 217,
    CBDidClickRewardedVideo = 218,
    CBDidCompleteRewardedVideo = 219,
    CBDidInitialize = 220,
    CBDidFailToInitialize = 221
};


// MARK: Helper Methods

- (NSString *) charToNSString:(char *)text {
    return [NSString stringWithFormat:@"%s", text];
}

- (char *) charFromNSString:(NSString *)text {
    return (char *)[text UTF8String];
}

- (CBLocation) getLocationConstant:(NSUInteger)location {
    switch (location) {
        case CBLocationStartupExt:
            return CBLocationStartup;
        case CBLocationHomeScreenExt:
            return CBLocationHomeScreen;
        case CBLocationMainMenuExt:
            return CBLocationMainMenu;
        case CBLocationGameScreenExt:
            return CBLocationGameScreen;
        case CBLocationAchievementsExt:
            return CBLocationAchievements;
        case CBLocationQuestsExt:
            return CBLocationQuests;
        case CBLocationPauseExt:
            return CBLocationPause;
        case CBLocationLevelStartExt:
            return CBLocationLevelStart;
        case CBLocationLevelCompleteExt:
            return CBLocationLevelComplete;
        case CBLocationTurnCompleteExt:
            return CBLocationTurnComplete;
        case CBLocationIAPStoreExt:
            return CBLocationIAPStore;
        case CBLocationItemStoreExt:
            return CBLocationItemStore;
        case CBLocationGameOverExt:
            return CBLocationGameOver;
        case CBLocationLeaderBoardExt:
            return CBLocationLeaderBoard;
        case CBLocationSettingsExt:
            return CBLocationSettings;
        case CBLocationQuitExt:
            return CBLocationQuit;

        default:
            return CBLocationDefault;
    }
}

- (double) getLocationDoubleConstant:(CBLocation)location {
    if ([location isEqualToString:CBLocationStartup]) {
        return CBLocationStartupExt;
    } else if ([location isEqualToString:CBLocationHomeScreen]) {
        return CBLocationHomeScreenExt;
    } else if ([location isEqualToString:CBLocationMainMenu]) {
        return CBLocationMainMenuExt;
    } else if ([location isEqualToString:CBLocationGameScreen]) {
        return CBLocationGameScreenExt;
    } else if ([location isEqualToString:CBLocationAchievements]) {
        return CBLocationAchievementsExt;
    } else if ([location isEqualToString:CBLocationQuests]) {
        return CBLocationQuestsExt;
    } else if ([location isEqualToString:CBLocationPause]) {
        return CBLocationPauseExt;
    } else if ([location isEqualToString:CBLocationLevelStart]) {
        return CBLocationLevelStartExt;
    } else if ([location isEqualToString:CBLocationLevelComplete]) {
        return CBLocationLevelCompleteExt;
    } else if ([location isEqualToString:CBLocationTurnComplete]) {
        return CBLocationTurnCompleteExt;
    } else if ([location isEqualToString:CBLocationIAPStore]) {
        return CBLocationIAPStoreExt;
    } else if ([location isEqualToString:CBLocationItemStore]) {
        return CBLocationItemStoreExt;
    } else if ([location isEqualToString:CBLocationGameOver]) {
        return CBLocationGameOverExt;
    } else if ([location isEqualToString:CBLocationLeaderBoard]) {
        return CBLocationLeaderBoardExt;
    } else if ([location isEqualToString:CBLocationSettings]) {
        return CBLocationSettingsExt;
    } else if ([location isEqualToString:CBLocationQuit]) {
        return CBLocationQuitExt;
    } else {
        return CBLocationDefaultExt;
    }
}

- (BOOL)isNetworkAvailable {
    CFNetDiagnosticRef dReference;
    dReference = CFNetDiagnosticCreateWithURL (NULL, (__bridge CFURLRef)[NSURL URLWithString:@"www.apple.com"]);
    
    CFNetDiagnosticStatus status;
    status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
    
    CFRelease (dReference);
    
    if ( status == kCFNetDiagnosticConnectionUp ) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)checkInternetConnection:(NSUInteger)event {
    if (![self isNetworkAvailable]) {
        int dsMapIndex = CreateDsMap( 0 );
        F_DsMapAdd_Internal(dsMapIndex, (char *)"type", event);
        //F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
        F_DsMapAdd_Internal(dsMapIndex, (char *)"error", CBLoadErrorNetworkFailure);
        CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
        return false;
    }
    return true;
}

// MARK: GameMaker Methods

- (void) initSDK:(char *)appId Signature:(char *)appSignature {
    NSLog(@"Chartboost Init");
    [self checkInternetConnection:CBDidFailToInitialize];
    [Chartboost startWithAppId:[self charToNSString:appId]
                  appSignature:[self charToNSString:appSignature]
                      delegate:self];
}

- (void) showInterstitial:(double)location {
    NSLog(@"Chartboost Show Interstitial");
    if ([self checkInternetConnection:CBDidFailToLoadInterstitial]) {
        [Chartboost showInterstitial:[self getLocationConstant:location]];
    }
}

- (void) cacheInterstitial:(double)location {
    NSLog(@"Chartboost Cache Interstitial");
    if ([self checkInternetConnection:CBDidFailToLoadInterstitial]) {
        [Chartboost cacheInterstitial:[self getLocationConstant:location]];
    }
}

- (double) hasInterstitial:(double)location {
    NSLog(@"Chartboost Has Interstitial");
    return [Chartboost hasInterstitial:[self getLocationConstant:location]];
}

- (void) showMoreApps:(double)location {
    NSLog(@"Chartboost Show More Apps");
    if ([self checkInternetConnection:CBDidFailToLoadMoreApps]) {
        [Chartboost showMoreApps:[self getLocationConstant:location]];
    }
}

- (void) cacheMoreApps:(double)location {
    NSLog(@"Chartboost Cache More Apps");
    if ([self checkInternetConnection:CBDidFailToLoadMoreApps]) {
        [Chartboost cacheMoreApps:[self getLocationConstant:location]];
    }
}

- (double) hasMoreApps:(double)location {
    NSLog(@"Chartboost Has More Apps");
    return [Chartboost hasMoreApps:[self getLocationConstant:location]];
}

- (void) showRewardedVideo:(double)location {
    NSLog(@"Chartboost Show Rewarded Video");
    if ([self checkInternetConnection:CBDidFailToLoadRewardedVideo]) {
        [Chartboost showRewardedVideo:[self getLocationConstant:location]];
    }
}

- (void) cacheRewardedVideo:(double)location {
    NSLog(@"Chartboost Cache Rewarded Video");
    if ([self checkInternetConnection:CBDidFailToLoadRewardedVideo]) {
        [Chartboost cacheRewardedVideo:[self getLocationConstant:location]];
    }
}

- (double) hasRewardedVideo:(double)location {
    NSLog(@"Chartboost Has Rewarded Video");
    return [Chartboost hasRewardedVideo:[self getLocationConstant:location]];
}

- (void) setAutoCacheAds:(double)enable {
    // enable = 0: false, Chartboost won't cache Ads immediately following the successful display of a showInterstitial() call
    // enable = 1: true, Chartboost will cache Ads immediately following the successful display of a showInterstitial() call
    NSLog(@"Chartboost Set Auto Cache Ads");
    [Chartboost setAutoCacheAds:enable];
}

- (double) getAutoCacheAds {
    // enable = 0: false, Chartboost won't cache Ads immediately following the successful display of a showInterstitial() call
    // enable = 1: true, Chartboost will cache Ads immediately following the successful display of a showInterstitial() call
    NSLog(@"Chartboost Get Auto Cache Ads");
    return [Chartboost getAutoCacheAds];
}

- (char *) getSDKVersion {
    return [self charFromNSString:[Chartboost getSDKVersion]];
}

- (double) hasInternetConnection {
    return [self isNetworkAvailable] ? 1 : 0;
}

// MARK: -- DELEGATES --

// MARK: Interstitial Methods

- (void) didDisplayInterstitial:(CBLocation)location {
    NSLog(@"Chartboost Did Display Interstitial");
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidDisplayInterstitial);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didCacheInterstitial:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidCacheInterstitial);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didFailToLoadInterstitial:(CBLocation)location withError:(CBLoadError)error {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidFailToLoadInterstitial);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"error", error);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didDismissInterstitial:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidDismissInterstitial);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didCloseInterstitial:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidCloseInterstitial);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didClickInterstitial:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidClickInterstitial);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

// MARK: More Apps Methods

- (void) didDisplayMoreApps:(CBLocation)location {
    NSLog(@"Chartboost Did Display More Apps");
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidDisplayMoreApps);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didCacheMoreApps:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidCacheMoreApps);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didFailToLoadMoreApps:(CBLocation)location withError:(CBLoadError)error {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidFailToLoadMoreApps);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"error", error);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didDismissMoreApps:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidDismissMoreApps);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didCloseMoreApps:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidCloseMoreApps);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didClickMoreApps:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidClickMoreApps);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

// MARK: Rewarded Video Methods

- (void) didDisplayRewardedVideo:(CBLocation)location {
    NSLog(@"Chartboost Did Display Rewarded Video");
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidDisplayRewardedVideo);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didCacheRewardedVideo:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidCacheRewardedVideo);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didFailToLoadRewardedVideo:(CBLocation)location withError:(CBLoadError)error {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidFailToLoadRewardedVideo);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"error", error);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didDismissRewardedVideo:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidDismissRewardedVideo);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didCloseRewardedVideo:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidCloseRewardedVideo);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didClickRewardedVideo:(CBLocation)location {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidClickRewardedVideo);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didCompleteRewardedVideo:(CBLocation)location withReward:(int)reward {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidCompleteRewardedVideo);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"location", [self getLocationDoubleConstant:location]);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"reward", reward);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

- (void) didInitialize:(BOOL)status {
    int dsMapIndex = CreateDsMap( 0 );
    F_DsMapAdd_Internal(dsMapIndex, (char *)"type", CBDidInitialize);
    F_DsMapAdd_Internal(dsMapIndex, (char *)"status", status);
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

@end
