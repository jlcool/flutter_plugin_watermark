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
    FlutterStandardTypedData * imageByte=call.arguments[@"imageByte"];
    UIImage *img;
    if(imageByte==NULL){
        img = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        img = [UIImage imageWithData: imageByte.data];
    }
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
    
    CGFloat desiredWidth = w-(left*2); // adjust accordingly
    CGRect neededRect = [mark
                            boundingRectWithSize:CGSizeMake(desiredWidth, CGFLOAT_MAX)
                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                            attributes:attributes context:nil];
    
    [mark drawInRect:CGRectMake(left, h-bottom-neededRect.size.height, w-(left*2),
                                neededRect.size.height) withAttributes:attributes ];
    
    CGContextRef contextOther = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextOther, 1, (CGFloat)199.0/255.0, (CGFloat)50.0/255.0, 1.0);
    CGContextFillRect(contextOther, CGRectMake(left-60, h-bottom-neededRect.size.height, 20, neededRect.size.height));
    CGContextStrokePath(contextOther);
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(aimg,0.9);
    result(imageData);
}
@end
