#import <UIKit/UIKit.h>

@interface CanvasView : UIView
@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSValue*>*>* lines;
@property (nonatomic, strong) UIPanGestureRecognizer* gesture;
@property (nonatomic, weak) UILabel* charLbl;
-(void)clear;
-(UIImage*)captureImage;
-(void)setCharacterLabel:(char)c;
@end
