//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000

#import "UIScrollView+MJRefresh.h"
#import "UIScrollView+MJExtension.h"
#import "UIView+MJExtension.h"

#import "MJRefreshNormalHeader.h"
#import "MJRefreshGifHeader.h"

#import "MJRefreshBackNormalFooter.h"
#import "MJRefreshBackGifFooter.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshAutoGifFooter.h"

/**

1,<自定义header的动画图片>  设置state状态下的动画图片images 动画持续时间duration
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;













*/
