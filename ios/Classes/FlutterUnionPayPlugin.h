#import <Flutter/Flutter.h>
static FlutterBasicMessageChannel *messageChannel;
@interface FlutterUnionPayPlugin : NSObject<FlutterPlugin>
@property (strong, nonatomic) UIViewController *viewController;
@end
