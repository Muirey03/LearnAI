//
//  HangmanViewController.h
//  LiteracyAI
//
//  Created by Tommy Muir on 24/11/2020.
//

#import <UIKit/UIKit.h>
#import "CanvasContainerView.h"
#import "Chalkboard.h"

NS_ASSUME_NONNULL_BEGIN

@interface HangmanViewController : UIViewController <CanvasViewDelegate>
@property (weak, nonatomic) IBOutlet Chalkboard *chalkboard;
@property (strong, nonatomic) NSMutableArray* words;
@property (nonatomic, assign) NSUInteger wordIndex;
@property (strong, nonatomic) NSString* wordToGuess;
@property (strong, nonatomic) NSMutableString* guessedWord;
@property (assign, nonatomic) NSUInteger lives;
- (void)fetchWords;
-(void)chooseWord;
-(NSString*)hyphonatedWord:(NSString*)word;
-(void)guessCharacter:(char)c;
-(void)incorrectGuess:(char)c;
-(void)wordCompleted;
@end

NS_ASSUME_NONNULL_END
