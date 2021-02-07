//
//  SpellingViewController.m
//  LiteracyAI
//
//  Created by Tommy Muir on 07/02/2021.
//

#import "SpellingViewController.h"
#import "Database.h"
#import "ConfettiViewController.h"
#import "IncorrectViewController.h"

@interface SpellingViewController ()

@end

@implementation SpellingViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchAnimals];
    [self chooseAnimal];
}

- (void)fetchAnimals {
    NSMutableArray* animals = [NSMutableArray array];
    _animalIndex = 0;
    [[Database vendorDB] executeSQL:@"SELECT Name FROM Animals ORDER BY RANDOM()" withParameters:nil withResults:^(sqlite3_stmt* record, BOOL* stop) {
        [animals addObject:@((const char*)sqlite3_column_text(record, 0))];
    }];
    _animals = animals;
}

- (void)chooseAnimal {
    NSString* animal = _animals[_animalIndex++ % _animals.count];
    _currentAnimal = animal;
    UIImage* animalImg = [self getAnimalNamed:animal];
    _animalImgView.image = animalImg;
}

- (void)canvasDidSubmitLetter:(char)c {
    void(^completion)(void) = ^{
        [self chooseAnimal];
    };
    if (tolower(c) == tolower([_currentAnimal characterAtIndex:0])) {
        ConfettiViewController* confetti = [ConfettiViewController new];
        [self presentViewController:confetti animated:NO completion:nil];
        [confetti beginAnimationWithCompletion:completion];
    } else {
        IncorrectViewController* crossVC = [IncorrectViewController new];
        crossVC.completion = completion;
        [self presentViewController:crossVC animated:NO completion:nil];
    }
}

- (UIImage*)getAnimalNamed:(NSString*)name {
    NSString* filename = [name stringByAppendingPathExtension:@"png"];
    NSString* bundleDir = [[NSBundle mainBundle] bundlePath];
    NSString* animalPath = [[bundleDir stringByAppendingPathComponent:@"Animals"] stringByAppendingPathComponent:filename];
    return [UIImage imageWithContentsOfFile:animalPath];
}

@end

