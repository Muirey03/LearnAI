//
//  UserCollectionViewCell.h
//  LiteracyAI
//
//  Created by Tommy Muir on 31/12/2020.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UILabel* nameLbl;
@property (nonatomic, weak) IBOutlet UIImageView* profileImg;
@property (nonatomic, weak) User* user;
+ (UINib*)nib;
- (void)configureForUser:(User*)user;
@end

NS_ASSUME_NONNULL_END
