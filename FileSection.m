//
//  FileSection.m
//  AssignmentManager
//
//  Created by ジャスペル on 9/14/14.
//  Copyright (c) 2014 mildred.app.ph. All rights reserved.
//

#import "FileSection.h"

static sqlite3 *eventDatabase;
static sqlite3_stmt *statement;

@implementation FileSection

//combine directory path && return whole path
//use of default directory

+(NSString *)filePathWithDBname:(NSString *)dbName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filepath = [[paths objectAtIndex:0] stringByAppendingPathComponent:dbName];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if([filemanager fileExistsAtPath:filepath]) {
        return filepath;
    }
    return nil;
}
+(NSArray *)sqlBlock:(SqlBlock)sqlblock sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName
{
    NSMutableArray *data;
    NSString *filepath = [self filePathWithDBname:dbName];
    if(filepath) {
        const char *dbpath = [filepath UTF8String];
        if(sqlite3_open(dbpath, &eventDatabase) == SQLITE_OK) {
            const char *sql_stmt = [sqlStatement UTF8String];
            sqlite3_prepare_v2(eventDatabase, sql_stmt, -1, &statement, NULL);
            
            //sqlite3_bind_text(statement, 1, [@"Blob" UTF8String], -1,SQLITE_TRANSIENT);
            
            data = [NSMutableArray arrayWithArray:sqlblock(&statement)];
            sqlite3_reset(statement);
            sqlite3_finalize(statement); // destroy object used by _prepare_v2
            sqlite3_close(eventDatabase);
        }
    }
    return data;
}

+(NSArray *)sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName
{
    SqlBlock sqlblock = ^(sqlite3_stmt **statement) {
        if(sqlite3_step(*statement) == SQLITE_DONE) {
            return @[@YES];
        }
        return @[@NO];
    };
    return [self sqlBlock:sqlblock sqlStatement:sqlStatement dbName:dbName];
}

@end
