//
//  HCHomeViewController.swift
//  RxXMLY
//
//  Created by sessionCh on 2017/12/14.
//  Copyright © 2017年 sessionCh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import TYPagerController

// MARK:- 常量
fileprivate struct Metric {
    
    static let searchBarLeft: CGFloat = 12.0
    static let searchBarRight: CGFloat = 12.0
    
    static let pagerBarFontSize = UIFont.systemFont(ofSize: 15.0)
    static let pagerBarHeight: CGFloat = 38.0
}

class HCHomeViewController: HCBaseViewController {
    
    private var myTitleView: UIView?
    private var previousX: CGFloat = 0.0
    private var currentX: CGFloat = 0.0

    private let titles: [String] = ["分类", "推荐", "精品", "直播", "广播"]
    private let pageVC = TYTabPagerController().then {
        $0.pagerController.scrollView?.backgroundColor = kThemeGainsboroSmokeColor
        $0.tabBar.layout.cellWidth = kScreenW * 0.2
        $0.tabBar.layout.progressColor = kThemeTomatoColor
        $0.tabBar.layout.selectedTextColor = kThemeTomatoColor
        $0.tabBar.backgroundColor = kThemeGainsboroSmokeColor
        $0.tabBar.layout.cellSpacing = 0
        $0.tabBar.layout.cellEdging = 0
        $0.tabBar.layout.normalTextFont = Metric.pagerBarFontSize
        $0.tabBar.layout.selectedTextFont = Metric.pagerBarFontSize
        $0.tabBarHeight = Metric.pagerBarHeight
    }
    private var vcs: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTitleView()
        
        initPageController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        myTitleView?.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-0.5) // 修正偏差
            make.left.equalToSuperview().offset(Metric.searchBarLeft)
            make.right.equalToSuperview().offset(-Metric.searchBarRight)
        }
    }
}

// MARK:- 初始化协议
extension HCHomeViewController: HCNavTitleable {
    
    // MARK:- 标题组件
    private func initTitleView() {
        
        let homeNavBar = HCHomeNavBar()
        homeNavBar.itemClicked = { [weak self] (model) in
            
            let type = model.type
            switch type {
            case .homeSearchBar:
                self?.jump2SearchResult()
                break
            default: break
            }
        }
        myTitleView = self.titleView(titleView: homeNavBar)
    }
    
    // MARK:- 分页控制器
    private func initPageController() {
        
        addChildViewController(pageVC)
        view.addSubview(pageVC.view)
        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        pageVC.reloadData()
        
        // 设置起始页
        pageVC.pagerController.scrollToController(at: 1, animate: false)
    }

}

// MARK:- 分页控制器协议
extension HCHomeViewController: TYTabPagerControllerDelegate, TYTabPagerControllerDataSource {
    
    func numberOfControllersInTabPagerController() -> Int {
        return titles.count
    }
    
    func tabPagerController(_ tabPagerController: TYTabPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
 
        if index == 1 {
            let recommendVC = HCRecommendViewController()
            recommendVC.view.backgroundColor = kThemeSnowColor
            return recommendVC
        }
        let vc = UIViewController()
        vc.view.backgroundColor = kThemeWhiteColor
        return vc
    }
    
    func tabPagerController(_ tabPagerController: TYTabPagerController, titleFor index: Int) -> String {
        return titles[index]
    }
}

// MARK:- 控制器跳转
extension HCHomeViewController {
    
    // MARK:- 搜索结果
    func jump2SearchResult() {
        
        let searchResult = HCBaseNavigationController(rootViewController: HCSearchController())
        self.present(searchResult, animated: false, completion: nil)
    }
}