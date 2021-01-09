//
//  IncorrectViewController.h
//  LiteracyAI
//
//  Created by Tommy Muir on 08/01/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IncorrectViewController : UIViewController
@property (nonatomic, weak) UILabel* label;
@property (nonatomic, strong) void(^completion)(void);
@end

NS_ASSUME_NONNULL_END
