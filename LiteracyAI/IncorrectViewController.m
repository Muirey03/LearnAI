//
//  IncorrectViewController.m
//  LiteracyAI
//
//  Created by Tommy Muir on 08/01/2021.
//

#import "IncorrectViewController.h"

@interface IncorrectViewController ()

@end

@implementation IncorrectViewController

-(instancetype)init {
    if ((self = [super init])) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    _label = lbl;
    lbl.alpha = 0;
    lbl.text = @"❌";
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:250];
    [self.view addSubview:lbl];
    
    lbl.translatesAutoresizingMaskIntoConstraints = NO;
    [lbl.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [lbl.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [lbl.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [lbl.heightAnchor constraintEqualToAnchor:lbl.widthAnchor].active = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    _label.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.75 options:UIViewAnimationOptionCurveLinear animations:^{
        self->_label.transform = CGAffineTransformIdentity;
        self->_label.alpha = 1;
    } completion:^(BOOL complete){
        [UIView animateWithDuration:0.2 animations:^{
            self->_label.transform = CGAffineTransformMakeScale(0.5, 0.5);
            self->_label.alpha = 0;
        } completion:^(BOOL finished){
            [self dismissViewControllerAnimated:NO completion:nil];
            if (self->_completion)
                self->_completion();
        }];
    }];
}

@end
