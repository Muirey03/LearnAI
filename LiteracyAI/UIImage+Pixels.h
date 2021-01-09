#import <UIKit/UIKit.h>

@interface UIImage (Pixels)
-(void)iteratePixels:(BOOL(^)(NSUInteger, NSUInteger, uint8_t))iterator;
@end
