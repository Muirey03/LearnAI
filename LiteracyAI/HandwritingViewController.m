//
//  SpellingViewController.m
//  LiteracyAI
//
//  Created by Tommy Muir on 06/01/2021.
//

#import "HandwritingViewController.h"
#import "NetworkManager.h"
#import "ConfettiViewController.h"
#import "IncorrectViewController.h"

@interface HandwritingViewController ()

@end

@implementation HandwritingViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self shuffleAlphabet];
    [self chooseLetter];
}

- (void)shuffleAlphabet {
    _letterIndex = 0;
    
    const char* alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    char* shuffled = malloc(strlen(alphabet) + 1);
    shuffled[strlen(alphabet)] = '\0';
    
    NSMutableArray* remainingIndexes = [NSMutableArray array];
    for (NSUInteger i = 0; i < strlen(alphabet); i++) {
        [remainingIndexes addObject:@(i)];
    }
    
    for (NSUInteger i = 0; i < strlen(alphabet); i++) {
        NSUInteger indexesIndex = arc4random_uniform((unsigned)remainingIndexes.count);
        NSUInteger index = [remainingIndexes[indexesIndex] unsignedIntegerValue];
        [remainingIndexes removeObjectAtIndex:indexesIndex];
        shuffled[i] = alphabet[index];
    }
    
    _shuffledAlphabet = [NSString stringWithUTF8String:shuffled];
    
    free(shuffled);
}

- (void)chooseLetter {
    [_canvasView clear];
    
    _currentLetter = [_shuffledAlphabet characterAtIndex:(_letterIndex++ % _shuffledAlphabet.length)];
    
    NSDictionary* attrib = @{NSStrokeColorAttributeName : UIColor.blackColor, NSForegroundColorAttributeName : UIColor.clearColor, NSStrokeWidthAttributeName : @-2};
    NSAttributedString* str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%c", _currentLetter] attributes:attrib];
    _label.attributedText = str;
}

- (void)canvasButtonPressed:(CanvasButtonType)button {
    if (button == CanvasButtonTypeClear) {
        [_canvasView clear];
    } else {
        UIImage* img = [_canvasView captureImage];
        if (img) {
            char letter = [[NetworkManager sharedInstance] evaluateLetter:img];
            if (letter == _currentLetter)
                [self correctDrawing];
            else
                [self incorrectDrawing];
        }
    }
}

- (void)incorrectDrawing {
    IncorrectViewController* crossVC = [IncorrectViewController new];
    [self presentViewController:crossVC animated:NO completion:nil];
}

- (void)correctDrawing { 
    ConfettiViewController* confetti = [ConfettiViewController new];
    [self presentViewController:confetti animated:NO completion:nil];
    [confetti beginAnimationWithCompletion:^{
        [self chooseLetter];
    }];
}

@end
