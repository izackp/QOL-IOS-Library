//
//  TableViewCellCache.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "TableViewCellCache.h"

@interface TableViewCellCache ()

@property (assign, nonatomic) NSInteger lastPosition;
@property (assign, nonatomic) long offsetPosition;
@property (strong, nonatomic) NSMutableArray* cache;

@end

@implementation TableViewCellCache

- (id)init {
    if (self = [super init])
    {
        self.cache = [[NSMutableArray alloc] init];
        self.offsetPosition = 0;
        self.cacheSize = 0;
        self.padding = 0;
    }
    return self;
}

- (void)reloadCacheWithSize:(uint)cacheSize {
    _cacheSize = cacheSize;
    [self reloadCache];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)index {
    [self tryToRefreshCacheWithIndex:index];
    return [self cellFromCacheAtIndex:index];
}

- (UITableViewCell *)cellFromCacheAtIndex:(NSIndexPath *)index {
    long actualPostion = index.row - _offsetPosition;
    
    if ([_cache count] <= actualPostion)
    {
        //NSLog(@"Retreving cell from delegate for row: %i offset: %i and pos: %i  (Exceeded Cache with count: %i)", index.row, _offsetPosition, actualPostion, [_cache count]);
        return [_delegate tableViewCellCache:self cellForRowAtIndexPath:index];
    }
    
    UITableViewCell* cachedCell = [_cache objectAtIndex:actualPostion];
    if (cachedCell)
    {/*
                NSLog(@"Retreving cell from cache for row: %i offset: %i and pos: %i", index.row, _offsetPosition, actualPostion);
        
        bool isVerified = true;
        UITableViewCell* cellToVerifyWith = [_delegate tableViewCellCache:self cellForRowAtIndexPath:index];
        if (cellToVerifyWith != nil)
            if (cachedCell.tag != cellToVerifyWith.tag)
                isVerified = false;
        if (isVerified == false)
            NSLog(@"Failed Verificiation for retreived cell. Cached cell is %i and V Cell is %i", cachedCell.tag, cellToVerifyWith.tag);
        */
        return cachedCell;
    }
    else {
        //NSLog(@"Retreving cell from delegate for row: %i", index.row);
        cachedCell = [_delegate tableViewCellCache:self cellForRowAtIndexPath:index];
        [_cache replaceObjectAtIndex:actualPostion withObject:cachedCell];
        return cachedCell;
    }
}

- (void)tryToRefreshCacheWithIndex:(NSIndexPath *)index {
    
    _lastPosition = index.row;
    bool isBreach = [self doesPositionBreachPadding:index.row];
    
    if (isBreach)
        [self updateCacheWithIndex:index];
    
    if ([_delegate tableViewCellCacheIsAtGoodPointForRefresh:self])
        [self updateCacheWithIndex:index];
}

- (void)updateCacheWithIndex:(NSIndexPath*)index {
    long currentPosition = index.row;
    NSMutableArray* newCache = [[NSMutableArray alloc] initWithCapacity:_cache.count];
    uint halfCacheSize = _cacheSize * 0.5;
    long bottomPosition = currentPosition - halfCacheSize;
    long topPosition = currentPosition + halfCacheSize;
    
    if (bottomPosition < 0)
    {
        bottomPosition = 0;
        topPosition = _cacheSize;
    }
    
    if (bottomPosition == _offsetPosition && [_cache count] > 0)
    {
        //NSLog(@"Not Updating cache - We just cached bot pos: %i", bottomPosition);
        return;
    }
    
    //NSLog(@"Updating cache for row: %i, bot: %i, top: %i, size: %i", currentPosition, bottomPosition, topPosition, _cacheSize);
    
    for (long i = bottomPosition; i < topPosition; i++)
    {
        NSIndexPath* index = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = [self cellFromCacheAtIndex:index];
        if (cell != nil)
            [newCache addObject:cell];
        else
        {
            //NSLog(@"Stopping cache update, delegate returned nil for row: %i", i);
            break;
        }
    }
    
    _offsetPosition = bottomPosition;
    self.cache = newCache;
    /*
    NSLog(@"Cached %i cells:", [_cache count]);
    for (int i = 0; i < [_cache count]; i++)
        NSLog(@"cell %i is %i", i, [[_cache objectAtIndex:i] tag]);*/
}

- (bool)doesPositionBreachPadding:(long)position {
    long relativePos = position - _offsetPosition;
    long upperBounds = [_cache count] - _padding;//10 - 2 = 8
    long lowerBounds = _padding; //0 + 2 = 2
    if (relativePos >= upperBounds)
        return true;
    
    if (relativePos <= lowerBounds)
        return true;
    return false;
}

- (void)reloadCache {
    [self tryToRefreshCacheWithIndex:[NSIndexPath indexPathForRow:_offsetPosition + (_cacheSize * 0.5) inSection:0]];
}

- (void)clear {
    
    [_cache removeAllObjects];
}

@end
