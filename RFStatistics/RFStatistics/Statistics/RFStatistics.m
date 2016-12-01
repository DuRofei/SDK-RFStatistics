//
//  RFStatistics.m
//  RFStatistics
//
//  Created by wiseweb on 28/11/16.
//  Copyright © 2016 wiseweb. All rights reserved.
//

#import "RFStatistics.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation RFStatistics

+ (instancetype)sharedInstance
{
    static RFStatistics *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc]init];
    });

    return _sharedInstance;
}

- (id)displayIdentifier:(id)source
{
    if ([source isKindOfClass:[UIView class]]) {
        for (UIView *next = [source superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                return (id)nextResponder;
            } else if ([nextResponder isKindOfClass:[UIApplication class]]) {
                return [[UIApplication sharedApplication] topMostViewController];
            }
        }
    } else if ([source isKindOfClass:[UIGestureRecognizer class]]) {
        UIGestureRecognizer *gestureSource = (UIGestureRecognizer *)source;
        if ([gestureSource.view isKindOfClass:[NSClassFromString(@"_UIAlertControllerView") class]]) {
            return gestureSource.view;
        }
        
        return [self displayIdentifier:gestureSource.view];
    }
    
    return nil;
}

//viewController_UIControl_action_target
- (void)rf_analyticsSource:(id)source action:(SEL)action target:(id)target
{
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    
    if ([target isKindOfClass:[NSClassFromString(@"UIInterfaceActionSelectionTrackingController") class]]) {//iOS10 UIAlertController内部实现变了，所以写成这样
        Ivar ivar = class_getInstanceVariable([target class], "_representationViews");
        NSMutableArray *representationViews =  object_getIvar(target, ivar);
        UIGestureRecognizer *gesture = source;
        
        for (UIView *representationView in representationViews) {
            
            CGPoint point = [gesture locationInView:representationView];
            
            if (point.x >= 0 && point.x <= CGRectGetWidth(representationView.bounds) &&
                point.y >= 0 && point.y <= CGRectGetHeight(representationView.bounds) &&
                gesture.state == UIGestureRecognizerStateEnded) {
                
                Ivar ivar = class_getInstanceVariable([representationView class], "_actionContentView");
                id actionContentView = object_getIvar(representationView, ivar);
                
                Ivar labelIvar = class_getInstanceVariable([actionContentView class], "_label");
                UILabel *label = object_getIvar(actionContentView, labelIvar);
                
                if (NSStringFromClass([[self displayIdentifier:source] class])) {
                    [identifierString appendString:NSStringFromClass([[self displayIdentifier:source] class])];
                }
                if ([[self displayIdentifier:source] isKindOfClass:[UIAlertController class]]) {
                    id viewControllerUnderAlertController = [[[UIApplication sharedApplication] currentViewController] topMostViewController];
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([viewControllerUnderAlertController class])]];
                }
                if (NSStringFromClass([source class])) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([source class])]];
                }
                if (label.text) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",label.text]];
                }
                if (NSStringFromSelector(action)) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromSelector(action)]];
                }
                if (NSStringFromClass([target class])) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([target class])]];
                }
                
                if (self.analyticsIdentifierBlock) {
                    self.analyticsIdentifierBlock(identifierString);
                }
            }
        }
        
    } else if ([target isKindOfClass:[NSClassFromString(@"_UIAlertControllerView") class]]) {
        
        Ivar ivar = class_getInstanceVariable([target class], "_actionViews");
        NSMutableArray *actionviews =  object_getIvar(target, ivar);
        UIGestureRecognizer *gesture = source;
        
        for (UIView *subview in actionviews) { /*_UIAlertControllerActionView*/
            CGPoint point = [gesture locationInView:subview];
            
            if (point.x >= 0 && point.x <= CGRectGetWidth(subview.bounds) &&
                point.y >= 0 && point.y <= CGRectGetHeight(subview.bounds) &&
                gesture.state == UIGestureRecognizerStateEnded) {
               
                UILabel *titleLabel = [subview performSelector:@selector(titleLabel)];

                if (NSStringFromClass([[self displayIdentifier:source] class])) {
                    [identifierString appendString:NSStringFromClass([[self displayIdentifier:source] class])];
                }
                if ([[self displayIdentifier:source] isKindOfClass:[NSClassFromString(@"_UIAlertControllerView") class]]) {
                    id viewControllerUnderAlertController = [[[UIApplication sharedApplication] currentViewController] topMostViewController];
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([viewControllerUnderAlertController class])]];
                }
                if (NSStringFromClass([source class])) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([source class])]];
                }
                if (titleLabel.text) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",titleLabel.text]];
                }
                if (NSStringFromSelector(action)) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromSelector(action)]];
                }
                if (NSStringFromClass([target class])) {
                    [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([target class])]];
                }
                
                if (self.analyticsIdentifierBlock) {
                    self.analyticsIdentifierBlock(identifierString);
                }
            }
        }
        
    } else {
    
        NSString *titleString = nil;
        NSString *imageNameString = nil;
        NSString *backgroundImageName = nil;
        NSString *selectStateString = nil;
        NSString *tagString = nil;
        
        if ([source isKindOfClass:[UIButton class]]) {
            
            UIButton *btn = (UIButton *)source;
            
            titleString = btn.currentTitle;
            imageNameString = btn.currentImage.imageName;
            backgroundImageName = btn.currentBackgroundImage.imageName;
            selectStateString = [NSString stringWithFormat:@"isSelectState_%@", @(btn.selected)];
            tagString = [NSString stringWithFormat:@"tag_%@", @(btn.tag)];
            
        } else if ([source isKindOfClass:[UIGestureRecognizer class]]) {
            
            UIGestureRecognizer *gestureRecognizer = (UIGestureRecognizer *)source;
            
            if (gestureRecognizer.state == UIGestureRecognizerStateChanged ||
                gestureRecognizer.state == UIGestureRecognizerStateBegan) {
                return;
            }
            
            if ([gestureRecognizer.view isKindOfClass:[UIImageView class]] ) {
                UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
                imageNameString = imageView.image.imageName;
            }
        }
        
        if (NSStringFromClass([[self displayIdentifier:source] class])) {
            [identifierString appendString:NSStringFromClass([[self displayIdentifier:source] class])];
        }
        if (NSStringFromClass([source class])) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([source class])]];
        }
        if (titleString) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@",titleString]];
        }
        if (imageNameString) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@",imageNameString]];
        }
        if (backgroundImageName) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@", backgroundImageName]];
        }
        if (selectStateString) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@", selectStateString]];
        }
        if (tagString) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@", tagString]];
        }
        if (NSStringFromSelector(action)) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromSelector(action)]];
        }
        if (NSStringFromClass([target class])) {
            [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([target class])]];
        }
        
        if (self.analyticsIdentifierBlock) {
            self.analyticsIdentifierBlock(identifierString);
        }
    }
}

