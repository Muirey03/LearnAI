//
//  UserCollectionViewCell.m
//  LiteracyAI
//
//  Created by Tommy Muir on 31/12/2020.
//

#import "UserCollectionViewCell.h"

@implementation UserCollectionViewCell

+ (UINib*)nib {
    return [UINib nibWithNibName:@"UserCollectionViewCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureForUser:(User *)user {
    _user = user;
    _nameLbl.text = user.name;
    _profileImg.image = user.image;
}

@end
