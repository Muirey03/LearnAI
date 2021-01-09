//
//  UserManager.h
//  LiteracyAI
//
//  Created by Tommy Muir on 31/12/2020.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject
@property (nonatomic, readonly, strong) NSArray<User*>* users;
@property (nonatomic, weak) User* currentUser;
+ (instancetype)sharedInstance;
- (void)createTableIfNeeded;
- (void)updateFromDatabase;
- (void)createUserWithName:(NSString*)name imagePath:(NSString*)imgPath;
@end

NS_ASSUME_NONNULL_END
