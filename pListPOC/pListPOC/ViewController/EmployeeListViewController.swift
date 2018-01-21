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
    
    
    var pListArray = [PListEntity]()
    var pListFavArray = [PListEntity]()
    
    var isfavBtnPressed = false
    
    var pListObj = NSMutableDictionary()
    
    let reuseIdentifier = "tCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initalizeUiComponents()
    }
    
    func initalizeUiComponents(){
        
        //AllBtn
        let allContactsBtn = self.returnCustomButton(title: "All");
        
        view.addSubview(allContactsBtn);
        allContactsBtn.addTarget(self, action: #selector(allContactsBtnPressed), for: .touchUpInside)
        
        allContactsBtn.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([allContactsBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),allContactsBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),allContactsBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),allContactsBtn.heightAnchor.constraint(equalToConstant: 50)  ]);
        
        //FavouriteBtn
        let favouriteBtn = self.returnCustomButton(title: "Favourite");
        
        view.addSubview(favouriteBtn);
        favouriteBtn.addTarget(self, action: #selector(favouriteBtnPressed), for: .touchUpInside)
        
        favouriteBtn.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([favouriteBtn.topAnchor.constraint(equalTo: allContactsBtn.topAnchor, constant: 0),favouriteBtn.leftAnchor.constraint(equalTo: allContactsBtn.rightAnchor, constant: 5),favouriteBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),favouriteBtn.heightAnchor.constraint(equalToConstant: 50)  ]);
        
        
         //UItable view
        employeeTableView.delegate = self
        employeeTableView.dataSource = self
        employeeTableView.register(EmployeeListViewControllerCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        employeeTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([employeeTableView.topAnchor.constraint(equalTo: allContactsBtn.bottomAnchor, constant: 0),employeeTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),employeeTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),employeeTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0)])
       
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
    
    //Mark:allContactsBtnPressed
    @objc func allContactsBtnPressed()  {
        isfavBtnPressed = false
        
        employeeTableView.reloadData()
    }
    
    //Mark:favouriteBtnPressed
    @objc func favouriteBtnPressed()  {
        isfavBtnPressed = true
        pListFavArray = pListArray.filter({$0.favorite == "Fav"})
        employeeTableView.reloadData()
    }
    
    //Mark:returnCustomButton
    func returnCustomButton(title:String) -> UIButton {
        let customButton = UIButton()
        customButton.setTitle(title, for: .normal)
        customButton.setTitleColor(.black, for: .normal)
        customButton.backgroundColor  = .blue
        
        return customButton
    }
}

extension EmployeeListViewController:updatePListDelegate{
    func refreshPList(data: PListEntity) {
        pListArray.append(data)
        employeeTableView.reloadData()
    }
}

extension EmployeeListViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isfavBtnPressed == true{
            return pListFavArray.count
        }else{
            return pListArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EmployeeListViewControllerCell
        cell.backgroundColor = .blue
        
        var p:PListEntity = PListEntity()
        
        if isfavBtnPressed == true{
            p = pListFavArray[indexPath.row]
        }else{
            p = pListArray[indexPath.row]
        }
        
        cell.name.text = p.fullName
        cell.mobileNumber.text = p.mobileNumber
        
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(favBtnPressed(sender:)), for: .touchUpInside)
        
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
        detailsViewController.updatePListObj = pListArray[indexpath.row] ;
        pListArray.remove(at: indexpath.row)
        navigationController?.pushViewController(detailsViewController,
                                                 animated: true)
    }
    
    //Mark:favBtnPressed
    @objc func favBtnPressed(sender:UIButton){
        print("favBtnPressed----->" + "\(sender.tag)")
        var p:PListEntity = PListEntity()
        p = pListArray[sender.tag]

        let obj = PListEntity()
        obj.fullName = p.fullName
        obj.mobileNumber = p.mobileNumber
        obj.favorite =  "Fav"
        
        pListArray.remove(at: sender.tag)
        pListArray.insert(obj, at: sender.tag)
        print(pListArray)
        
    }
    
    
}

//Mark:: TableView cell class
class EmployeeListViewControllerCell: UITableViewCell {
    
    var name = UILabel()
    var mobileNumber = UILabel()
    
    var favBtn = UIButton()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        mobileNumber.translatesAutoresizingMaskIntoConstraints = false
        favBtn.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(name)
        contentView.addSubview(mobileNumber)
        contentView.addSubview(favBtn)

        name.textColor = .white
        mobileNumber.textColor = .white

        favBtn.setImage(UIImage(named:"icons8-star-50"), for: .normal)
        
        NSLayoutConstraint.activate([name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),name.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),name.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),name.heightAnchor.constraint(equalToConstant: 30) ])
        
         NSLayoutConstraint.activate([mobileNumber.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 0),mobileNumber.leftAnchor.constraint(equalTo: name.leftAnchor, constant: 0),mobileNumber.widthAnchor.constraint(equalTo: name.widthAnchor, constant: 0),mobileNumber.heightAnchor.constraint(equalToConstant: 30) ])
        
         NSLayoutConstraint.activate([favBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),favBtn.leftAnchor.constraint(equalTo: name.rightAnchor, constant: 10),favBtn.widthAnchor.constraint(equalToConstant: 30),favBtn.heightAnchor.constraint(equalToConstant: 30) ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
