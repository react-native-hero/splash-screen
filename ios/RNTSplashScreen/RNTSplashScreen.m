#import "RNTSplashScreen.h"
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>
#import <React/RCTUtils.h>

#if RCT_NEW_ARCH_ENABLED
#import <React/RCTSurfaceHostingProxyRootView.h>
#import <React/RCTSurfaceHostingView.h>
#endif

@implementation RNTSplashScreen

#if RCT_NEW_ARCH_ENABLED
static RCTSurfaceHostingProxyRootView *_rootView = nil;
#else
static UIView *_rootView = nil;
#endif

static UIView *_loadingView = nil;
static BOOL _fade = NO;

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

// ==========================================
// 核心逻辑方法 (供原生调用)
// ==========================================

+ (void)show:(UIView *)view storyboardName:(NSString *)storyboardName {
    if (!_rootView && view) {
#ifdef RCT_NEW_ARCH_ENABLED
        _rootView = (RCTSurfaceHostingProxyRootView *)view;
#else
        _rootView = (RCTRootView *)view;
#endif

        // 设置加载视图
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        _loadingView = [[storyboard instantiateInitialViewController] view];

        if (_loadingView) {
            _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _loadingView.frame = _rootView.bounds;
            _loadingView.center = (CGPoint){CGRectGetMidX(_rootView.bounds), CGRectGetMidY(_rootView.bounds)};
            _loadingView.hidden = NO;

#if RCT_NEW_ARCH_ENABLED
            [_rootView disableActivityIndicatorAutoHide:YES];
            [_rootView setLoadingView:_loadingView];
#else
            [_rootView addSubview:_loadingView];
#endif
        }
    }
}

+ (void)hide {
    // 如果没有加载视图或已经隐藏，直接返回
    if (!_loadingView || _loadingView.hidden) {
        return;
    }

    if (_fade) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:_rootView
                              duration:0.250
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                _loadingView.hidden = YES;
            }
                            completion:^(__unused BOOL finished) {
                                [_loadingView removeFromSuperview];
                                _loadingView = nil;
                            }];
        });
    } else {
        _loadingView.hidden = YES;
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
}

#pragma mark - Module Exports

RCT_EXPORT_MODULE(RNTSplashScreen);

#if RCT_NEW_ARCH_ENABLED

// 新架构导出
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
    return std::make_shared<facebook::react::NativeRNTSplashScreenSpecJSI>(params);
}

// 新架构下的 hide 方法：无参数，无 Promise
- (void)hide {
    [self.class hide];
}

- (nonnull NSNumber *)isVisible {
    return @(_loadingView != nil && !_loadingView.hidden);
}

#else

// 旧架构导出
// 旧架构下的 hide 方法：无参数，无 Promise
RCT_EXPORT_METHOD(hide) {
    [self.class hide];
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(isVisible) {
    return @(_loadingView != nil && !_loadingView.hidden);
}

#endif

@end
