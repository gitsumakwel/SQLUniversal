//  2
//  FileSection.h
//  AssignmentManager
//
//  Created by ジャスペル on 9/14/14.
//  Copyright (c) 2014 mildred.app.ph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

typedef NSArray*(^SqlBlock)(sqlite3_stmt **statement);


/* WORKS WITH THIS FILE
 *
 * ITS YOUR RESPONSIBILITY TO CHECK IF THE DATABASE/TABLE EXIST
 *
 *
 * + (BOOL)sqlStatement:(NSString *)sqlStatement dbName:dbName;
 * used: Insert, Delete, Update query Only
 * provide: database name and SQL Statement in NSString Object
 * sample:
 *
 * NSString *insertStatement = [NSString stringWithFormat(@"INSERT INTO myTable(row1,row2,row3) VALUES (\"%@\",\"%@\",\"%@\")", value1, value2, value3];
 *
 * NSString *dbName = @"DBFile.db";
 *
 * if([FileSection sqlStatement:insert_stmt dbName:dbName]) NSLog(@"it worked");
 *
 */

/* + (BOOL)sqlBlock:(SqlBlock)sqlblock sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName;
 * used: Select query only
 * provide: sqlBlock, database name and SQL Statement in NSString Object
 * sample:
 *
 * NSString *insertStatement = @"SELECT row1,row2,row3 from table";
 *
 * NSString *dbName = @"DBFile.db";
 * NSMutableArray *mainArray = [[NSMutableArray alloc] init];
 *
 * SqlBlock sqlblock = ^(sqlite3_stmt **statement) {
 
        while(sqlite3_step(*statement) == SQLITE_ROW) {
            NSMutableArray *subarray = [[NSMutableArray alloc] initWithCapacity:3];
            for(int i=0; i < 3; i++) {
                [subarray addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(*statement, i)]];
            }
        [mainArray addObject:subarray];
 
    }
 
  } //sqlblock
 *
 */


@interface FileSection : NSObject
+ (NSArray *)sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName;
+ (NSArray *)sqlBlock:(SqlBlock)sqlblock sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName;

@end

