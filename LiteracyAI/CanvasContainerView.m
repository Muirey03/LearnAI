//
//  CanvasContainerView.m
//  LiteracyAI
//
//  Created by Tommy Muir on 04/01/2021.
//

#import "CanvasContainerView.h"
#import "NetworkManager.h"

@implementation CanvasContainerView

-(instancetype)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        CanvasView* canvas = [[CanvasView alloc] initWithFrame:CGRectZero];
        _canvasView = canvas;
        [self addSubview:canvas];
        
        const CGFloat stackViewHeight = 80;
        
        canvas.translatesAutoresizingMaskIntoConstraints = NO;
        [canvas.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [canvas.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        [canvas.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [canvas.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-stackViewHeight].active = YES;
        
        CanvasButtonsView* buttons = [[CanvasButtonsView alloc] initWithFrame:CGRectZero];
        buttons.delegate = self;
        [self addSubview:buttons];
        
        buttons.translatesAutoresizingMaskIntoConstraints = NO;
        [buttons.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [buttons.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        [buttons.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [buttons.topAnchor constraintEqualToAnchor:canvas.bottomAnchor].active = YES;
        
        [self resetCanvas];
    }
    return self;
}

- (void)resetCanvas {
    _state = CanvasStateWaiting;
    _currentChar = '\0';
    [_canvasView clear];
}

- (void)canvasButtonPressed:(CanvasButtonType)button {
    switch (button) {
        case CanvasButtonTypeSubmit:
            [self submit];
            break;
        case CanvasButtonTypeClear:
            [self resetCanvas];
            break;
    }
}

- (void)submit {
    switch (_state) {
        case CanvasStateWaiting: {
            UIImage* img = [_canvasView captureImage];
            if (img) {
                char letter;
                if (_canvasType == CanvasTypeLetters) {
                    letter = [[NetworkManager sharedInstance] evaluateLetter:img];
                } else {
                    letter = [[NetworkManager sharedInstance] evaluateNumber:img] + '0';
                }
                [_canvasView setCharacterLabel:letter];
                _currentChar = letter;
                _state = CanvasStateReady;
            }
            break;
        }
        case CanvasStateReady: {
            if (_canvasType == CanvasTypeLetters)
                [_delegate canvasDidSubmitLetter:_currentChar];
            else
                [_delegate canvasDidSubmitNumber:_currentChar - '0'];
            [self resetCanvas];
            break;
        }
    }
}

@end
