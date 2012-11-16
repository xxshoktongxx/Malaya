//
//  SqlManager.h
//  Created by Martin on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/** ================================================
Instructions: 
 1. Import libsqlite3.0.dylib framework.
 2. Add SqlManager.h and SqlManager.m to your project.
 3. Create an instance of SqlManager with database name.
 4. Create tables in specified database.
 ================================================ **/

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqlManager : NSObject
{
    sqlite3 *_database;
}
/** Creates an instance of sqlite3 database **/
- (id)initDatabaseWithNameNoExt:(NSString *)dbName;

/** Used in creating table **/
- (BOOL)performCreateTableQuery:(NSString *)query inDatabase:(NSString *)dbName;

/** Used in query which uses SELECT statement which returns results **/
- (NSArray *)performSelectQuery:(NSString *)query;

/** Used in query which doesn't use SELECT such as UPDATE, INSERT, DELETE etc... **/
- (BOOL)performNonSelectQuery:(NSString *)query;

/** Used when performing several simultaneous queries **/
-(void)begin; 
-(void)commit;

@end

/** Sample sql query which can be used in the class **/
//Semicolon at the end of each query isnt required, as i believe. :D

//CREATE TABLE:
#define kCREATE_TABLE   @"CREATE TABLE PERSON(Id INTEGER PRIMARY KEY AUTOINCREMENT, FirstName TEXT, LastName Text);"
 
//INSERT INTO:
#define kINSERT_INTO    @"INSERT INTO PERSON VALUES(null,\"MIKOKO\",\"KURIBAYSHI\");" //Note that we pass null as the first value because the field which it corresponds is an autoincremented field.
#define kINSERT_INTO2   @"INSERT INTO PERSON(FirstName,LastName) VALUES(\"Yeska\",\"Tijera\");"
#define kINSERT_INTO3   @"INSERT INTO PERSON(FirstName,LastName,BirthDate) VALUES(\"Clarene\",\"Tijera\",datetime('NOW'));"

//SELECT:
#define kSELECT         @"SELECT Id FROM PERSON;"
#define KSELECT2        @"SELECT datetime(BirthDate('localtime') FROM PERSON;"
#define KSELECT3        @"SELECT strftime('%d-%m-%Y %w %W',BirthDate) FROM PERSON;"
#define kSELECT_ALL_TABLES  @"SELECT tbl_name FROM sqlite_master WHERE type='table';"
 
//UPDATE:
#define kUPDATE         @"UPDATE PERSON SET FirstName=\"Modified\" where Id=1;"

//DELETE:
#define kDELETE         @"DELETE FROM PERSON where Id=1;"

//CREATE VIEW:
#define kCREATE_VIEW    @"CREATE VIEW testview AS select * from PERSON;" //now use testview, "SELECT * FROM testview;"
#define kDELETE_VIEW    @"DROP VIEW testview;" //use this when you dont need testview anymore
 
//ALTER TABLE:
#define kALTER_TABLE    @"ALTER TABLE PERSON add column BirthDate DATE;"
#define kALTER_TABLE_RENAME    @"ALTER TABLE PERSON RENAME TO HUMAN;"
 
//DROP TABLE:
#define kDROP_TABLE     @"DROP TABLE HUMAN;"

//Checks the structure of specified table 
#define kTABLE_STRUCTURE @"PRAGMA table_info(PERSON);"
//#define kTABLE_STRUCTURE2 @"SELECT sql FROM sqlite_master; WHERE tbl_name = 'table_name' AND type = 'table';";

//Useful commands when doing debug in sql console
// sqlite> .header on
// sqlite> .mode column

//EXPORT
// sqlite> .output /tmp/test.sql
// sqlite> .dump
// sqlite> .output stdout

//IMPORT
//sqlite> .import /tmp/test.csv test
//sqlite> select * from test;

//EXECUTE queries from .sql file
//sqlite3> company.db < insert-data.sql

//See all databases
//sqlite3> .databases

//See all tables
//sqlite3> .tables
