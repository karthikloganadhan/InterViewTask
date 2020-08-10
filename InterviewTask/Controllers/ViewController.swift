//
//  ViewController.swift
//  InterviewTask
//
//  Created by Admin on 06/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData
import Reachability

class ViewController: UIViewController {
    
    struct Cells {
        static let TableViewCell = "cell"
    }
    let factsTableView = UITableView()
    private var factResponse: FactsResponse?
    var rows: [Rows] = []
    var global = Global()
    
    var activityIndicatorView = UIActivityIndicatorView()
    //MARK: - General
    
    override func viewDidLoad() {
        super.viewDidLoad()
        factsTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        
        setupTableView()
        addRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        if Reachability.isConnectedToNetwork(){
            getDataFromServer()
            print("Internet Connection Available!")
        }else{
            getDataFromCoreData()
            print("Internet Connection not Available!")
        }
    }
    
    func setupTableView() {
        view.addSubview(factsTableView)
        setTableViewDelegates()
        factsTableView.register(TableViewCell.self, forCellReuseIdentifier: Cells.TableViewCell)
        factsTableView.estimatedRowHeight = 120
        factsTableView.rowHeight = UITableView.automaticDimension
        factsTableView.separatorStyle = .none
        factsTableView.pin(view)
    }
    
    //MARK: Setup delegates and datatsource to tableview
    func setTableViewDelegates(){
        factsTableView.dataSource = self
        factsTableView.delegate = self
    }
    
    //MARK: Adding refresh controller to tableview
    func addRefresh(){
        if #available(iOS 10.0, *){
            factsTableView.refreshControl = refresher
        }else{
            factsTableView.addSubview(refresher)
        }
    }
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        if Reachability.isConnectedToNetwork(){
            getDataFromServer()
            print("Internet Connection Available!")
        }else{
            self.showAlert(title: "", message: "Please check your Internet connection")
            print("Internet Connection not Available!")
        }
    }
    
    
    //MARK: - API and Core Data
    
    func getDataFromCoreData() {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Country")
               let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
               var results: [NSManagedObject] = []
               do {
                   results = try context.fetch(fetchRequest)
                   print(results)
                for data in results as! [Country] {
                   let eachTitle = data.value(forKey: "titleString") as! String
                   self.navigationItem.title = eachTitle
                   print(eachTitle)
                   let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FactRow")
                   var rowsArray = [Rows]()
                    do {
                        results = try context.fetch(fetchRequest)
                        print(results)
                        for data in results as! [FactRow] {
                            let eachTitle = data.value(forKey: "titlestring") as! String
                            let eachDescription = data.value(forKey: "descriptionstring") as! String
                            let eachImagePath = data.value(forKey: "imagePath") as! String
                            let eachRow = Rows(title: eachTitle, description: eachDescription, imageHref: eachImagePath)
                            rowsArray.append(eachRow)
                            factResponse = FactsResponse(title: "FactRow", rows: rowsArray)
                            factsTableView.reloadData()
                        }
                    }
                    catch {
                        print("error executing fetch request: \(error)")
                    }
                   }
               }
               catch {
                   print("error executing fetch request: \(error)")
               }
               refresher.endRefreshing()
    }
    
    // Fetch data from server
    func getDataFromServer() {
        let session = NetworkManager()
        activityIndicatorView.startAnimating()
        session.fetchDataFromServer(withCompletion: { [weak self] (data, error) in

            DispatchQueue.main.async {
                self!.activityIndicatorView.stopAnimating()
                self?.refresher.endRefreshing()
                if let facts = data  {

                    /* Filtering null values from responce, here i am checking only title, but based on
                    your requiment we can check description and image also. just using { $0.title != nill && $0.description != nil && $0.imageHref != nil */

                    self?.rows = facts.rows.filter { $0.title != nil }
                    self?.factResponse?.title = facts.title
                    self?.factResponse = FactsResponse(title: facts.title, rows: self?.rows ?? [])
                    self?.saveDataToCoreData(factsReceived: (self?.factResponse)!)
                    self?.navigationItem.title = facts.title ?? " "
                    self?.factsTableView.reloadData()
                }
                else{
                    self?.showAlert(title: "", message: error?.localizedDescription ?? "Some error occured")
                }
            }
        })
    }
    
    func saveDataToCoreData(factsReceived : FactsResponse)  {
        let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Country", in: context)
        let eachCountry = Country(entity: entity!, insertInto: context)
        eachCountry.titleString = factsReceived.title
        
        for eachFact in factsReceived.rows
         {
            let entity = NSEntityDescription.entity(forEntityName: "FactRow", in: context)
            let eachFactValue = FactRow(entity: entity!, insertInto: context)
            let urlOfImage = ""
            eachFactValue.titlestring = eachFact.title ?? "-"
            eachFactValue.descriptionstring =  eachFact.description ?? "-"
            eachFactValue.imagePath = urlOfImage
            eachFactValue.forCountry = eachCountry
            print(urlOfImage)
            do {
                try context.save()
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    //MARK: TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.factResponse?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.TableViewCell) as! TableViewCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.groupTableViewBackground
       if let eachRow : Rows = (self.factResponse?.rows[indexPath.row]){
            cell.set(row: eachRow)
        }
        return cell
    }
    
    
}


extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Create the actions
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}
