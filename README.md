SQLUniversal
============

IOS - only

//Initialize ThisFile

ThisFile *thisfile = [ThisFile create];

// In NSString format give the Query statement, database name, tablename (used in query)

NSString *sqlStatement = [NSString stringWithFormat:@"SELECT event_name, event_date, event_detail, event_image FROM myevents"];

NSString *dbName = @"myDB.db";

NSString *tablename = @"myevents";

//invoke sqlStatement:dbName:tableName: method from thisfile

[thisfile sqlStatement:sqlStatement dbName:dbName tableName:tableName];
