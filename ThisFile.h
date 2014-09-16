//  1
//  ThisFile.h
//  AssignmentManager
//
//  Created by ジャスペル on 9/15/14.
//  Copyright (c) 2014 mildred.app.ph. All rights reserved.
//


/**
 * - (NSArray *)sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName tableName: (NSString *)tableName;
 * used: for SQL
 * provide: Query Statement, DatabaseName, TableName(used in SELECT * statement / nil on other statement)
 * sample:
 

 **/
#import <Foundation/Foundation.h>

@interface ThisFile : NSObject
- (NSArray *)sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName tableName:(NSString *)tableName;
@end
