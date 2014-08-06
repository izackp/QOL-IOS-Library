//
//  InAppTransactions.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 8/06/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^purchaseSuccess)();
typedef void (^purchaseFailed)(NSError* error);
typedef void (^purchaseCanceled)();

@interface InAppTransactions : NSObject

+ (instancetype)sharedInstance;
- (void)askToPurchase:(NSString*)productId msg:(NSString*)message success:(purchaseSuccess)successBlock canceled:(purchaseCanceled)canceledBlock failed:(purchaseFailed)failedBlock;
- (void)buyProductWithId:(NSString*)productId success:(purchaseSuccess)successBlock canceled:(purchaseCanceled)canceledBlock failed:(purchaseFailed)failedBlock;
- (NSUInteger)purchaseCount:(NSString*)productId;
- (void)restorePurchases;

@end