- (void)rf_analyticsSource:(id)source didSelectIndexPath:(NSIndexPath *)idxPath target:(id)target
{
    NSString *idxPathString = [NSString stringWithFormat:@"%@-%@", @(idxPath.section), @(idxPath.row)];
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    if (NSStringFromClass([[self displayIdentifier:source] class])) {
        [identifierString appendString:NSStringFromClass([[self displayIdentifier:source] class])];
    }
    
    if (NSStringFromClass([source class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([source class])]];
    }
  
    if (idxPathString) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",idxPathString]];
    }
   
    if (NSStringFromClass([target class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([target class])]];
    }

    if (self.analyticsIdentifierBlock) {
        self.analyticsIdentifierBlock(identifierString);
    }
}

- (void)rf_analyticsString:(NSString *)identifierString
{
    if (self.analyticsIdentifierBlock) {
        self.analyticsIdentifierBlock(identifierString);
    }
}

@end

@implementation UIAlertAction (AOP)

+ (void)load
{
    Method originalMethod = class_getClassMethod([self class], @selector(actionWithTitle:style:handler:));
    Method swizzledMethod = class_getClassMethod([self class], @selector(rf_actionWithTitle:style:handler:));
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (instancetype)rf_actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertAction *alertAction = [[self class] rf_actionWithTitle:title style:style handler:handler];
    return alertAction;
}

@end




@implementation UIControl (AOP)

