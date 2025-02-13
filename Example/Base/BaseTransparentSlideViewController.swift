//
//  BaseTransparentSlideViewController.swift
//  Example
//
//  Created by Jiar on 2018/12/17.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit
import SegementSlide

class BaseTransparentSlideViewController: TransparentSlideViewController {
    
    private var selectedIndex: Int? = nil

    override var switcherConfig: SegementSlideSwitcherConfig {
        return ConfigManager.shared.switcherConfig
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        super.scrollViewDidScroll(scrollView, isParent: isParent)
        guard isParent else { return }
        updateNavigationBarStyle(scrollView)
    }
    
    private func updateNavigationBarStyle(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > headerStickyHeight {
            slideSwitcherView.layer.applySketchShadow(color: .black, alpha: 0.03, x: 0, y: 2.5, blur: 5)
            slideSwitcherView.layer.add(generateFadeAnimation(), forKey: "reloadSwitcherView")
        } else {
            slideSwitcherView.layer.applySketchShadow(color: .clear, alpha: 0, x: 0, y: 0, blur: 0)
            slideSwitcherView.layer.add(generateFadeAnimation(), forKey: "reloadSwitcherView")
        }
    }
    
    private func generateFadeAnimation() -> CATransition {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.25
        fadeTextAnimation.type = .fade
        return fadeTextAnimation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("\(type(of: self)) - \(String(format: "%p", self)) - \(#function)")
        view.backgroundColor = .white
        if Bool.random() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "reload", style: .plain, target: self, action: #selector(reloadAction))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "more", style: .plain, target: self, action: #selector(moreAction))
        }
    }
    
    @objc private func reloadAction() {
        selectedIndex = currentIndex
        reloadData()
        if let selectedIndex = selectedIndex {
            scrollToSlide(at: selectedIndex, animated: false)
        } else {
            scrollToSlide(at: 1, animated: false)
        }
        selectedIndex = nil
    }
        
    @objc private func moreAction() {
        let viewController: UIViewController
        switch Int.random(in: 0..<8) {
        case 0..<4:
            viewController = NoticeViewController(selectedIndex: Int.random(in: 0..<DataManager.shared.noticeLanguageTitles.count))
        case 4:
            viewController = PostViewController(selectedIndex: Int.random(in: 0..<DataManager.shared.postLanguageTitles.count))
        case 5:
            viewController = HomeViewController()
        case 6:
            viewController = ExploreViewController()
        case 7:
            viewController = MineViewController()
        default:
            viewController = NoticeViewController(selectedIndex: Int.random(in: 0..<DataManager.shared.noticeLanguageTitles.count))
        }
        viewController.hidesBottomBarWhenPushed = Bool.random()
        navigationController?.pushViewController(viewController, animated: true)
    }

}
