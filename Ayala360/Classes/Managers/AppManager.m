//
//  AppManager.m
//  ESBG
//
//  Created by Martin on 11/12/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import "AppManager.h"
#import "PlistHelper.h"

@implementation AppManager
@synthesize rootController = _rootController;
@synthesize dijkstra = _dijkstra;

#define kDB_NAME @"RippleWave"
static AppManager * _appManager = nil;

+ (AppManager *)sharedInstance
{
    if (_appManager == nil) {
        _appManager = [[[self class]alloc]init];
    }
    
    return _appManager;
}

- (void)loadManagers{
    _dijkstra = [[Dijkstra alloc]init];
    _sqlManager = [[SqlManager alloc]initDatabaseWithNameNoExt:kDB_NAME];
    [self processPlist];
    /*
    [_sqlManager performCreateTableQuery:@"CREATE TABLE Mall(uniqueId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, MallName TEXT);" inDatabase:kDB_NAME];
    [_sqlManager performCreateTableQuery:@"CREATE TABLE Node(mallId INTEGER nodeId INTEGER, cost FLOAT, name TEXT, coor TEXT, zAxis FLOAT, parentNodeId INTEGER, FOREIGN KEY(mallId) REFERENCES Mall(uniqueId) ON UPDATE CASCADE)" inDatabase:kDB_NAME];
    
    [_sqlManager performCreateTableQuery:@"CREATE TABLE Edge(mallId INTEGER  cost FLOAT, startNodeId INTEGER, endNodeId INTEGER, FOREIGN KEY(mallId) REFERENCES Mall(uniqueId) ON UPDATE CASCADE)" inDatabase:kDB_NAME];
    */
    _rootController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
}

- (void)processPlist
{
    NSArray *plistData = [[NSArray alloc]initWithArray:[PlistHelper getArray:@"AyalaCebuData"]];
    for (NSDictionary *temp in plistData) {
        NSLog(@"::::%@",temp);
    }
}
@end
