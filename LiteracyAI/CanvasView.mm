#import "CanvasView.h"

@implementation CanvasView

- (void)sharedInit {
    _lines = [NSMutableArray array];
    self.backgroundColor = UIColor.whiteColor;
    
    //setup gesture:
    _gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
    [self addGestureRecognizer:_gesture];
    
    //create character label:
    UILabel* charLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    charLbl.textColor = UIColor.blackColor;
    charLbl.userInteractionEnabled = NO;
    CGFloat fontSize = 0.625 * [UIScreen mainScreen].bounds.size.width;
    charLbl.font = [UIFont systemFontOfSize:fontSize];
    charLbl.textAlignment = NSTextAlignmentCenter;
    _charLbl = charLbl;
    [self addSubview:charLbl];
    
    charLbl.translatesAutoresizingMaskIntoConstraints = NO;
    [charLbl.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [charLbl.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [charLbl.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [charLbl.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
	if ((self = [super initWithCoder:coder]))
	{
        [self sharedInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self sharedInit];
    }
    return self;
}

-(void)clear
{
    _charLbl.text = @"";
    [_lines removeAllObjects];
    [self setNeedsDisplay];
}

-(void)drag:(UIPanGestureRecognizer*)gesture
{
	CGPoint point;
	switch (gesture.state)
	{
		case UIGestureRecognizerStateBegan:
			[_lines addObject:[NSMutableArray array]];
		case UIGestureRecognizerStateChanged:
			point = [gesture locationInView:self];
			[_lines.lastObject addObject:@(point)];
			[self setNeedsDisplay];
			break;
		default:
			break;
	}
}

-(void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 25.);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetInterpolationQuality(context, kCGInterpolationHigh);

	for (NSMutableArray<NSValue*>* line in _lines)
	{
		for (NSUInteger i = 0; i < line.count; i++)
		{
			CGPoint point = [line[i] CGPointValue];
			if (i == 0)
				CGContextMoveToPoint(context, point.x, point.y);
			CGContextAddLineToPoint(context, point.x, point.y);
		}
	}

	CGContextStrokePath(context);
}

-(UIImage*)captureImage
{
    if (_lines.count == 0) {
        return nil;
    }
    CGSize size = self.bounds.size;
	UIGraphicsBeginImageContextWithOptions(size, YES, 1.);
	[self drawViewHierarchyInRect:CGRectMake(0, 0, size.width, size.height) afterScreenUpdates:NO];
	UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setCharacterLabel:(char)c {
    [self clear];
    if (c != '\0') {
        _charLbl.text = [NSString stringWithFormat:@"%c", c];
    }
}

@end
