//  2
//  FileSection.h
//  AssignmentManager
//
//  Created by ジャスペル on 9/14/14.
//  Copyright (c) 2014 mildred.app.ph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

typedef NSArray*(^SqlBlock)(sqlite3_stmt **statement, sqlite3 **eventDatabase, NSString *dbpath);


/* WORKS WITH THIS FILE
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
 *
 * + (NSString *)filePathWithDBname:(NSString *)dbName sqlStatement:(NSString *)sqlStatement;
 * Check for dabatabase
 * if doesnt exist create and add table
 * sample:
 NSString *path = [FileSection filePathWithDBname:DBFile_dummy sqlStatement:nil];
 if(!path) {
 thisfile = [ThisFile create];
 sqlStatement =  @"CREATE TABLE IF NOT EXISTS IMPORTANT(ID INTEGER PRIMARY KEY AUTOINCREMENT, searchcode TEXT,   datacode TEXT)";
 [thisfile sqlStatement:sqlStatement dbName:DBFile_dummy tableName:nil];
 }
 *
 */

@interface FileSection : NSObject
+ (id)create;
+ (NSString *)filePathWithDBname:(NSString *)dbName sqlStatement:(NSString *)sqlStatement;
- (NSArray *)sqlBlock:(SqlBlock)sqlblock sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName;
- (NSArray *)sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName;


@end

