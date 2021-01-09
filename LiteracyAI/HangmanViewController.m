//
//  HangmanViewController.m
//  LiteracyAI
//
//  Created by Tommy Muir on 24/11/2020.
//

#import "HangmanViewController.h"
#import "NetworkManager.h"
#import "ConfettiViewController.h"
#import "IncorrectViewController.h"
#import "Database.h"

#define MAX_LIVES 8

@interface HangmanViewController ()

@end

@implementation HangmanViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchWords];
    [self chooseWord];
}

- (void)fetchWords {
    //words from cehs.unl.edu/documents/secd/aac/vocablists/VLN1.pdf
    NSMutableArray* words = [NSMutableArray array];
    _wordIndex = 0;
    [[Database vendorDB] executeSQL:@"SELECT * FROM Words ORDER BY RANDOM()" withParameters:nil withResults:^(sqlite3_stmt* record, BOOL* stop) {
        [words addObject:@((const char*)sqlite3_column_text(record, 1))];
    }];
    _words = words;
}

-(void)chooseWord {
    _lives = MAX_LIVES;
    
    _wordToGuess = [_words[_wordIndex++ % _words.count] uppercaseString];
    
    _guessedWord = [[self hyphonatedWord:_wordToGuess] mutableCopy];
    [_chalkboard setText:_guessedWord];
    [_chalkboard resetHangman];
}

-(NSString*)hyphonatedWord:(NSString*)word {
    char* cStr = malloc(word.length + 1);
    for (size_t i = 0; i < word.length; i++) {
        cStr[i] = '_';
    }
    cStr[word.length] = '\0';
    NSString* ret = [NSString stringWithUTF8String:cStr];
    free(cStr);
    return ret;
}

-(void)guessCharacter:(char)c {
    BOOL correctCharacter = NO;
    NSString* charStr = [NSString stringWithFormat:@"%c", c];
    for (size_t i = 0; i < _wordToGuess.length; i++) {
        if ([_wordToGuess characterAtIndex:i] == c) {
            [_guessedWord replaceCharactersInRange:NSMakeRange(i, 1) withString:charStr];
            correctCharacter = YES;
        }
    }
    if (correctCharacter) {
        [_chalkboard setText:_guessedWord];
        
        if ([_guessedWord isEqualToString:_wordToGuess]) {
            [self wordCompleted];
        }
    } else {
        [self incorrectGuess:c];
    }
}

- (void)wordCompleted { 
    ConfettiViewController* confetti = [ConfettiViewController new];
    [self presentViewController:confetti animated:NO completion:nil];
    [confetti beginAnimationWithCompletion:^{
        [self chooseWord];
    }];
}

- (void)incorrectGuess:(char)c {
    //draw limb
    NSInteger i = MAX_LIVES - _lives;
    CGSize hangmanSize = _chalkboard.hangmanView.frame.size;
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    CGFloat headRadius = 0.075 * hangmanSize.height;
    CGFloat ropeX = 0.6 * hangmanSize.width;
    CGFloat nooseHeight = 0.1 * hangmanSize.height;
    CGFloat bodyHeight = 0.3 * hangmanSize.height;
    CGFloat armWidth = 0.2 * hangmanSize.width;
    
    switch (i) {
        case 0: //base
            [path moveToPoint:CGPointMake(0, hangmanSize.height - 20)];
            [path addLineToPoint:CGPointMake(hangmanSize.width, hangmanSize.height - 20)];
            break;
        case 1: //pole
            [path moveToPoint:CGPointMake(0, hangmanSize.height - 20)];
            [path addLineToPoint:CGPointMake(0, 20)];
            break;
        case 2: //top
            [path moveToPoint:CGPointMake(0, 20)];
            [path addLineToPoint:CGPointMake(ropeX, 20)];
            break;
        case 3: //noose
            [path moveToPoint:CGPointMake(ropeX, 20)];
            [path addLineToPoint:CGPointMake(ropeX, 20 + nooseHeight)];
            break;
        case 4: //head
            [path moveToPoint:CGPointMake(ropeX, 20 + nooseHeight)];
            [path addArcWithCenter:CGPointMake(ropeX, 20 + nooseHeight + headRadius) radius:headRadius startAngle:-M_PI/2 endAngle:2 * M_PI clockwise:YES];
            break;
        case 5: //body
            [path moveToPoint:CGPointMake(ropeX, 20 + nooseHeight + 2 * headRadius)];
            [path addLineToPoint:CGPointMake(ropeX, 20 + nooseHeight + 2 * headRadius + bodyHeight)];
            break;
        case 6: //arms
            [path moveToPoint:CGPointMake(ropeX - armWidth, 20 + nooseHeight + 2 * headRadius + 0.25 * bodyHeight)];
            [path addLineToPoint:CGPointMake(ropeX + armWidth, 20 + nooseHeight + 2 * headRadius + 0.25 * bodyHeight)];
            break;
        case 7: //legs
            [path moveToPoint:CGPointMake(ropeX, 20 + nooseHeight + 2 * headRadius + bodyHeight)];
            [path addLineToPoint:CGPointMake(ropeX - armWidth, 20 + nooseHeight + 2 * headRadius + bodyHeight + armWidth)];
            [path moveToPoint:CGPointMake(ropeX, 20 + nooseHeight + 2 * headRadius + bodyHeight)];
            [path addLineToPoint:CGPointMake(ropeX + armWidth, 20 + nooseHeight + 2 * headRadius + bodyHeight + armWidth)];
            break;
    }
    [_chalkboard drawHangmanStroke:path.CGPath];
    _lives--;
    
    if (_lives == 0) {
        IncorrectViewController* crossVC = [IncorrectViewController new];
        crossVC.completion = ^{
            [self chooseWord];
        };
        [self presentViewController:crossVC animated:NO completion:nil];
    }
}

- (void)canvasDidSubmitLetter:(char)c {
    [self guessCharacter:c];
}

@end
