//
//  NewUserCollectionViewCell.h
//  LiteracyAI
//
//  Created by Tommy Muir on 31/12/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewUserCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIView* plusView;
+ (UINib*)nib;
@end

NS_ASSUME_NONNULL_END
