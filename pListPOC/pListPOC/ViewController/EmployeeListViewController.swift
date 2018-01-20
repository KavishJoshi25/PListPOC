//
//  EmployeeListViewController.swift
//  pListPOC
//
//  Created by Kavish joshi on 20/01/18.
//  Copyright © 2018 Kavish joshi. All rights reserved.
//

import Foundation
import UIKit


class EmployeeListViewController: UIViewController {
    
    @IBOutlet weak var employeeTableView: UITableView!
    
    let pListArray = NSMutableArray()
    var pListObj = NSMutableDictionary()
    
    let reuseIdentifier = "tCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initalizeUiComponents()
    }
    
    func initalizeUiComponents(){
        
         //UItable view
        employeeTableView.delegate = self
        employeeTableView.dataSource = self
        employeeTableView.register(EmployeeListViewControllerCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        employeeTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([employeeTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),employeeTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),employeeTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),employeeTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0)])
       
        //Adding title to navigation bar
        self.navigationItem.title = "Employee List"
        
        //Adding button to navigation Bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.done, target: self, action: #selector(addButtonPressed))
        
    }
    
    //Mark:addButtonPressed
    @objc func addButtonPressed()  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(withIdentifier: "EmployeeFormViewController") as! EmployeeFormViewController
        detailsViewController.pListUpdatedelegate = self
        navigationController?.pushViewController(detailsViewController,
                                                 animated: true)
    }
}

extension EmployeeListViewController:updatePListDelegate{
    func refreshPList(data: NSMutableDictionary) {
        pListArray.add(data)
        employeeTableView.reloadData()
    }
}

extension EmployeeListViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EmployeeListViewControllerCell
        cell.backgroundColor = .black
//        if !cell.contentView.subviews.isEmpty {
//            for subview: UIView in cell.contentView.subviews {
//                subview.removeFromSuperview()
//            }
//        }
        
         pListObj = pListArray[indexPath.row] as! NSMutableDictionary
        
        cell.name.text = pListObj.value(forKey: "FullName") as? String
        cell.mobileNumber.text = pListObj.value(forKey: "MobileNum") as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.redirectDetailView(indexpath: indexPath)
    }
    
    //Mark:redirectDetailView
    func redirectDetailView(indexpath:IndexPath)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(withIdentifier: "EmployeeFormViewController") as! EmployeeFormViewController;
        detailsViewController.pListUpdatedelegate = self;
        detailsViewController.updatePListObj = pListArray[indexpath.row] as! NSMutableDictionary;
        navigationController?.pushViewController(detailsViewController,
                                                 animated: true)
    }
    
    
}

//Mark:: TableView cell class
class EmployeeListViewControllerCell: UITableViewCell {
    
    var name = UILabel()
    var mobileNumber = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        mobileNumber.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(name)
        contentView.addSubview(mobileNumber)

        name.textColor = .white
        mobileNumber.textColor = .white

        NSLayoutConstraint.activate([name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),name.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),name.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0),name.heightAnchor.constraint(equalToConstant: 30) ])
        
         NSLayoutConstraint.activate([mobileNumber.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 0),mobileNumber.leftAnchor.constraint(equalTo: name.leftAnchor, constant: 0),mobileNumber.widthAnchor.constraint(equalTo: name.widthAnchor, constant: 0),mobileNumber.heightAnchor.constraint(equalToConstant: 30) ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
