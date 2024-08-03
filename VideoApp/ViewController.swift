
 
import UIKit
import AVFoundation

class ViewController: UIViewController {

    var tableView: UITableView!
    var reelsModel: ReelsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        getDataFrom { reelsModel, error in
            print("sucess",reelsModel)
        }
        
    }
 
      func getDataFrom(completion: @escaping (ReelsModel?, Error?) -> Void) {
              let url = Bundle.main.url(forResource: "Reels", withExtension: "json")!
              let data = try! Data(contentsOf: url)
              do {
  
                  let jsonDescription = try JSONDecoder().decode(ReelsModel.self, from: data)
                  print(jsonDescription)
                  self.reelsModel = jsonDescription
                  self.tableView.reloadData()
                  completion(jsonDescription,nil)
              }
              catch let jsonError {
                  print("Json Error:", jsonError)
              }
          }
        

    func setupTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 400
        tableView.backgroundColor = .white
        view.addSubview(tableView)
    }
     
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reelsModel?.reels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.backgroundColor = .lightGray
        // Configure with actual video and thumbnail URLs from your JSON response
        // Configure with actual video and thumbnail URLs from your JSON response
        let videoURL1 = self.reelsModel?.reels?[indexPath.row].arr?[0].video ?? ""
        let videoURL2 = self.reelsModel?.reels?[indexPath.row].arr?[1].video ?? ""
        let videoURL3 = self.reelsModel?.reels?[indexPath.row].arr?[2].video ?? ""
        let videoURL4 = self.reelsModel?.reels?[indexPath.row].arr?[3].video ?? ""
        
        cell.configure(with: [
            (videoURL1),
            (videoURL2),
            (videoURL3),
            (videoURL4)
        ])
        
        // auto play will call multiple times here
//        DispatchQueue.main.async {
//            self.playVisibleCells()
//        }
//        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    // it will play when user scroll 	
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        playVisibleCells()
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let myCell = cell as? TableViewCell {
            myCell.playVideosSequentially()
        }
    }
    
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            playVisibleCells()
        }
    
    func playVisibleCells() {
        for cell in tableView.visibleCells {
            if let myCell = cell as? TableViewCell {
                myCell.playVideosSequentially()
            }
        }
    }
    
    
    
}

