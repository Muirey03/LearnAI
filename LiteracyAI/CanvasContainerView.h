//
//  CanvasContainerView.h
//  LiteracyAI
//
//  Created by Tommy Muir on 04/01/2021.
//

#import <UIKit/UIKit.h>
#import "CanvasView.h"
#import "CanvasButtonsView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CanvasType) {
    CanvasTypeLetters = 0,
    CanvasTypeNumbers = 1
};

typedef NS_ENUM(NSInteger, CanvasState) {
    CanvasStateWaiting,
    CanvasStateReady
};

@protocol CanvasViewDelegate
@optional
- (void)canvasDidSubmitLetter:(char)c;
- (void)canvasDidSubmitNumber:(unsigned)n;
@end

@interface CanvasContainerView : UIView<CanvasButtonDelegate>
@property (nonatomic, assign) CanvasType canvasType;
@property (nonatomic, weak, readonly) CanvasView* canvasView;
@property (nonatomic, weak) IBOutlet id<CanvasViewDelegate> delegate;
@property (readonly, nonatomic) CanvasState state;
@property (readonly, nonatomic) char currentChar;
- (void)resetCanvas;
@end

NS_ASSUME_NONNULL_END
