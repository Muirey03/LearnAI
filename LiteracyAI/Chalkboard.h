//
//  Chalkboard.h
//  LiteracyAI
//
//  Created by Tommy Muir on 28/12/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Chalkboard : UIImageView
@property (nonatomic, weak) UILabel* lbl;
@property (nonatomic, weak) UIView* hangmanView;
@property (nonatomic, strong) NSMutableArray<CALayer*>* hangmanLayers;
-(void)setText:(NSString*)text;
-(void)setAttributedText:(NSAttributedString*)attText;
-(void)drawHangmanStroke:(CGPathRef)path;
-(void)resetHangman;
@end

NS_ASSUME_NONNULL_END
