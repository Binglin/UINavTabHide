//
//  UINavTabInteraction.m
//  HideNavTab
//
//  Created by 郑林琴 on 15/8/16.
//  Copyright (c) 2015年 BL. All rights reserved.
//

#import "UINavTabInteraction.h"

@interface UINavTabInteraction (){
    UIEdgeInsets _originEdgeInset;
    CGFloat _lastOffset;
}

@end
@implementation UINavTabInteraction

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.isDragging == NO) {
        _lastOffset = 0;
        return;
    }
    CGPoint contentOffset = scrollView.contentOffset;
    
    
    //scroll向上
    CGFloat moveLY = contentOffset.y - _lastOffset ;
    
    //拉倒底部
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - CGRectGetHeight(scrollView.frame)) {
        return;
    }
    //顶部
    if (scrollView.contentOffset.y <= -_originEdgeInset.top) {
        return;
    }
    
    CGFloat _navOriginY = CGRectGetMinY(self.operationVC.navigationController.navigationBar.frame);
    _navOriginY -= moveLY;
    self.operationVC.navigationController.navigationBar.frame = ({
        CGRect frame = self.operationVC.navigationController.navigationBar.frame;
        if (_navOriginY < -CGRectGetHeight(self.operationVC.navigationController.navigationBar.frame)) {
            _navOriginY = -CGRectGetHeight(self.operationVC.navigationController.navigationBar.frame);
        }
        if (_navOriginY >= 20.f) {
            _navOriginY = 20.f;
        }
        frame.origin.y = _navOriginY;
        frame;
    });
    
    self.operationVC.tabBarController.tabBar.frame = ({
        CGRect frame = self.operationVC.tabBarController.tabBar.frame;
        frame.origin.y += moveLY;
        
        if (CGRectGetMinY(frame) > [UIScreen mainScreen].bounds.size.height) {
            frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        }else if (CGRectGetMinY(frame) <= [UIScreen mainScreen].bounds.size.height - CGRectGetHeight(self.operationVC.tabBarController.tabBar.frame)){
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - CGRectGetHeight(self.operationVC.tabBarController.tabBar.frame);
        }
        frame;
    });
    
    scrollView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.operationVC.navigationController.navigationBar.frame), 0,    [UIScreen mainScreen].bounds.size.height - CGRectGetMinY(self.operationVC.tabBarController.tabBar.frame), 0);
    scrollView.scrollIndicatorInsets = scrollView.contentInset;
    _lastOffset = contentOffset.y;
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    _lastOffset  = scrollView.contentOffset.y;
    static BOOL isSet = NO;
    if (isSet == NO) {
        _originEdgeInset = scrollView.contentInset;
        isSet = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat navMaxY = CGRectGetMaxY(self.operationVC.navigationController.navigationBar.frame);
    CGFloat navHeight = 64.f;
    if (navMaxY < navHeight / 2.f) {
        if (navMaxY > 0) {
            [UIView animateWithDuration:0.2f animations:^{
                self.operationVC.navigationController.navigationBar.frame = ({ CGRect frame = self.operationVC.navigationController.navigationBar.frame;
                    frame.origin.y = -CGRectGetHeight(self.operationVC.navigationController.navigationBar.frame);
                    frame;
                });
                
                self.operationVC.tabBarController.tabBar.frame = ({
                    CGRect frame = self.operationVC.tabBarController.tabBar.frame;
                    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
                    frame;
                });
                
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        }
    }else{
        [UIView animateWithDuration:0.2f animations:^{
            self.operationVC.navigationController.navigationBar.frame = ({ CGRect frame = self.operationVC.navigationController.navigationBar.frame;
                frame.origin.y = 20.f;
                frame;
            });
            
            self.operationVC.tabBarController.tabBar.frame = ({
                CGRect frame = self.operationVC.tabBarController.tabBar.frame;
                frame.origin.y = [UIScreen mainScreen].bounds.size.height - CGRectGetHeight(frame) ;
                frame;
            });
            
            scrollView.contentInset = _originEdgeInset;
        }];
    }
}



@end
