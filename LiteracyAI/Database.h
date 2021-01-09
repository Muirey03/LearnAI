//
//  Database.h
//  LiteracyAI
//
//  Created by Tommy Muir on 30/12/2020.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject
@property (nonatomic, readonly) sqlite3* database;
@property (nonatomic, readonly) NSArray<NSString*>* tables;
+ (Database*)mainDB;
+ (Database*)vendorDB;
- (instancetype)initWithPath:(NSString *)path;
- (instancetype)initWithName:(NSString*)name;
- (void)executeSQL:(NSString*)query;
- (void)executeSQL:(NSString *)query withParameters:(NSArray*)params;
- (void)executeSQL:(NSString *)query withParameters:(NSArray*)params withResults:(void(^)(sqlite3_stmt*, BOOL*))callback;
@end
