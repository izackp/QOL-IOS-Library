//
//  InAppTransactions.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 8/06/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "InAppTransactions.h"
#import <StoreKit/StoreKit.h>
#import "ProgressHUDWrapper.h"
#import "UIAlertView+Shortcuts.h"
#import "NSObject+Shortcuts.h"

@interface InAppTransactions () <SKPaymentTransactionObserver, SKProductsRequestDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) SKProductsRequest* productRequester;
@property (nonatomic, strong) NSString* currentProductId;
@property (nonatomic, copy) purchaseSuccess successBlock;
@property (nonatomic, copy) purchaseCanceled canceledBlock;
@property (nonatomic, copy) purchaseFailed failedBlock;

@end


@implementation InAppTransactions

#pragma mark - Singleton Stuff
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[InAppTransactions alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:sharedInstance];
        [sharedInstance updateTransactionsClearPurchasing:true];
    });
    return sharedInstance;
}

#pragma mark - Public API
- (void)askToPurchase:(NSString*)productId msg:(NSString*)message success:(purchaseSuccess)successBlock canceled:(purchaseCanceled)canceledBlock failed:(purchaseFailed)failedBlock {
    
    bool success = [self copyBlocksProductId:productId success:successBlock canceled:canceledBlock failed:failedBlock];
    if (!success)
        return;
    
    UIAlertView* alert = [UIAlertView showQuestion:message];
    alert.delegate = self;
}

- (void)buyProductWithId:(NSString*)productId success:(purchaseSuccess)successBlock canceled:(purchaseCanceled)canceledBlock failed:(purchaseFailed)failedBlock {
    
    bool success = [self copyBlocksProductId:productId success:successBlock canceled:canceledBlock failed:failedBlock];
    if (!success)
        return;
    
#if TARGET_IPHONE_SIMULATOR
    [self incrementPuchaseForId:productId];
    [self callSuccessBlock];
    return;
#endif
    
    [self startProductRequest];
}

//TODO: does 2 things should do 1
- (bool)copyBlocksProductId:(NSString*)productId success:(purchaseSuccess)successBlock canceled:(purchaseCanceled)canceledBlock failed:(purchaseFailed)failedBlock {
//    bool notProcessingAnyTransactions = ([self transactionCount] == 0);
//    if (notProcessingAnyTransactions)
//        [self clearBlocks];
    
    [self updateTransactionsClearPurchasing:true];

//    if (self.successBlock != nil)
//    {
//        if (failedBlock)
//            failedBlock([self errorWithCode:2 andLocalizedDescription:@"Purchase already in progress"]);
//        return false;
//    }
//    
    if (![SKPaymentQueue canMakePayments])
    {
        if (failedBlock)
            failedBlock([self errorWithCode:1 andLocalizedDescription:@"Cannot make payments"]);
        return false;
    }
    
    [_productRequester cancel];
    self.productRequester = nil;
    self.currentProductId = productId;
    self.successBlock = successBlock;
    self.canceledBlock = canceledBlock;
    self.failedBlock = failedBlock;
    return true;
}

- (void)restorePurchases {
    if (![SKPaymentQueue canMakePayments])
        return;
    
    SKPaymentQueue* paymentQueue = [SKPaymentQueue defaultQueue];
    [paymentQueue restoreCompletedTransactions];
}

- (void)startProductRequest {
    NSSet* set = [NSSet setWithObject:_currentProductId];
    
    self.productRequester = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    _productRequester.delegate = self;
    
    [_productRequester start];
    [ProgressHUDWrapper show:@"Connecting to iTunes"];
    [self performSelector:@selector(productRequesterTimeout) withObject:nil afterDelay:15];
}

- (void)productRequesterTimeout {
    [ProgressHUDWrapper showErrorBriefly:@"Could not connect to iTunes"];
    [self callCancelBlock];
}

