//
//  CanvasButtonsView.h
//  LiteracyAI
//
//  Created by Tommy Muir on 06/01/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CanvasButtonType) {
    CanvasButtonTypeSubmit,
    CanvasButtonTypeClear
};

@protocol CanvasButtonDelegate
@required
- (void)canvasButtonPressed:(CanvasButtonType)button;
@end

@interface CanvasButtonsView : UIView
@property (nonatomic, weak) IBOutlet id<CanvasButtonDelegate> delegate;
- (void)submit:(UIButton*)btn;
- (void)clear:(UIButton*)btn;
@end

NS_ASSUME_NONNULL_END
