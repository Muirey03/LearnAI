//
//  NewUserViewController.h
//  LiteracyAI
//
//  Created by Tommy Muir on 31/12/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewUserViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet UIImageView* imgView;
@property (nonatomic, weak) IBOutlet UITextField* nameField;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
- (IBAction)choosePicture:(id)sender;
- (IBAction)done:(id)sender;
@end

NS_ASSUME_NONNULL_END
