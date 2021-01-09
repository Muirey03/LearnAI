//
//  CanvasButtonsView.m
//  LiteracyAI
//
//  Created by Tommy Muir on 06/01/2021.
//

#import "CanvasButtonsView.h"

@implementation CanvasButtonsView

- (void)sharedInit {
    const CGFloat btnCorners = 15;
    
    UIStackView* stack = [[UIStackView alloc] initWithFrame:CGRectZero];
    stack.spacing = 8;
    stack.layoutMarginsRelativeArrangement = YES;
    stack.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(8, 8, 8, 8);
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    [self addSubview:stack];
    
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [stack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [stack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [stack.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [stack.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    UIButton* submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submit.titleLabel.font = [UIFont systemFontOfSize:15];
    submit.clipsToBounds = YES;
    submit.layer.cornerRadius = btnCorners;
    submit.backgroundColor = UIColor.systemGreenColor;
    submit.tintColor = UIColor.whiteColor;
    [submit setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [submit setTitle:@"Submit" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:submit];
    
    UIButton* clear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clear.titleLabel.font = [UIFont systemFontOfSize:15];
    clear.clipsToBounds = YES;
    clear.layer.cornerRadius = btnCorners;
    clear.backgroundColor = UIColor.systemRedColor;
    [clear setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [clear setTitle:@"Clear" forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:clear];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self sharedInit];
    }
    return self;
}

- (void)submit:(UIButton*)btn {
    [_delegate canvasButtonPressed:CanvasButtonTypeSubmit];
}

- (void)clear:(UIButton*)btn {
    [_delegate canvasButtonPressed:CanvasButtonTypeClear];
}

@end
