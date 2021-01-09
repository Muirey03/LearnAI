//
//  ConfettiViewController.m
//  LiteracyAI
//
//  Created by Tommy Muir on 28/12/2020.
//

#import "ConfettiViewController.h"

@interface ConfettiViewController ()

@end

@implementation ConfettiViewController

-(instancetype)init {
    if ((self = [super init])) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)loadView {
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgView.backgroundColor = UIColor.clearColor;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imgView;
}

- (void)beginAnimationWithCompletion:(void (^)(void))completion {
    UIImageView* imgView = (UIImageView*)self.view;
    
    const CGFloat duration = 2.;
    NSMutableArray<UIImage*>* images = [[UIImage animatedImageNamed:@"confetti" duration:duration].images mutableCopy];
    NSInteger frameCount = images.count;
    CGFloat frameDuration = duration / frameCount;
    UIImage* lastFrame = images.lastObject;
    
    const NSInteger extraFrameCount = 10;
    for (NSInteger i = 0; i < extraFrameCount; i++) {
        [images addObject:lastFrame];
    }
    
    imgView.image = lastFrame;
    imgView.animationImages = images;
    imgView.animationDuration = duration + (frameDuration * extraFrameCount);
    imgView.animationRepeatCount = 0;
    [imgView startAnimating];
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
        completion();
    });
}

@end
