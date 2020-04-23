#import "RNTSplashScreen.h"
#import <React/RCTBridge.h>

@implementation RNTSplashScreen

static BOOL hasJavaScriptErrorObserver = NO;

static BOOL isShowing = NO;

RCT_EXPORT_MODULE(RNTSplashScreen);

// 显示默认开屏
+ (void)show {
    
    if (isShowing) {
        return;
    }
    
    isShowing = YES;
    
    if (!hasJavaScriptErrorObserver) {
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onJavaScriptError:) name:RCTJavaScriptDidFailToLoadNotification
            object:nil
        ];

        hasJavaScriptErrorObserver = YES;
        
    }

    while (isShowing) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
}

+ (void)hide {
    
    if (!isShowing) {
        return;
    }
    
    isShowing = NO;
    
    if (hasJavaScriptErrorObserver) {
        
        [NSNotificationCenter.defaultCenter removeObserver:self name:RCTJavaScriptDidFailToLoadNotification
            object:nil
        ];
        
        hasJavaScriptErrorObserver = NO;
        
    }
    
}

+ (void)onJavaScriptError:(NSNotification *)notification {
    [RNTSplashScreen hide];
}

RCT_EXPORT_METHOD(hide) {
    [RNTSplashScreen hide];
}

@end
