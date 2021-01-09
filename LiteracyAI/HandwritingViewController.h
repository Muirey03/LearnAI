//
//  SpellingViewController.h
//  LiteracyAI
//
//  Created by Tommy Muir on 06/01/2021.
//

#import <UIKit/UIKit.h>
#import "CanvasButtonsView.h"
#import "CanvasView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HandwritingViewController : UIViewController<CanvasButtonDelegate>
@property (nonatomic, weak) IBOutlet CanvasView* canvasView;
@property (nonatomic, weak) IBOutlet UILabel* label;
@property (nonatomic, strong) NSString* shuffledAlphabet;
@property (nonatomic, assign) char currentLetter;
@property (nonatomic, assign) NSUInteger letterIndex;
- (void)shuffleAlphabet;
- (void)chooseLetter;
- (void)correctDrawing;
- (void)incorrectDrawing;
@end

NS_ASSUME_NONNULL_END