#pragma mark - SKProductsRequestDelegate Protocol
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    [ProgressHUDWrapper dismiss];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(productRequesterTimeout) object:nil];
    
    if ([response.products count] == 0)
    {
        NSLog(@"Invalid Product Identifier(s): %@", [response.invalidProductIdentifiers description]);
        NSLog(@"Product request failed: %@", [response debugDescription]);
        
        if (_isDebugging)
        {
            [UIAlertView showAlertWithTitle:@"Unable to purchase content" andMessage:@"Invalid product ID, but, since this is a debug build, we'll pretend this didn't happen."];
            if (_currentProductId != nil)
                [self incrementPuchaseForId:_currentProductId];
            [self callSuccessBlock];
        }
        else
        {
            [self purchaseFailed:@"Unable to purchase content" error:[self errorWithCode:3 andLocalizedDescription:@"Invalid product ID"] transaction:nil];
        }
        return;
    }

    SKProduct *selectedProduct = response.products[0];
    SKPayment *payment = [SKPayment paymentWithProduct:selectedProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    [self updateTransactionsClearPurchasing:false];
}

- (void)updateTransactionsClearPurchasing:(bool)shouldClearPurchasing {
    NSArray* transactions = [[SKPaymentQueue defaultQueue] transactions];
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                if (shouldClearPurchasing)
                    [self failedTransaction:transaction];
                break;
        }
    }
}

- (NSUInteger)transactionCount {
    NSArray* transactions = [[SKPaymentQueue defaultQueue] transactions];
    return [transactions count];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        [self callCancelBlock];
        return;
    }
    
#if TARGET_IPHONE_SIMULATOR
    if (_currentProductId != nil)
        [self incrementPuchaseForId:_currentProductId];
    [self callSuccessBlock];
    return;
#endif
    
    [self startProductRequest];
}

#pragma mark - SKPaymentTransactionWrapper Methods
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"Restoration Success");
    [UIAlertView showMessage:@"Restoration Successful"];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
    [self purchaseFailed:@"Unable to restore purchased content" error:error transaction:nil];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [self restoreTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSString* productId = transaction.payment.productIdentifier;
    
    [self incrementPuchaseForId:productId];
    
    if ([productId isEqualToString:_currentProductId])
        [self callSuccessBlock];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    NSString* failedTitle = nil;
    
    if (transaction.error.code != SKErrorPaymentCancelled)
        failedTitle = @"Unable to purchase content";

    NSString* productId = transaction.payment.productIdentifier;
    if ([productId isEqualToString:_currentProductId])
        [self purchaseFailed:failedTitle error:transaction.error transaction:transaction];
}

- (void)purchaseFailed:(NSString*)title error:(NSError*)error transaction:(SKPaymentTransaction *)transaction {
    NSLog(@"Purchase Failed: %@ - %@", title, [error localizedDescription]);
    
    if (title)
        [UIAlertView showAlertWithTitle:title andMessage:[error localizedDescription]];
    
    if (transaction)
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [self callFailureBlock:nil];
}

- (NSDictionary*)userDefaultSavedPurchases {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* dic = [userDefaults objectForKey:@"puchasedIds"];
    if (dic == nil)
        dic = [NSDictionary new];
    return dic;
}

- (void)incrementPuchaseForId:(NSString*)productId {
    NSNumber* finalNumPurchases = @([self purchaseCount:productId] + 1);
    NSMutableDictionary* purchases = [[self userDefaultSavedPurchases] mutableCopy];
    purchases[productId] = finalNumPurchases;
    [self userDefaultSavePurchases:purchases];
}

- (NSUInteger)purchaseCount:(NSString *)productId {
    NSDictionary* purchases = [self userDefaultSavedPurchases];
    NSNumber* numPurchases = purchases[productId];
    if (numPurchases == nil)
        return 0;
    
    return [numPurchases unsignedIntegerValue];
}

- (void)userDefaultSavePurchases:(NSDictionary*)dic {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dic forKey:@"puchasedIds"];
    [userDefaults synchronize];
}

- (void)callSuccessBlock {
    if (_successBlock)
        _successBlock();
    [self clearBlocks];
}

- (void)callCancelBlock {
    [_productRequester cancel];
    self.productRequester = nil;
    if (_canceledBlock)
        _canceledBlock();
    [self clearBlocks];
}

- (void)callFailureBlock:(NSError*)error {
    if (_failedBlock)
        _failedBlock(error);
    [self clearBlocks];
}

- (void)clearBlocks {
    self.currentProductId = nil;
    self.successBlock = nil;
    self.canceledBlock = nil;
    self.failedBlock = nil;
}

@end
