//
//  UITabBarItem+Statistic.m
//  RFStatistics
//
//  Created by wiseweb on 16/12/13.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UITabBarItem+Statistic.h"
#import <objc/runtime.h>

@implementation UITabBarItem (Statistic)

+ (void)load {
    Method origion = class_getInstanceMethod([self class], @selector(initWithTabBarSystemItem:tag:));
    Method custom = class_getInstanceMethod([self class], @selector(rf_initWithTabBarSystemItem:tag:));
    method_exchangeImplementations(origion, custom);
    
    Method origion2 = class_getInstanceMethod([self class], @selector(initWithTitle:image:tag:));
    Method custom2 = class_getInstanceMethod([self class], @selector(rf_initWithTitle:image:tag:));
    method_exchangeImplementations(origion2, custom2);
    
    Method origion3 = class_getInstanceMethod([self class], @selector(initWithTitle:image:selectedImage:));
    Method custom3 = class_getInstanceMethod([self class], @selector(rf_initWithTitle:image:selectedImage:));
    method_exchangeImplementations(origion3, custom3);
}

- (instancetype)rf_initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image tag:(NSInteger)tag{
    [self rf_initWithTitle:title image:image tag:tag];
    self.rf_tabbarTitle = title;
    return self;
}

- (instancetype)rf_initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage {
    [self rf_initWithTitle:title image:image selectedImage:selectedImage];
    self.rf_tabbarTitle = title;
    return self;
}

- (instancetype)rf_initWithTabBarSystemItem:(UITabBarSystemItem)systemItem tag:(NSInteger)tag {
    [self rf_initWithTabBarSystemItem:systemItem tag:tag];

    switch (systemItem) {
        case 0:
            self.rf_tabbarTitle = @"More";
            break;
        case 1:
            self.rf_tabbarTitle = @"Favorites";
            break;
        case 2:
            self.rf_tabbarTitle = @"Featured";
            break;
        case 3:
            self.rf_tabbarTitle = @"TopRated";
            break;
        case 4:
            self.rf_tabbarTitle = @"Recents";
            break;
        case 5:
            self.rf_tabbarTitle = @"Contacts";
            break;
        case 6:
            self.rf_tabbarTitle = @"History";
            break;
        case 7:
            self.rf_tabbarTitle = @"Bookmarks";
            break;
        case 8:
            self.rf_tabbarTitle = @"Search";
            break;
        case 9:
            self.rf_tabbarTitle = @"Downloads";
            break;
        case 10:
            self.rf_tabbarTitle = @"MostRecent";
            break;
  
        default:
            self.rf_tabbarTitle = @"MostViewed";
            break;
    }
    return self;
}

- (void)setRf_tabbarTitle:(NSString *)rf_tabbarTitle {
    objc_setAssociatedObject(self, @selector(rf_tabbarTitle),rf_tabbarTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)rf_tabbarTitle {
    return objc_getAssociatedObject(self, @selector(rf_tabbarTitle));
}

@end
