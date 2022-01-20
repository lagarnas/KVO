//
//  ViewController.swift
//  Key-Value-Observing
//
//  Created by Анастасия Леонтьева on 12.04.2021.
//

import UIKit
import Foundation

/*
 KVO - это наблюдение за ключевыми значениями, является одним из методов наблюдения
 за изменениями состояния программы, доступных в Objective-C и Swift.
 Концепция проста: когда у нас есть объект с некоторыми переменными экземпляра,
 KVO позволяет другим объектам устанавливать наблюдение за изменениями
 для любой из этих переменных экземпляра.
 KVO - это практический пример паттерна Observer.
 */

class User: NSObject {
    @objc dynamic var name = String()
    
    @objc var age = 0
        {
        willSet { willChangeValue(forKey: #keyPath(age)) }
        didSet { didChangeValue(for: \User.age) }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var nameObservationToken: NSKeyValueObservation?
    var ageObservationToken: NSKeyValueObservation?
    var inputTextObservationToken: NSKeyValueObservation?
    
    @objc let user = User()
    
    @objc dynamic var inputText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameObservationToken = observe(\ViewController.user.name, options: [.new]) { (strongSelf, change) in
            
            guard let updatedName = change.newValue else { return }
            strongSelf.nameLabel.text = updatedName
        }
        
        ageObservationToken = observe(\.user.age, options: .new, changeHandler: { (vc, change) in
            guard let updatedAge = change.newValue else { return }
            vc.ageLabel.text = String(updatedAge)
            
        })
        
        inputTextObservationToken = observe(\.inputText, options: .new, changeHandler: { (vc, change) in
            guard let updatedInputText = change.newValue as? String else { return }
            vc.textLabel.text = updatedInputText
            
        })
        
        
        addObserver(self, forKeyPath: #keyPath(user.age), options: .new, context: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        nameObservationToken?.invalidate()
        ageObservationToken?.invalidate()
        inputTextObservationToken?.invalidate()
    }
    
    @IBAction func didTapUpdateName() {
        user.name = "Hello"
    }
    
    @IBAction func didTapUpdateAge() {
        user.age = 27
        user.setValue(100, forKey: "age")
    }
    
    @IBAction func textFieldTextDidChange() {
        inputText = textField.text
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(user.age) {
            
            guard let updatedAge = change?[.newKey] as? Int else { return }
            ageLabel.text = String(updatedAge)
        }
        
    }
}
