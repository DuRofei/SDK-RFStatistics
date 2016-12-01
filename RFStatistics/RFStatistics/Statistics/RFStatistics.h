//
//  RFStatistics.h
//  RFStatistics
//
//  Created by wiseweb on 28/11/16.
//  Copyright © 2016 wiseweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RFStatistics : NSObject

@property (weak, nonatomic) id delegate;
@property (copy, nonatomic) void (^analyticsIdentifierBlock)(NSString *identifier);

+ (instancetype)sharedInstance;

@end

@interface UIAlertAction (AOP)

@end


@interface UIControl (AOP)

@end

@interface UIGestureRecognizer (AOP)

@end

@interface UITableView (AOP)

@end

@interface UICollectionView (AOP)

@end


@interface UIImage (imageName)

@property (nonatomic, copy) NSString *imageName;

@end

@interface UIViewController (AOP)

@end

@interface UIViewController (TopMostViewController)

- (UIViewController *)topMostViewController;

@end


@interface UIApplication (TopMostViewController)

- (UIViewController *)topMostViewController;
- (UIViewController *)currentViewController;

@end


