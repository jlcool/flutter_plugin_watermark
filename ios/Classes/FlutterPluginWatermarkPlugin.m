#import "FlutterPluginWatermarkPlugin.h"
#import <UIKit/UIKit.h>

@implementation FlutterPluginWatermarkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_plugin_watermark"
            binaryMessenger:[registrar messenger]];
  FlutterPluginWatermarkPlugin* instance = [[FlutterPluginWatermarkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"watermark" isEqualToString:call.method]) {
      [self watermark:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}
- (void) watermark:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString *imagePath =call.arguments[@"imagePath"];
    NSString *mark =call.arguments[@"mark"];
    NSString *fontName =call.arguments[@"fontName"];
    int fontSize=[call.arguments[@"fontSize"] intValue];
    int left=[call.arguments[@"left"] intValue];
    int bottom=[call.arguments[@"bottom"] intValue];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    int w = img.size.width;
    int h = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    [[UIColor redColor] set];
    [img drawInRect:CGRectMake(0, 0, w, h)];
    
    UIFont *helveticaFont = [UIFont fontWithName:fontName size:w/fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;

    NSDictionary *attributes = @{ NSFontAttributeName:helveticaFont,
                                  NSParagraphStyleAttributeName:paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor whiteColor]};
    CGSize size = [mark sizeWithAttributes:attributes];
    [mark drawInRect:CGRectMake(left, h-bottom-size.height, size.width,
                                size.height) withAttributes:attributes ];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(aimg);
    result(imageData);
}
@end
