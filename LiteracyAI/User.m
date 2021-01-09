//
//  User.m
//  LiteracyAI
//
//  Created by Tommy Muir on 31/12/2020.
//

#import "User.h"

@implementation User
{
    NSString* _imgPath;
}

- (instancetype)initWithSQLRecord:(sqlite3_stmt *)record {
    if ((self = [self init])) {
        _userID = sqlite3_column_int(record, kUserIDColumn);
        _name = @((const char*)sqlite3_column_text(record, kUserNameColumn));
        const char* cImgPath = (const char*)sqlite3_column_text(record, kProfileImagePathColumn);
        _imgPath = cImgPath ? @(cImgPath) : nil;
    }
    return self;
}

- (UIImage*)image {
    if (_imgPath) {
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        return [UIImage imageWithContentsOfFile:[documentsPath stringByAppendingPathComponent:_imgPath]];
    }
    return [UIImage imageNamed:@"DefaultProfile"];
}

@end
