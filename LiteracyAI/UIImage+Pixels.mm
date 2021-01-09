#import "UIImage+Pixels.h"

@implementation UIImage (Pixels)
-(void)iteratePixels:(BOOL(^)(NSUInteger, NSUInteger, uint8_t))iterator
{
	CGImageRef imageRef = self.CGImage;
	NSUInteger width = CGImageGetWidth(imageRef);
	NSUInteger height = CGImageGetHeight(imageRef);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	uint8_t* data = (uint8_t*)malloc(width * height);
	CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width, colorSpace, 0);
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);

	for (NSUInteger y = 0; y < height; y++)
	{
		BOOL shouldBreak = NO;
		for (NSUInteger x = 0; x < width; x++)
		{
			if (!iterator(x, y, data[y * width + x]))
			{
				shouldBreak = YES;
				break;
			}
		}
		if (shouldBreak) break;
	}
	
	free((void*)data);
}
@end
