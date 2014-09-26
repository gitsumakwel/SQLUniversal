//
//  ThisFile.m
//  AssignmentManager
//
//  Created by ジャスペル on 9/15/14.
//  Copyright (c) 2014 mildred.app.ph. All rights reserved.
//

#import "ThisFile.h"
#import <sqlite3.h>

#define say(v) NSLog(@"%d",v);

@implementation ThisFile
+(id)create
{
    return [[ThisFile alloc] init];
}

- (NSArray *)sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName tableName:(NSString *)tableName
{
    
    sqlStatement = [sqlStatement stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    char c = [sqlStatement characterAtIndex:0];
    
    if(c != 'S' && c != 's') {
        return [self sqlStatement:sqlStatement dbName:dbName];
    }
    else {
        /*
         * you can do whatever you want in here as long as you create sqlblock and
         * contains:
         *
         * sqlite3_bind_text(*statement, 1, [@"Blob" UTF8String], -1,SQLITE_TRANSIENT); //optional
         sqlite3_step(*statement == SQLITE_ROW) {
         NSString *ename = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(*statement, 0)]; // sample getting data from column 0
         }
         *
         */
        __block int c;
        if([sqlStatement rangeOfString:@"*"].length)
            c = (int)[[self tableColumns:tableName dbName:dbName] count];
        else if([sqlStatement rangeOfString:@"PRAGMA TABLE_INFO"].length)
            return [self tableColumns:tableName dbName:dbName];
        else
            c = (int)[[sqlStatement componentsSeparatedByString:@","] count];

        SqlBlock sqlblock = ^(sqlite3_stmt **statement, sqlite3 **eventDatabase, NSString *dbpath) {
            NSMutableArray *mainArray = [[NSMutableArray alloc] init];
            while(sqlite3_step(*statement) == SQLITE_ROW) {
                NSMutableArray *subarray = [[NSMutableArray alloc] initWithCapacity:c];
                for(int i=0; i <= c; i++) {
                    [subarray addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(*statement, i)]];
                }
                [mainArray addObject:subarray];
                //
            }
            return [NSArray arrayWithArray:mainArray];
        }; //sqlblock
        return [self sqlBlock:sqlblock sqlStatement:sqlStatement dbName:dbName];
    } // else
    return @[];
}

- (NSArray *)tableColumns:(NSString *)tableName dbName:(NSString *)dbName
{
    SqlBlock sqlblock = ^(sqlite3_stmt **statement, sqlite3 **eventDatabase, NSString *dbpath){
        
        if(sqlite3_step(*statement) == SQLITE_ERROR) return @[];
        
        NSMutableArray *columns = [[NSMutableArray alloc] init];
        while(sqlite3_step(*statement) == SQLITE_ROW) {
            [columns addObject:[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(*statement,1)]];
        }
        return [NSArray arrayWithArray:columns];
    };
    NSString *sqlStatement = [NSString stringWithFormat:@"PRAGMA TABLE_INFO('%@')",tableName];
    return [[FileSection create]sqlBlock:sqlblock sqlStatement:sqlStatement dbName:dbName];
}


@end