+ (void)load
{
    Method initOriginalMethod = class_getInstanceMethod([self class], @selector(sendAction:to:forEvent:));
    Method initSwizzledMethod = class_getInstanceMethod([self class], @selector(rf_sendAction:to:forEvent:));
    
    method_exchangeImplementations(initOriginalMethod, initSwizzledMethod);
}

- (void)rf_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [self rf_sendAction:action to:target forEvent:event];
    [[RFStatistics sharedInstance] rf_analyticsSource:self action:action target:target];
}

@end

@implementation UIGestureRecognizer (AOP)

+ (void)load
{
    Method initOriginalMethod = class_getInstanceMethod([self class], @selector(initWithTarget:action:));
    Method initSwizzledMethod = class_getInstanceMethod([self class], @selector(rf_initWithTarget:action:));
    
    method_exchangeImplementations(initOriginalMethod, initSwizzledMethod);
}

- (instancetype)rf_initWithTarget:(nullable id)target action:(nullable SEL)action
{
    UIGestureRecognizer *selfGestureRecognizer = [self rf_initWithTarget:target action:action];
    
    if (!target && !action) {
        return selfGestureRecognizer;
    }
    
    if ([target isKindOfClass:[UIScrollView class]]) {
        return selfGestureRecognizer;
    }
    
    Class class = [target class];
    
    SEL originalSEL = action;
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"rf_%@", NSStringFromSelector(action)]);
    
    BOOL isAddMethod = class_addMethod(class, swizzledSEL, (IMP)rf_gestureAction, "v@:@");

    if (isAddMethod) {
        Method originalMethod = class_getInstanceMethod(class, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }

    return selfGestureRecognizer;
}

void rf_gestureAction(id self, SEL _cmd, id sender) {
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"rf_%@", NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, sender);
    [[RFStatistics sharedInstance] rf_analyticsSource:sender action:_cmd target:self];
}



@end


@implementation UITableView (AOP)

+ (void)load
{
    Method delegateOriginalMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method delegateSwizzledMethod = class_getInstanceMethod([self class], @selector(rf_setDelegate:));
    
    method_exchangeImplementations(delegateOriginalMethod, delegateSwizzledMethod);
}

- (void)rf_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self rf_setDelegate:delegate];
    
    if (class_addMethod([delegate class], NSSelectorFromString(@"rf_didSelectRowAtIndexPath"), (IMP)rf_didSelectRowAtIndexPath, "v@:@@")) {
        Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], NSSelectorFromString(@"rf_didSelectRowAtIndexPath"));
        Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], @selector(tableView:didSelectRowAtIndexPath:));
        
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
}

void rf_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexPath)
{
    SEL selector = NSSelectorFromString(@"rf_didSelectRowAtIndexPath");
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, selector, tableView, indexPath);
    [[RFStatistics sharedInstance] rf_analyticsSource:tableView didSelectIndexPath:indexPath target:self];
}

@end

@implementation UICollectionView (AOP)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(rf_setDelegate:));
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)rf_setDelegate:(id<UICollectionViewDelegate>)delegate
{
    [self rf_setDelegate:delegate];
    
    if (class_addMethod([delegate class], NSSelectorFromString(@"rf_didSelectItemAtIndexPath"), (IMP)rf_didSelectItemAtIndexPath, "v@:@@")) {
        Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], NSSelectorFromString(@"rf_didSelectItemAtIndexPath"));
        Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], @selector(collectionView:didSelectItemAtIndexPath:));
        
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
}

void rf_didSelectItemAtIndexPath(id self, SEL _cmd, id collectionView, id indexPath)
{
    SEL selector = NSSelectorFromString(@"rf_didSelectItemAtIndexPath");
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, selector, collectionView, indexPath);
    [[RFStatistics sharedInstance] rf_analyticsSource:collectionView didSelectIndexPath:indexPath target:self];
}

@end


@implementation UIImage (imageName)

