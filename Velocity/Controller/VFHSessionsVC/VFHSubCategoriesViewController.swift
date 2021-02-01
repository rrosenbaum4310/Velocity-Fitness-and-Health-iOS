//
//  VFHSubCategoriesViewController.swift
//  Velocity
//
//  Created by prominere on 01/01/20.
//

import UIKit
import SDWebImage

class VFHSubCategoriesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate
{
   @IBOutlet weak var stackMainContainer: UIStackView!
    @IBOutlet var imgSessionCollection: [UIImageView]!
    @IBOutlet var btnSessionCollection: [UIButton]!
    @IBOutlet weak var colSession: UITableView!
    
//  local Declaration
    fileprivate var categoryList = [Category]()
    let reuseIdentifier = "collSlider"
    
    var subListArray: NSMutableArray = [];

    
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn1 = UIButton(type: .custom)
              btn1.setImage(UIImage(named: "back"), for: .normal)
              btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
              btn1.addTarget(self, action: #selector(backMethod), for: .touchUpInside)
              let item1 = UIBarButtonItem(customView: btn1)
              self.navigationItem.setLeftBarButtonItems([item1] , animated: true)
        
        self.setupNaviigationBarItem(withBackButton: true, withNotification: false)

    }
    @objc func backMethod(){
        navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subcatListMethod()
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.colSession.frame.size.height / subListArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return subListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = colSession.dequeueReusableCell(withIdentifier: "Main", for: indexPath as IndexPath) as! VFHSubCell
        let array =  subListArray[indexPath.row] as! NSMutableDictionary
         DispatchQueue.main.async{
        cell.imgTransparent.sd_setImage(with: URL(string: (array.value(forKey: "subcat_image") as! String)))
       // cell.imgTransparent.layer.cornerRadius = 5.0
      //  cell.imgTransparent.layer.masksToBounds = true
        }
        cell.btnTitle.setTitle(NSString(format:"%@","")as String, for: .normal)
      //  cell.btnTitle.setTitle(NSString(format:"%@",(array as AnyObject).value(forKey: "title") as! CVarArg)as String, for: .normal)
        cell.btnTitle.tag = indexPath.row
        cell.btnTitle.removeTarget(nil, action: nil, for: .allEvents)
        cell.btnTitle.addTarget(self, action: #selector(self.didTappedSession(_:)), for: .touchUpInside)
     //   cell.borderView.layer.cornerRadius = 5
      //  cell.borderView.layer.masksToBounds = true
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    @objc func didTappedSession(_ sender: UIButton)
    {
        let array =  subListArray[sender.tag] as! NSMutableDictionary
        let notesVC = UIStoryboard.loadNotesVC()
        let cat = Category()
        cat.categoryID = array.value(forKey: "catid") as! CVarArg as! String
        cat.title = array.value(forKey: "title") as! CVarArg as! String
        cat.imageURL = array.value(forKey: "subcat_image") as! CVarArg as! String

        notesVC.category = cat
        notesVC.isNotes = true
        self.navigationController?.pushViewController(notesVC, animated: true)
       }
    
//     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//            let padding: CGFloat = 10
//    //        let width = (collectionView.bounds.size.width / 2) - (padding * 2)
//            //let height = width * (1.45)
//            let width = (collectionView.bounds.size.width) - (padding * 2)
//            let height = width * (2.5/4)
//            return CGSize(width: width, height: height)
//        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func subcatListMethod()
       {
        var todoEndpoint: String =  NSString(format:"http://sampletemplates.net.in/vfh/api/api.php?action=getsubcategories&catid=%@",UserDefaults.standard.string(forKey:"subCatIDInfo") ?? "")as String
        todoEndpoint = todoEndpoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let requestURL : NSURL = NSURL(string: todoEndpoint)!
        let session = URLSession.shared
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let task = session.dataTask(with: urlRequest as URLRequest) { (data, response, error) -> Void in
        if(data != nil)
        {
          let httpResponse = response as! HTTPURLResponse
          let statusCode = httpResponse.statusCode
          if(statusCode == 200)
           {
           do
           {
               let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
               print(jsonResponse)
               if(jsonResponse["status"] as! String == "success")
               {
                   DispatchQueue.main.async
                   {
                    self.subListArray = (jsonResponse["categories"] as! NSMutableArray)
                   self.colSession.reloadData()
                   }
               }
               else{
                let alertController = UIAlertController(title: "", message:"No List Avaialble" , preferredStyle: .alert)
                           let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true)
                    {
                    }
               }
           }
            catch let error
               {
                   print(error)
               }
             }
            }
            else{
                          
            }
         }
                   task.resume()
       }
    
 
   
}
