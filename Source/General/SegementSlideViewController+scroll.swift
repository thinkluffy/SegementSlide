//
//  SegementSlideViewController+scroll.swift
//  SegementSlide
//
//  Created by Jiar on 2019/1/16.
//  Copyright © 2019 Jiar. All rights reserved.
//

import UIKit

extension SegementSlideViewController {
    
    internal func parentScrollViewDidScroll(_ scrollView: UIScrollView, scrollUp: Bool) {
        defer {
            scrollViewDidScroll(scrollView, isParent: true, scrollUp: scrollUp)
        }
        let parentContentOffsetY = segementSlideScrollView.contentOffset.y
        switch innerBouncesType {
        case .parent:
            if !canParentViewScroll {
                segementSlideScrollView.contentOffset.y = headerStickyHeight
                canChildViewScroll = true
                return
            } else if parentContentOffsetY >= headerStickyHeight {
                segementSlideScrollView.contentOffset.y = headerStickyHeight
                canParentViewScroll = false
                canChildViewScroll = true
                return
            }
        case .child:
            let childBouncesTranslationY = -scrollView.panGestureRecognizer.translation(in: scrollView).y.rounded(.up)
            defer {
                lastChildBouncesTranslationY = childBouncesTranslationY
            }
            if !canParentViewScroll {
                segementSlideScrollView.contentOffset.y = headerStickyHeight
                canChildViewScroll = true
                return
            } else if parentContentOffsetY >= headerStickyHeight {
                segementSlideScrollView.contentOffset.y = headerStickyHeight
                // Fix a Bug
                //
                // [Scenario]
                // For short content, scrollView can scroll up but never scroll down
                //
                // [Solution]
                // For short content scrollView, after set canParentViewScroll to false and canChildViewScroll to true,
                // content scrollView will never scroll, the ui can not scroll down any more.
                // Only set canParentViewScroll to false when content scroll view is long enouth
                guard let childScrollView = currentSegementSlideContentViewController?.scrollView else { return }
                if childScrollView.bounds.height < childScrollView.contentSize.height {
                    canParentViewScroll = false
                    canChildViewScroll = true
                }
                return
            } else if parentContentOffsetY <= 0 {
                segementSlideScrollView.contentOffset.y = 0
                canChildViewScroll = true
            } else {
                guard let childScrollView = currentSegementSlideContentViewController?.scrollView else { return }
                if childScrollView.contentOffset.y < 0 {
                    if childBouncesTranslationY > lastChildBouncesTranslationY {
                        segementSlideScrollView.contentOffset.y = 0
                        canChildViewScroll = true
                    } else {
                        canChildViewScroll = false
                    }
                } else {
                    canChildViewScroll = false
                }
            }
        }
        resetChildViewControllerContentOffsetY()
    }
    
    internal func childScrollViewDidScroll(_ childScrollView: UIScrollView, scrollUp: Bool) {
        defer {
            scrollViewDidScroll(childScrollView, isParent: false, scrollUp: scrollUp)
        }
        let parentContentOffsetY = segementSlideScrollView.contentOffset.y
        let childContentOffsetY = childScrollView.contentOffset.y
        switch innerBouncesType {
        case .parent:
            if !canChildViewScroll {
                childScrollView.contentOffset.y = 0
            } else if childContentOffsetY <= 0 {
                canChildViewScroll = false
                canParentViewScroll = true
            }
        case .child:
            if !canChildViewScroll {
                childScrollView.contentOffset.y = 0
            } else if childContentOffsetY <= 0 {
                if parentContentOffsetY <= 0 {
                    canChildViewScroll = true
                }
                canParentViewScroll = true
            } else {
                if parentContentOffsetY > 0 && parentContentOffsetY < headerStickyHeight {
                    canChildViewScroll = false
                }
            }
        }
    }
    
}
