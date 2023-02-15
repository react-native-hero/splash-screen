#import <React/RCTBridgeModule.h>

@interface RNTSplashScreen : NSObject <RCTBridgeModule>

+ (void)show:(UIView *)rootView storyboardName:(NSString *)storyboardName;
+ (void)hide;

@end
