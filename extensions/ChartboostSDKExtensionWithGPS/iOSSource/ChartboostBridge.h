//
//  ChartboostBridge.h
//  Chartboost_Example
//
//  Created by Josep Gonzalez Fernandez on 27/8/16.
//  Copyright © 2016 YoYo Games Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Chartboost.h>

@interface ChartboostBridge : NSObject <ChartboostDelegate>
{
}

- (void) initSDK:(char *)appId Signature:(char *)signature;
- (void) showInterstitial:(double)location;
- (void) cacheInterstitial:(double)location;
- (double) hasInterstitial:(double)location;
- (void) showMoreApps:(double)location;
- (void) cacheMoreApps:(double)location;
- (double) hasMoreApps:(double)location;
- (void) showRewardedVideo:(double)location;
- (void) cacheRewardedVideo:(double)location;
- (double) hasRewardedVideo:(double)location;
- (void) setAutoCacheAds:(double)enable;
- (double) getAutoCacheAds;
- (char *) getSDKVersion;
- (double) hasInternetConnection;
@end
