//
//  TableViewCellCache.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

//!!!!!!!! Do not use dequeueReusableCellWithIdentifier  !!!!!
//This class conflicts with dequeueReusableCellWithIdentifier

//TODO: this should also manage allocation of table view cells
//and store them in a pool for improved performance

#import <UIKit/UIKit.h>

@protocol TableViewCellCacheDelegate;

/*! This class was primary created to create a 'preload' cell functionality, so images and other data loaded on the fly can start loading before they become visible on the screen */
@interface TableViewCellCache : NSObject

@property (assign, nonatomic) id <TableViewCellCacheDelegate> delegate;
@property (assign, nonatomic) int cacheSize;
@property (assign, nonatomic) int padding;

- (void)reloadCacheWithSize:(uint)cacheSize;
- (void)clear; //Call before you call reload on table view
- (UITableViewCell*)cellForRowAtIndexPath:(NSIndexPath*)index;

@end

@protocol TableViewCellCacheDelegate <NSObject>

- (UITableViewCell*)tableViewCellCache:(TableViewCellCache*)cache cellForRowAtIndexPath:(NSIndexPath*)index;
- (bool)tableViewCellCacheIsAtGoodPointForRefresh:(TableViewCellCache*)cache;  //return no if the user is scrolling

@end
