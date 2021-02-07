//
//  SpellingViewController.m
//  LiteracyAI
//
//  Created by Tommy Muir on 07/02/2021.
//

#import "SpellingViewController.h"

@interface SpellingViewController ()

@end

@implementation SpellingViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fetchAnimals];
    [self chooseAnimal];
}

- (void)fetchAnimals {
    /*NSMutableArray* questions = [NSMutableArray array];
    _questionIndex = 0;
    [[Database vendorDB] executeSQL:@"SELECT * FROM Equations ORDER BY RANDOM()" withParameters:nil withResults:^(sqlite3_stmt* record, BOOL* stop) {
        [questions addObject:@((const char*)sqlite3_column_text(record, 1))];
    }];
    _questions = questions;*/
}

-(void)chooseAnimal {
    //DEBUG
    NSString* animal = @"Dog";
    UIImage* animalImg = [self getAnimalNamed:animal];
    _animalImgView.image = animalImg;
}

- (void)canvasDidSubmitLetter:(char)c {
    NSLog(@"submitted %c", c);
}

- (UIImage*)getAnimalNamed:(NSString*)name {
    NSString* filename = [name stringByAppendingPathExtension:@"png"];
    NSString* bundleDir = [[NSBundle mainBundle] bundlePath];
    NSString* animalPath = [[bundleDir stringByAppendingPathComponent:@"Animals"] stringByAppendingPathComponent:filename];
    return [UIImage imageWithContentsOfFile:animalPath];
}

@end

