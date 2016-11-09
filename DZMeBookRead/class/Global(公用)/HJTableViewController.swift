//
//  HJTableViewController.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/1.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJTableViewController: HJViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView:HJTableView!                              // tableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        // 初始化TableView
        initTableView(.grouped)
    }
    
    // 初始化TableView
    func initTableView(_ style:UITableViewStyle) {
        
        tableView = HJTableView(frame: CGRect(x: 0, y: NavgationBarHeight, width: ScreenWidth, height: ViewHeight(false, tabBarHidden: true)), style: style)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        view.addSubview(tableView)
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.scrollViewWillDisplayCell(cell)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
