//
//  Database.m
//  LiteracyAI
//
//  Created by Tommy Muir on 30/12/2020.
//

#import "Database.h"

@implementation Database

+ (Database*)mainDB {
    static Database* db = nil;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        db = [[Database alloc] initWithName:@"Main"];
    });
    return db;
}

+ (Database*)vendorDB {
    static Database* db = nil;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        NSString* dbPath = [[NSBundle mainBundle] pathForResource:@"Vendor" ofType:@"db"];
        db = [[Database alloc] initWithPath:dbPath];
    });
    return db;
}

- (instancetype)initWithPath:(NSString *)path {
    if ((self = [self init])) {
        _database = NULL;
        int ret = sqlite3_open_v2(path.UTF8String, &_database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, NULL);
        if (ret != SQLITE_OK) {
            @throw([NSException exceptionWithName:@"DatabaseException" reason:[NSString stringWithFormat:@"sqlite3_open failed with error: %s", sqlite3_errmsg(_database)] userInfo:nil]);
        }
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    NSString* documentsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"db"]];
    return [self initWithPath:dbPath];
}

- (void)executeSQL:(NSString *)query {
    sqlite3_exec(_database, query.UTF8String, NULL, NULL, NULL);
}

- (void)executeSQL:(NSString *)query withParameters:(NSArray*)params {
    [self executeSQL:query withParameters:params withResults:nil];
}

- (void)executeSQL:(NSString *)query withParameters:(NSArray*)params withResults:(void(^)(sqlite3_stmt*, BOOL*))callback {
    sqlite3_stmt* statement = NULL;
    if (sqlite3_prepare_v2(_database, query.UTF8String, -1, &statement, NULL) == SQLITE_OK) {
        //bind parameters:
        for (NSUInteger i = 0; i < params.count; i++) {
            int index = (int)i + 1;
            id param = params[i];
            if (param == [NSNull null]) {
                sqlite3_bind_null(statement, index);
            } else if ([param isKindOfClass:[NSString class]]) {
                sqlite3_bind_text(statement, (int)i + 1, ((NSString*)params[i]).UTF8String, -1, SQLITE_STATIC);
            } else if ([param isKindOfClass:[NSNumber class]]) {
                sqlite3_bind_double(statement, index, [param doubleValue]);
            }
        }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            if (callback) {
                BOOL stop = NO;
                callback(statement, &stop);
                if (stop) {
                    break;
                }
            }
        }
    }
    if (statement) {
        sqlite3_finalize(statement);
    }
}

- (NSArray<NSString*>*)tables {
    NSMutableArray* tables = [NSMutableArray array];
    [self executeSQL:@"SELECT name FROM sqlite_master WHERE type=\'table\'" withParameters:nil withResults:^(sqlite3_stmt* record, BOOL* stop){
        [tables addObject:@((const char*)sqlite3_column_text(record, 0))];
    }];
    return tables;
}

- (void)dealloc {
    if (_database) {
        sqlite3_close(_database);
        _database = NULL;
    }
}

@end
