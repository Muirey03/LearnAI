//
//  MathsViewController.m
//  LiteracyAI
//
//  Created by Tommy Muir on 04/01/2021.
//

#import "MathsViewController.h"
#import "ConfettiViewController.h"
#import "IncorrectViewController.h"
#import "Database.h"

@interface MathsViewController ()

@end

@implementation MathsViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchQuestions];
    [self chooseEquation];
}

- (void)fetchQuestions {
    NSMutableArray* questions = [NSMutableArray array];
    _questionIndex = 0;
    [[Database vendorDB] executeSQL:@"SELECT * FROM Equations ORDER BY RANDOM()" withParameters:nil withResults:^(sqlite3_stmt* record, BOOL* stop) {
        [questions addObject:@((const char*)sqlite3_column_text(record, 1))];
    }];
    _questions = questions;
}

-(void)chooseEquation {
    _currentEquation = [[Equation alloc] initWithQuestion:_questions[_questionIndex++ % _questions.count]];
    
    _equationLbl.text = _currentEquation.question;
}

- (void)canvasDidSubmitNumber:(unsigned int)number {
    if (_currentEquation.answer == number) {
        ConfettiViewController* confetti = [ConfettiViewController new];
        [self presentViewController:confetti animated:NO completion:nil];
        [confetti beginAnimationWithCompletion:^{
            [self chooseEquation];
        }];
    } else {
        IncorrectViewController* crossVC = [IncorrectViewController new];
        crossVC.completion = ^{
            [self chooseEquation];
        };
        [self presentViewController:crossVC animated:NO completion:nil];
    }
}

@end
