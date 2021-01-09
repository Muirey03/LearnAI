//
//  UserManager.m
//  LiteracyAI
//
//  Created by Tommy Muir on 31/12/2020.
//

#import "UserManager.h"
#import "Database.h"

@implementation UserManager
+ (instancetype)sharedInstance {
    static UserManager* manager = nil;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        manager = [UserManager new];
    });
    return manager;
}

- (instancetype)init {
    if ((self = [super init])) {
        [self createTableIfNeeded];
        [self updateFromDatabase];
    }
    return self;
}

- (void)createTableIfNeeded {
    if (![[Database mainDB].tables containsObject:@"Users"]) {
        [[Database mainDB] executeSQL:  @"CREATE TABLE \"Users\" ("
                                        @"\"UserID\" PRIMARY KEY, "
                                        @"\"Name\" TEXT NOT NULL UNIQUE, "
                                        @"\"ProfileImagePath\" TEXT)"];
    }
}

- (void)updateFromDatabase {
    NSMutableArray* users = [NSMutableArray array];
    [[Database mainDB] executeSQL:@"SELECT * FROM Users" withParameters:nil withResults:^(sqlite3_stmt* record, BOOL* stop){
        [users addObject:[[User alloc] initWithSQLRecord:record]];
    }];
    _users = users;
}

- (void)createUserWithName:(NSString *)name imagePath:(NSString *)imgPath {
    [[Database mainDB] executeSQL:@"INSERT INTO Users (Name, ProfileImagePath) VALUES (?, ?)" withParameters:@[name, imgPath ?: (NSString*)[NSNull null]]];
    [self updateFromDatabase];
}

@end
