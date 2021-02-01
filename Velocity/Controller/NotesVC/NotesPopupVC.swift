//
//  NotesPopupVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit

protocol NotePopupDelegate {
    func didAddNewNote(_ controller: NotesPopupVC)
}

class NotesPopupVC: UIViewController {
// MARK: - Declaration
    @IBOutlet weak var viewContainer: LWBorderView!
    @IBOutlet weak var lblAddNoteTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var btnSaveNotes: VFHGradientButton!
    
//  local Declaration
    var category: Category?
    var categoryNote: CategoryNote?
    var delegate: NotePopupDelegate?
    var isUpdatingNote = false
    var isView = false
    
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        txtNotes.layer.cornerRadius = 5
        txtNotes.layer.borderWidth = 1
        txtNotes.layer.borderColor = UIColor.gray.cgColor
        
        if let obj = categoryNote {
            if !isView{
                isUpdatingNote = true
                txtNotes.text = obj.notes
                lblAddNoteTitle.text = "View note"
                txtNotes.isUserInteractionEnabled = false
                btnSaveNotes.setTitle("Edit", for: .normal)
            }
            
        }
        
    }
    
    
// MARK: - Methods
    func initialSetup() {
        
        
    }
    @IBAction func didTappedClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didTappedSave(_ sender: Any) {
        let set = CharacterSet.whitespaces
        if txtNotes.text.count == 0 || txtNotes.text!.trimmingCharacters(in: set).count == 0{
            self.showAlertView(message: "Please enter notes!", defaultActionTitle: "OK") {
                self.txtNotes.becomeFirstResponder()
            }
        } else {
            if isUpdatingNote {
                if lblAddNoteTitle.text == "View note"{
                    if let obj = categoryNote {
                        txtNotes.text = obj.notes
                        lblAddNoteTitle.text = "Edit note"
                        txtNotes.isUserInteractionEnabled = true
                        btnSaveNotes.setTitle("Save", for: .normal)
                        self.isView = true
                    }
                }else{
                    editNotesDetail(note: txtNotes.text)
                }
                
            } else {
                saveNotesDetail(note: txtNotes.text)
            }
            
        }
    }
    
    func saveNotesDetail(note: String) {
        guard let user = GlobalManager.sharedInstance.getCurrentUser(), let categoryObj = category else {
            return
        }
        appDelegate.showActivityControl()
        APISaveNotes(user.userID, categoary: categoryObj.categoryID, note: note) { (isSucceed, message) in
            DispatchQueue.main.async(execute: {
                self.showAlertView(message: message, defaultActionTitle: "OK", complitionHandler: {
                    if isSucceed {
                        if let delegate = self.delegate {
                            delegate.didAddNewNote(self)
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            })
            
        }
    }
    
    func editNotesDetail(note: String) {
        guard let obj = categoryNote else {
            return
        }
        appDelegate.showActivityControl()
        APIEditNotes(obj.noteID, note: note) { (isSucceed, message) in
            DispatchQueue.main.async(execute: {
                self.showAlertView(message: message, defaultActionTitle: "OK", complitionHandler: {
                    if isSucceed {
                        if let delegate = self.delegate {
                            delegate.didAddNewNote(self)
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            })
            
        }
    }
    
}

extension NotesPopupVC {
    
    func APISaveNotes(_ userID: String, categoary categoryID: String, note noteStr: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.saveNotes + "&userid=\(userID)&categoryid=\(categoryID)&notes=\(noteStr)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    completion(true, "Your note has been added.")
                    return
                } else {
                    completion(false, message)
                }
                
                
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!")
            }
        }
    }
    func APIEditNotes(_ noteID: String, note noteStr: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.editNotes + "&id=\(noteID)&notes=\(noteStr)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    completion(true, "Your note has been edited.")
                    return
                } else {
                    completion(false, message)
                }
                
                
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!")
            }
        }
    }
}
