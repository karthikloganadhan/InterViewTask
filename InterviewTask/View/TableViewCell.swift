//
//  TableViewCell.swift
//  InterviewTask
//
//  Created by Admin on 06/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData


class TableViewCell: UITableViewCell {
    
    //MARK: create a uielements
    var rowsImageView = UIImageView()
    var rowsTitle = UILabel()
    var rowsDescription = UILabel()
    var containerView = UIView()
    
    var global = Global()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(containerView)
        containerView.addSubview(rowsImageView)
        containerView.addSubview(rowsTitle)
        containerView.addSubview(rowsDescription)
        configurationContainerView()
        configurationLable()
        configurationImageview()
        setContainerViewConstraint()
        setImageConstraint()
        setTitleLableConstraints()
        setDescriptionLableConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configurationContainerView(){
        containerView.backgroundColor = UIColor.init(named: "CellBackground")!
        containerView.layer.cornerRadius = 10
    }
    
    func configurationImageview(){
        rowsImageView.layer.cornerRadius = 10
        rowsImageView.clipsToBounds      = true
    }
    func configurationLable(){
        rowsDescription.numberOfLines    = 0
        rowsTitle.numberOfLines          = 0
        
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            rowsTitle.font = UIFont(name: "SourceSerifPro-Bold", size: 30)
            rowsDescription.font = UIFont(name: "SourceSerifPro-SemiBold", size: 20)
        }
        else
        {
            rowsTitle.font = UIFont(name: "SourceSerifPro-Bold", size: 17)
            rowsDescription.font = UIFont(name: "SourceSerifPro-SemiBold", size: 14)
        }
        
    }
    
    func setContainerViewConstraint(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
    }
    func setImageConstraint(){
        rowsImageView.translatesAutoresizingMaskIntoConstraints  = false
        rowsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        rowsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        rowsImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        rowsImageView.widthAnchor.constraint(equalToConstant: 100).isActive  = true
        rowsImageView.contentMode = .scaleAspectFit
        rowsImageView.backgroundColor = .clear
    }
    
    func setTitleLableConstraints(){
        rowsTitle.translatesAutoresizingMaskIntoConstraints  = false
        rowsTitle.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        rowsTitle.leadingAnchor.constraint(equalTo: rowsImageView.trailingAnchor, constant: 8).isActive = true
        rowsTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        
    }
    func setDescriptionLableConstraints(){
        rowsDescription.translatesAutoresizingMaskIntoConstraints    = false
        rowsDescription.topAnchor.constraint(equalTo: rowsTitle.bottomAnchor, constant: 8).isActive = true
        rowsDescription.leadingAnchor.constraint(equalTo: rowsTitle.leadingAnchor).isActive = true
        rowsDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        rowsDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        rowsDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true
    }
    
    //MARK: Setting values in the UIElements of the cells
    func set(row:Rows){
        rowsTitle.text        = row.title ?? "-"
        rowsDescription.text  = row.description ?? "-"
        
        
        if Reachability.isConnectedToNetwork(){
            rowsImageView.sd_setImage(with: URL(string:row.imageHref ?? "" ), placeholderImage: UIImage(named: "defaultImage.png")) { [unowned self] (image, error, cacheType, url) in
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FactRow")
                let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
                var results: [NSManagedObject] = []
                do {
                    results = try context.fetch(fetchRequest)
                    print(results)
                    for eachResults in results{
                        let eachRowData: FactRow = eachResults as! FactRow
                        let titleString: String = eachRowData.titlestring ?? ""
                        
                        if titleString == row.title{
                            let urlOfImage = self.global.saveImagesToFileManager(imageReceived: self.rowsImageView.image!, name: self.rowsTitle.text!)
                            eachRowData.imagePath = urlOfImage
                            do {
                                try context.save()
                                print("saved!")
                            } catch let error as NSError  {
                                print("Could not save \(error), \(error.userInfo)")
                            }
                            
                        }
                    }
                    
                    
                }
                catch {
                    print("error executing fetch request: \(error)")
                }
            }
        }
        else{
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            var fileName = row.title ?? ""
            fileName += ".jpg"
            // create the destination file url to save your image
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            print(fileURL)
            if let image = UIImage(contentsOfFile: fileURL.path){
                rowsImageView.image = image
            }
            else
            {
                rowsImageView.image = UIImage(named: "defaultImage.png")
            }
        }
      
    }
 
}
