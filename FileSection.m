//
//  FileSection.m
//  AssignmentManager
//
//  Created by ジャスペル on 9/14/14.
//  Copyright (c) 2014 mildred.app.ph. All rights reserved.
//

#import "FileSection.h"

@interface FileSection()
@property(nonatomic) sqlite3 *eventDatabase;
@property(nonatomic) sqlite3_stmt *statement;
@end

@implementation FileSection

//combine directory path && return whole path
//use of default directory

+(id)create
{
    return [[FileSection alloc] init];
}

+(NSString *)filePathWithDBname:(NSString *)dbName sqlStatement:(NSString *)sqlStatement
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filepath = [[paths objectAtIndex:0] stringByAppendingPathComponent:dbName];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSLog(@"%d",[filemanager fileExistsAtPath:filepath]);
    BOOL status = [sqlStatement rangeOfString:@"CREATE"].length;
    if([filemanager fileExistsAtPath:filepath] || status) {
        return filepath;
    }
    return nil;
}

- (NSArray *)sqlBlock:(SqlBlock)sqlblock sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName
{
    NSMutableArray *data;
    NSString *filepath = [FileSection filePathWithDBname:dbName sqlStatement:sqlStatement];
    const char *dbpath = [filepath UTF8String];
    
    if(sqlite3_open(dbpath, &(_eventDatabase)) == SQLITE_OK) {
        
        const char *sql_stmt = [sqlStatement UTF8String];
        // Determine if we are going to create a new table
        // Or we're gonna use prepare for existing table to add_edit content
        if([sqlStatement rangeOfString:@"CREATE"].length) {
            char *message_error;
            if (sqlite3_exec(_eventDatabase, sql_stmt, NULL, NULL, &message_error) != SQLITE_OK) {
                return @[];
            }
            [data addObject:@YES];
        } else {
            if(sqlite3_prepare_v2(_eventDatabase, sql_stmt, -1, &_statement, NULL) == SQLITE_OK) {
                
                //            sqlite3_bind_text(_statement, 1, [@"Blob" UTF8String], -1,SQLITE_TRANSIENT);
                data = [NSMutableArray arrayWithArray:sqlblock(&_statement, &_eventDatabase, [NSString stringWithUTF8String:dbpath])];
            }
        }
        if([sqlStatement rangeOfString:@"CREATE"].length == 0) {
            sqlite3_reset(_statement);
            sqlite3_finalize(_statement); // destroy object used by _prepare_
        }
        
        sqlite3_close(_eventDatabase);
    }
    return data;
}

- (NSArray *)sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName
{
    SqlBlock sqlblock = ^(sqlite3_stmt **statement, sqlite3 **eventDatabase, NSString *dbpath) {
        if(sqlite3_step(*statement) == SQLITE_DONE) {
            return @[@YES];
        }
        return @[];
    };
    return [self sqlBlock:sqlblock sqlStatement:sqlStatement dbName:dbName];
}

@end
