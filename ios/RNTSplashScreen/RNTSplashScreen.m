#import "RNTSplashScreen.h"
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>

@implementation RNTSplashScreen

static BOOL hasJavaScriptDidFailToLoadObserver = NO;
static BOOL hasContentDidAppearObserver = YES;
static BOOL isShowing = NO;

static RCTRootView *rootView = nil;

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_queue_create("com.github.reactnativehero.splash_screen", DISPATCH_QUEUE_SERIAL);
}

+ (void)show:(UIView *)view storyboardName:(NSString *)storyboardName {
    
    if (!hasJavaScriptDidFailToLoadObserver) {
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(onJavaScriptDidFailToLoad:)
                                                   name:RCTJavaScriptDidFailToLoadNotification
                                                 object:nil
        ];

        hasJavaScriptDidFailToLoadObserver = YES;
        
    }
    
    if (hasContentDidAppearObserver) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:view
                                                      name:RCTContentDidAppearNotification
                                                    object:view];
        
        hasContentDidAppearObserver = NO;
        
    }
    
    if (isShowing) {
        return;
    }
    
    rootView = (RCTRootView *)view;
    
    [self showLoadingView:storyboardName];
    isShowing = YES;
    
}

+ (void)hide {
    
    if (!isShowing) {
        return;
    }
    
    [self hideLoadingView];
    isShowing = NO;
    
    if (hasJavaScriptDidFailToLoadObserver) {
        
        [NSNotificationCenter.defaultCenter removeObserver:self
                                                   name:RCTJavaScriptDidFailToLoadNotification
                                                 object:nil
        ];

        hasJavaScriptDidFailToLoadObserver = NO;
        
    }
    
}

+ (void)showLoadingView:(NSString *)storyboardName {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UIView *loadingView = [[storyboard instantiateInitialViewController] view];
        [rootView setLoadingView:loadingView];
    });
}

+ (void)hideLoadingView {
    dispatch_async(dispatch_get_main_queue(), ^{
        rootView.loadingView.hidden = YES;
        [rootView.loadingView removeFromSuperview];
        rootView.loadingView = nil;
    });
}

+ (void)onJavaScriptDidFailToLoad:(NSNotification *)notification {
    [RNTSplashScreen hide];
}

RCT_EXPORT_MODULE(RNTSplashScreen);

RCT_EXPORT_METHOD(hide) {
    [RNTSplashScreen hide];
}

@end
