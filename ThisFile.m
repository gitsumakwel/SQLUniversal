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
    
    if(c != 'S' && c != 's'  && c != 'P' && c != 'p') {
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
        
        SqlBlock sqlblock = ^(sqlite3_stmt **statement) {
            if(sqlite3_step(*statement) == SQLITE_ERROR) return @[@NO];
            
            int c = [[sqlStatement componentsSeparatedByString:@","] count];
            
            if([sqlStatement rangeOfString:@"PRAGMA"].length || [sqlStatement rangeOfString:@"1"].length) {
                SqlBlock sqlblock = ^(sqlite3_stmt **statement){
                    int c = 0;
                    if(sqlite3_step(*statement) == SQLITE_ERROR) return @[@NO];
                    while(sqlite3_step(*statement) == SQLITE_ROW) {
                        c++;
                    }
                    return @[[NSNumber numberWithInt:c]];
                };
                
                return [self sqlBlock:sqlblock sqlStatement:sqlStatement dbName:dbName];
            }
            else if([sqlStatement rangeOfString:@"*"].length){
                ThisFile *thisfile = [ThisFile create];
                NSString *select = [NSString stringWithFormat:@"PRAGMA TABLE_INFO('%@')",tableName];
                
                c = [ [ [thisfile sqlStatement:select dbName:dbName tableName:nil]
                       objectAtIndex:0]
                     intValue] + 1;
                // call prepareSQL again cause we have called "prepare for pgrma" which makes our previous prepare invalid
                [self prepareSQL:sqlStatement];
            }
            NSLog(@"%@",sqlStatement);
            NSMutableArray *mainArray = [[NSMutableArray alloc] init];
            
            while(sqlite3_step(*statement) == SQLITE_ROW) {
                NSMutableArray *subarray = [[NSMutableArray alloc] initWithCapacity:c];
                for(int i=0; i < c; i++) {
                    [subarray addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(*statement, i)]];
                }
                [mainArray addObject:subarray];
                //
            }
            
            return [NSArray arrayWithArray:mainArray];
        }; //sqlblock
        
        return [self sqlBlock:sqlblock sqlStatement:sqlStatement dbName:dbName];
    } // else
    return NO;
}


@end