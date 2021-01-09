//
//  User.h
//  LiteracyAI
//
//  Created by Tommy Muir on 31/12/2020.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#define kUserIDColumn 0
#define kUserNameColumn 1
#define kProfileImagePathColumn 2

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property (nonatomic, assign, readonly) int userID;
@property (nonatomic, copy, readonly) NSString* name;
@property (nonatomic, strong, readonly) UIImage* image;
@property (nonatomic, strong, readonly) NSString* imgPath;
-(instancetype)initWithSQLRecord:(sqlite3_stmt*)record;
@end

NS_ASSUME_NONNULL_END
