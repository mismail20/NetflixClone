//
//  CoreData.swift
//  Netflix
//
//  Created by Mohamed Ismail on 12/09/2023.
//

import Foundation
import CoreData
import UIKit

class CoreData {
    static let shared = CoreData()

    func downloadTitle(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.overview = model.overview
        item.poster_path = model.poster_path
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchDownloads(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeTitle(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        request.predicate = NSPredicate(format: "original_title == %@", model.original_title!)
        
        do {
            try context.delete(context.fetch(request).first!)
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
        }
    }


    
    
    
}