+ (void)load
{
    //Exchange imageNamed: implementation
    Method imageNameOriginalMethod = class_getClassMethod([self class], @selector(imageNamed:));
    Method imageNameSwizzledMethod = class_getClassMethod([self class], @selector(rf_imageNamed:));
    
    method_exchangeImplementations(imageNameOriginalMethod, imageNameSwizzledMethod);

    //Exchange initWithCoder: implementation in order to get the resource file
    Method initWithCoderOriginalMethod = class_getInstanceMethod(NSClassFromString(@"UIImageNibPlaceholder"), @selector(initWithCoder:));
    Method initWithCoderSwizzledMethod = class_getInstanceMethod([self class], @selector(rf_initWithCoder:));
    
    method_exchangeImplementations(initWithCoderOriginalMethod, initWithCoderSwizzledMethod);
    
    //Exchange imageWithContentsOfFile: implementation
    Method imageWithContentsOfFileOriginalMethod = class_getClassMethod([self class], @selector(imageWithContentsOfFile:));
    Method imageWithContentsOfFileSwizzledMethod = class_getClassMethod([self class], @selector(rf_imageWithContentsOfFile:));
    
    method_exchangeImplementations(imageWithContentsOfFileOriginalMethod, imageWithContentsOfFileSwizzledMethod);
}

- (id)rf_initWithCoder:(NSCoder *)aDecoder
{
    UIImage *image = [self rf_initWithCoder:aDecoder];
    
    NSString *resourceName = [aDecoder decodeObjectForKey:@"UIResourceName"];
    if ([resourceName isKindOfClass:[NSString class]] && resourceName) {
        image.imageName = resourceName;
    }
    return image;
}

+ (nullable UIImage *)rf_imageNamed:(NSString *)name
{
    UIImage *image = [UIImage rf_imageNamed:name];
    image.imageName = name;
    
    return image;
}

+ (nullable UIImage *)rf_imageWithContentsOfFile:(NSString *)path
{
    UIImage *image = [UIImage rf_imageWithContentsOfFile:path];
    
    NSURL *urlPath = [NSURL fileURLWithPath:path];
    NSString *imageName = [[urlPath.lastPathComponent componentsSeparatedByString:@"."] firstObject];
    image.imageName = imageName;
    
    return image;
}


- (NSString *)imageName
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setImageName:(NSString *)imageName
{
    objc_setAssociatedObject(self, @selector(imageName), imageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UIViewController (AOP)

+ (void)load
{
    Method viewDidLoadOriginalMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
    Method viewDidLoadSwizzledMethod = class_getInstanceMethod([self class], @selector(rf_viewDidLoad));

    method_exchangeImplementations(viewDidLoadOriginalMethod, viewDidLoadSwizzledMethod);

    Method viewWillAppearOriginalMethod = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    Method viewWillAppearSwizzledMethod = class_getInstanceMethod([self class], @selector(rf_viewWillAppear:));

    method_exchangeImplementations(viewWillAppearOriginalMethod, viewWillAppearSwizzledMethod);

    Method viewDidAppearOriginalMethod = class_getInstanceMethod([self class], @selector(viewDidAppear:));
    Method viewDidAppearSwizzledMethod = class_getInstanceMethod([self class], @selector(rf_viewDidAppear:));
    
    method_exchangeImplementations(viewDidAppearOriginalMethod, viewDidAppearSwizzledMethod);
    
}

- (void)rf_viewDidLoad
{
    [self rf_viewDidLoad];
    NSString *identifier = [NSString stringWithFormat:@"%@#%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    [[RFStatistics sharedInstance] rf_analyticsString:identifier];
}

- (void)rf_viewWillAppear:(BOOL)animated
{
    [self rf_viewWillAppear:animated];
    NSString *identifier = [NSString stringWithFormat:@"%@#%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    [[RFStatistics sharedInstance] rf_analyticsString:identifier];
}

- (void)rf_viewDidAppear:(BOOL)animated
{
    [self rf_viewDidAppear:animated];
    NSString *identifier = [NSString stringWithFormat:@"%@#%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
    [[RFStatistics sharedInstance] rf_analyticsString:identifier];
}

@end

@implementation UIViewController (TopMostViewController)

- (UIViewController *)topMostViewController
{
    if (self.presentedViewController == nil || [self.presentedViewController isKindOfClass:[UIImagePickerController class]]) {
        
        return self;
        
    } else if ([self.presentedViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [lastViewController topMostViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)self.presentedViewController;
    
    return [presentedViewController topMostViewController];
}

@end

@implementation UIApplication (TopMostViewController)

- (UIViewController *)topMostViewController
{
    return [self.keyWindow.rootViewController topMostViewController];
}

- (UIViewController *)currentViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    return result;
}



@end
