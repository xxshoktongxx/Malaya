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
@synthesize dijkstra = _dijkstra;

#define kDB_NAME @"RippleWave1"

static AppManager * _appManager = nil;

+ (AppManager *)sharedInstance
{
    if (_appManager == nil) {
        _appManager = [[[self class]alloc]init];
    }
    
    return _appManager;
}

- (void)loadManagers{
    _dataManager = [[DataManager alloc]init];
    _dijkstra = [[Dijkstra alloc]init];
    _locationManager = [[LocationManager alloc]init];
    _foursquareManager = [[Foursquare alloc]init];
    _sqlManager = [[SqlManager alloc]initDatabaseWithNameNoExt:kDB_NAME];
//    [self createSqlTables];
//    [self processPlist];
//    [self dropSqlTables];

    _controllerManager = [[ViewControllerManager alloc]init];
}

#pragma mark - Proccess Sql Data data
- (void)createSqlTables{
    NSString *query = @"";
    query = @"CREATE TABLE Mall(uniqueId INTEGER, MallName TEXT);";
    [_sqlManager performCreateTableQuery:query inDatabase:kDB_NAME];
    
    query = @"CREATE TABLE Map(mallId INTEGER, mapLevel INTEGER, svgName TEXT, FOREIGN KEY(mallId) REFERENCES Mall(uniqueId) ON UPDATE CASCADE)";
    [_sqlManager performCreateTableQuery:query inDatabase:kDB_NAME];
    
    query = @"CREATE TABLE Node(mallId INTEGER, mapLevel INTEGER, nodeId INTEGER, cost FLOAT, name TEXT, coor TEXT, zAxis INTEGER, parentNodeId INTEGER, FOREIGN KEY(mapLevel) REFERENCES Map(mapLevel) ON UPDATE CASCADE)";
    [_sqlManager performCreateTableQuery:query inDatabase:kDB_NAME];
    
    query = @"CREATE TABLE Edge(mallId INTEGER, mapLevel INTEGER,  cost FLOAT, startNodeId INTEGER, endNodeId INTEGER, FOREIGN KEY(mapLevel) REFERENCES Map(mapLevel) ON UPDATE CASCADE)";
    [_sqlManager performCreateTableQuery:query inDatabase:kDB_NAME];
}

- (void)dropSqlTables{
    NSLog(@"All table has been dropped. Do not expect any data.");
    [_sqlManager performNonSelectQuery:@"DROP TABLE Mall"];
    [_sqlManager performNonSelectQuery:@"DROP TABLE Map"];
    [_sqlManager performNonSelectQuery:@"DROP TABLE Node"];
    [_sqlManager performNonSelectQuery:@"DROP TABLE Edge"];
}

- (void)processPlist
{
    NSString *query = @"";
    //Get all the plist that be converted to sql Data
    NSDictionary *mall0 = [[NSDictionary alloc]initWithDictionary:[PlistHelper getDictionary:@"AyalaCebuData"]];
    NSDictionary *mall1 = [[NSDictionary alloc]initWithDictionary:[PlistHelper getDictionary:@"Glorietta3"]];
    NSDictionary *mall2 = [[NSDictionary alloc]initWithDictionary:[PlistHelper getDictionary:@"Glorietta4"]];
    NSDictionary *mall3 = [[NSDictionary alloc]initWithDictionary:[PlistHelper getDictionary:@"Glorietta5"]];
    NSArray *listMall = [[NSArray alloc]initWithObjects:mall0,mall1,mall2,mall3, nil];
    
    //Convert plists data to sqlData
    for (NSDictionary *data in listMall) {
        NSString *tempName = [data objectForKey:@"name"];
        NSLog(@"Mall name:%@", tempName);
        int mallId = [[data objectForKey:@"uniqueId"] intValue];
        
        //Create Mall entry
        query = [NSString stringWithFormat:@"INSERT INTO Mall(uniqueId,MallName) VALUES(%d,\"%@\")",mallId,tempName];
        [_sqlManager performNonSelectQuery:query];
        
        //Create Map entry with mall as reference
        int zAxis = 0;
        for(int x=1; x<=[[data objectForKey:@"maps"]count]; x++){
            NSDictionary *temp = [[data objectForKey:@"maps"] objectAtIndex:x-1];
            NSString *svgName = [temp objectForKey:@"svgName"];
            query = [NSString stringWithFormat:@"INSERT INTO Map VALUES(%d,%d,\"%@\")",mallId,x,svgName];
            [_sqlManager performNonSelectQuery:query];
            
            NSArray *nodes = [temp objectForKey:@"nodes"];
            for(NSDictionary *tempEntry in nodes){
                int uId = [[tempEntry objectForKey:@"id"] intValue];
                NSString *name = [tempEntry objectForKey:@"name"];
                NSString *coor = [tempEntry objectForKey:@"coor"];
                query = [NSString stringWithFormat:@"INSERT INTO Node VALUES(%d,%d,%d,%f,\"%@\",\"%@\",%d,%d)",mallId,x,uId,100000.0f,name,coor,zAxis,-1];
                [_sqlManager performNonSelectQuery:query];
            }
            
            NSArray *edges = [temp objectForKey:@"edges"];
            for(NSDictionary *tempEntry in edges){
                int startId = [[tempEntry objectForKey:@"startId"] intValue];
                int endId = [[tempEntry objectForKey:@"endId"] intValue];
                query = [NSString stringWithFormat:@"INSERT INTO Edge VALUES(%d,%d,%f,%d,%d)",x,mallId,-1.0f,startId,endId];
                [_sqlManager performNonSelectQuery:query];
            }
            
            NSArray *waypoints = [temp objectForKey:@"waypoints"];
            for(NSDictionary *tempEntry in waypoints){
                int startId = [[tempEntry objectForKey:@"startId"] intValue];
                int endId = [[tempEntry objectForKey:@"endId"] intValue];
                query = [NSString stringWithFormat:@"INSERT INTO Edge VALUES(%d,%f,%d,%d)",x,-1.0f,startId,endId];
                [_sqlManager performNonSelectQuery:query];
            }
            zAxis ++;
        }
    }
}

- (void)dealloc{
    NSLog(@"%@ deallocated!",[self class]);
}
@end
