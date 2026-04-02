#import "RNTSplashScreen.h"
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>
#import <React/RCTUtils.h>

@implementation RNTSplashScreen

static UIView *_loadingView = nil;
static UIWindow *_splashWindow = nil;

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

// ==========================================
// 核心逻辑方法 (供原生调用)
// ==========================================

+ (void)show:(UIView *)view storyboardName:(NSString *)storyboardName {
    if (_loadingView) {
        return;
    }

    // 加载闪屏
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *splashVC = [storyboard instantiateInitialViewController];
    _loadingView = splashVC.view;

    // ✅ 关键：创建顶层 Window 显示闪屏
    _splashWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _splashWindow.windowLevel = UIWindowLevelAlert; // 最顶层
    _splashWindow.rootViewController = splashVC;
    _splashWindow.hidden = NO;
}

+ (void)hide {
    if (!_loadingView || !_splashWindow) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        _splashWindow.hidden = YES;
        _splashWindow = nil;
        _loadingView = nil;
    });
}

#pragma mark - Module Exports

RCT_EXPORT_MODULE(RNTSplashScreen);

RCT_EXPORT_METHOD(hide) {
    [self.class hide];
}

@end
