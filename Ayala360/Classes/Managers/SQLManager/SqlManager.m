//
//  SqlManager.m
//  Created by Martin on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SqlManager.h"

@implementation SqlManager

- (id)initDatabaseWithNameNoExt:(NSString *)dbName
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",dbName]];
        NSLog(@"%@",databasePath);
        // Check to see if the database file already exists
        bool databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:databasePath];
        if(databaseAlreadyExists)
        {
            sqlite3_open([databasePath UTF8String], &_database);
            NSLog(@"DB already exists!");
        }
        else {
            // Create the database if it doesn't yet exists in the file system
            if (sqlite3_open([databasePath UTF8String], &_database) == SQLITE_OK)
            {
                NSLog(@"DB successfully created!");
            }
            else {
                NSLog(@"Something went wrong!");
            }
        }
    }
    return self;
}

- (BOOL)performCreateTableQuery:(NSString *)query inDatabase:(NSString *)dbName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",dbName]];
    
    // Check to see if the database file already exists
    bool databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:databasePath];
    
    if (databaseAlreadyExists)
    {
        char *error;
        if (sqlite3_exec(_database, [query UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"Table created!");
            return YES;
        }
        else
        {
            NSLog(@"Error: %s", error);
        }
    }
    else {
        NSLog(@"DB doesn't exists!");
    }
    return NO;
}

- (NSArray *)performSelectQuery:(NSString *)query
{
    sqlite3_stmt *statement = nil;
    NSMutableArray *_listQueryResults = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK){        
        // Iterate over all returned rows
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
            for (int i=0; i<sqlite3_column_count(statement); i++) {
                int colType = sqlite3_column_type(statement, i);
                id value;
                NSString *colName = [[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, i)] lowercaseString];
                if (colType == SQLITE_TEXT) {
                    const unsigned char *col = sqlite3_column_text(statement, i);
                    value = [NSString stringWithFormat:@"%s", col];
                } else if (colType == SQLITE_INTEGER) {
                    int col = sqlite3_column_int(statement, i);
                    value = [NSNumber numberWithInt:col];
                } else if (colType == SQLITE_FLOAT) {
                    double col = sqlite3_column_double(statement, i);
                    value = [NSNumber numberWithDouble:col];
                } else if (colType == SQLITE_NULL) {
                    value = [NSNull null];
                } else {
                    NSLog(@"[SQLITE] UNKNOWN DATATYPE");
                }
                [row setObject:value forKey:colName];
            }
            [_listQueryResults addObject:row];
        }
        sqlite3_finalize(statement);
        return _listQueryResults;
    }
    return nil;
}

- (BOOL)performNonSelectQuery:(NSString *)query
{
    char *error;
    if ( sqlite3_exec(_database, [query UTF8String], NULL, NULL, &error) == SQLITE_OK){
        NSLog(@"Success");
        return YES;
    }
    else{
        NSLog(@"Error: %s", error);
        return NO;
    }
    return NO;
}

-(void)begin{
    [self performNonSelectQuery:@"begin transaction"];
}
-(void)commit{
    [self performNonSelectQuery:@"commit"];
}
@end
