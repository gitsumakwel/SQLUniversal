//
//  ThisFile.m
//  AssignmentManager
//
//  Created by ジャスペル on 9/15/14.
//  Copyright (c) 2014 mildred.app.ph. All rights reserved.
//

#import "ThisFile.h"
#import <sqlite3.h>
#import "FileSection.h"

static sqlite3 *eventDatabase;
static sqlite3_stmt *statement;

@implementation ThisFile
+(id)create
{
    return [[ThisFile alloc] init];
}

- (NSArray *)sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName tableName:(NSString *)tableName
{
    
    sqlStatement = [sqlStatement stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    char c = [sqlStatement characterAtIndex:0];
    if(c != 'S' || c != 's') {
        return [FileSection sqlStatement:sqlStatement dbName:dbName];
    }

    else {
        /*
         * you can do whatever want in here as long as your creating sqlblock
         * contains:
         * sqlite3_step(*statement == SQLITE_ROW) {
           NSString *ename = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(*statement, 0)]; // sample getting data from column 0
           }
         *
        */
        
        SqlBlock sqlblock = ^(sqlite3_stmt **statement) {
            if(sqlite3_step(*statement) == SQLITE_ERROR) return @[@NO];
            
            int c = [[sqlStatement componentsSeparatedByString:@","] count];
            if([sqlStatement rangeOfString:@"pragma"].length) {
                SqlBlock sqlblock = ^(sqlite3_stmt **statement){
                    int c = 0;
                    if(sqlite3_step(*statement) == SQLITE_ERROR) return @[@NO];
                    while(sqlite3_step(*statement) == SQLITE_ROW) {
                        c++;
                    }
                    return @[[NSNumber numberWithInt:c]];
                };
                [FileSection sqlBlock:sqlblock sqlStatement:sqlStatement dbName:dbName];
            }
            else if([sqlStatement rangeOfString:@"*"].length){
                ThisFile *thisfile = [ThisFile create];
                NSString *select = [NSString stringWithFormat:@"pragma table_info('%@')",tableName];
                c = [[[thisfile sqlStatement:select dbName:dbName tableName:nil] objectAtIndex:0] intValue];
            }
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
        
        return [FileSection sqlBlock:sqlblock sqlStatement:sqlStatement dbName:dbName];
    } // esle
    return NO;
}

+(void) AlertBox:(NSString *)title Message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}
@end
