//
//  NewUserCollectionViewCell.m
//  LiteracyAI
//
//  Created by Tommy Muir on 31/12/2020.
//

#import "NewUserCollectionViewCell.h"

@implementation NewUserCollectionViewCell

+ (UINib*)nib {
    return [UINib nibWithNibName:@"NewUserCollectionViewCell" bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _plusView.layer.cornerRadius = 20;
    _plusView.layer.borderWidth = 10;
    _plusView.layer.borderColor = UIColor.labelColor.CGColor;
    _plusView.layer.masksToBounds = YES;
}

@end
