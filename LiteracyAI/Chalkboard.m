//
//  Chalkboard.m
//  LiteracyAI
//
//  Created by Tommy Muir on 28/12/2020.
//

#import "Chalkboard.h"

@implementation Chalkboard

-(instancetype)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        _hangmanLayers = [NSMutableArray array];
        
        //make label:
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.translatesAutoresizingMaskIntoConstraints = NO;
        lbl.font = [UIFont fontWithName:@"Chalkduster" size:100];
        lbl.adjustsFontSizeToFitWidth = YES;
        lbl.textColor = UIColor.whiteColor;
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        [lbl.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:25].active = YES;
        [lbl.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-25].active = YES;
        [lbl.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [lbl.heightAnchor constraintEqualToConstant:150].active = YES;
        
        _lbl = lbl;
        
        //make hangman view:
        UIView* hangmanView = [[UIView alloc] initWithFrame:CGRectZero];
        hangmanView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:hangmanView];
        
        [hangmanView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [hangmanView.topAnchor constraintEqualToAnchor:lbl.bottomAnchor].active = YES;
        [hangmanView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [hangmanView.widthAnchor constraintEqualToAnchor:hangmanView.heightAnchor multiplier:0.6].active = YES;
        
        _hangmanView = hangmanView;
    }
    return self;
}

-(void)setText:(NSString*)text {
    NSMutableAttributedString* attText = [[NSMutableAttributedString alloc] initWithString:text];
    [self setAttributedText:attText];
}

-(void)setAttributedText:(NSAttributedString*)text {
    NSMutableAttributedString* attText = [text mutableCopy];
    const CGFloat charSpacing = 10.;
    [attText addAttribute:NSKernAttributeName value:@(charSpacing) range:NSMakeRange(0, text.length)];
    _lbl.attributedText = attText;
}

- (void)drawHangmanStroke:(CGPathRef)path {
    CAShapeLayer* newLayer = [CAShapeLayer new];
    newLayer.fillColor = UIColor.clearColor.CGColor;
    newLayer.strokeColor = UIColor.whiteColor.CGColor;
    newLayer.lineWidth = 10;
    newLayer.lineCap = kCALineCapRound;
    newLayer.lineJoin = kCALineJoinRound;
    newLayer.path = path;
    
    [_hangmanView.layer addSublayer:newLayer];
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.fromValue = @0;
    anim.duration = 0.25;
    [newLayer addAnimation:anim forKey:@"MyAnimation"];
    [_hangmanLayers addObject:newLayer];
}

- (void)resetHangman {
    for (CALayer* shapeLayer in _hangmanLayers) {
        [shapeLayer removeFromSuperlayer];
    }
    [_hangmanLayers removeAllObjects];
}

@end
