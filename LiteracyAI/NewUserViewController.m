//
//  NewUserViewController.m
//  LiteracyAI
//
//  Created by Tommy Muir on 31/12/2020.
//

#import "NewUserViewController.h"
#import "UserManager.h"

@interface NewUserViewController ()
{
    NSString* _imgPath;
}
@end

@implementation NewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)done:(id)sender {
    NSString* name = _nameField.text;
    if (name.length) {
        [[UserManager sharedInstance] createUserWithName:name imagePath:_imgPath];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)keyboardShown:(NSNotification*)notif {
    NSDictionary* info = notif.userInfo;
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    _scrollView.contentInset = insets;
    _scrollView.scrollIndicatorInsets = insets;
}

- (void)keyboardWillHide:(NSNotification*)notif {
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)choosePicture:(id)sender {
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSURL* imgURL = info[UIImagePickerControllerImageURL];
    NSString* documentsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString* profileImagesDir = [documentsDir stringByAppendingPathComponent:@"ProfilePictures"];
    
    BOOL isDir = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:profileImagesDir isDirectory:&isDir];
    if (!exists || !isDir) {
        if (exists) {
            [[NSFileManager defaultManager] removeItemAtPath:profileImagesDir error:NULL];
        }
        [[NSFileManager defaultManager] createDirectoryAtPath:profileImagesDir withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    UIImage* img = info[UIImagePickerControllerEditedImage];
    NSString* newPath = [profileImagesDir stringByAppendingPathComponent:imgURL.lastPathComponent];
    [UIImagePNGRepresentation(img) writeToFile:newPath atomically:YES];
    _imgPath = [@"ProfilePictures" stringByAppendingPathComponent:newPath.lastPathComponent];
    _imgView.image = img;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
