//
//  ThisFile.h
//  AssignmentManager
//
//  Created by ジャスペル on 9/15/14.
//  Copyright (c) 2014 mildred.app.ph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThisFile : NSObject
- (NSArray *)sqlStatement:(NSString *)sqlStatement dbName:(NSString *)dbName tableName:(NSString *)tableName;
@end
