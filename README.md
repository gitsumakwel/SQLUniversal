SQLUniversal
============
IOS - only
Initialize ThisFile

ThisFile *thisfile = [ThisFile create];

// give the Query statement, database name, tablename (used in query)
// all is NSString
[thisfile sqlStatement:sqlStatement dbName:dbName tableName:tableName]
