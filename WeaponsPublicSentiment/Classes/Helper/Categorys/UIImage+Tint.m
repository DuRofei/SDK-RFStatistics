//
//  UIImage+Tint.m
//  WeaponsPublicSentiment
//
//  Created by wiseweb on 16/11/18.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UIImage+Tint.h"

@implementation UIImage (Tint)
- (UIImage *) imageWithTintOriginalColor:(UIColor *)tintColor
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *originalImage = [tintedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return originalImage;
}

@end
