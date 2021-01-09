//
//  MathsViewController.h
//  LiteracyAI
//
//  Created by Tommy Muir on 04/01/2021.
//

#import <UIKit/UIKit.h>
#import "CanvasContainerView.h"
#import "Equation.h"

NS_ASSUME_NONNULL_BEGIN

@interface MathsViewController : UIViewController<CanvasViewDelegate>
@property (nonatomic, strong) Equation* currentEquation;
@property (nonatomic, weak) IBOutlet UILabel* equationLbl;
@property (strong, nonatomic) NSMutableArray* questions;
@property (nonatomic, assign) NSUInteger questionIndex;
- (void)fetchQuestions;
-(void)chooseEquation;
@end

NS_ASSUME_NONNULL_END
