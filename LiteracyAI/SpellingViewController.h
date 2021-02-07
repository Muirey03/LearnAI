//
//  SpellingViewController.h
//  LiteracyAI
//
//  Created by Tommy Muir on 07/02/2021.
//

#import <UIKit/UIKit.h>
#import "CanvasContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpellingViewController : UIViewController<CanvasViewDelegate>
@property (nonatomic, weak) IBOutlet UIImageView* animalImgView;
@property (nonatomic, strong) NSArray* animals;
@property (nonatomic, assign) NSUInteger animalIndex;
@property (nonatomic, strong) NSString* currentAnimal;
- (void)fetchAnimals;
- (void)chooseAnimal;
- (void)canvasDidSubmitLetter:(char)c;
- (UIImage*)getAnimalNamed:(NSString*)name;
@end

NS_ASSUME_NONNULL_END
