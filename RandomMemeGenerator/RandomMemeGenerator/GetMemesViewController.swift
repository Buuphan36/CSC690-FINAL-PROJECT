//
//  GetMemesViewController.swift
//  RandomMemeGenerator
//
//  Created by buu phan on 5/13/21.
//

import UIKit

public struct Meme: Codable{
    let title: String
    let url: String
}
class GetMemesViewController: UIViewController {

    let urlString = "https://meme-api.herokuapp.com/gimme"
    var memeTitle: String = ""
    var memeUrl: String = ""
    public var myMemes:[Meme] = []
    
    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func SavedMemesButton(_ sender: Any) {
        let meme = Meme(title: memeTitle, url:memeUrl)
        myMemes.append(meme)
    }
    
    @IBAction func GetMemeButton(_ sender: Any) {
        fetchMemes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMemes()
    }
    
    func fetchMemes(){
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) {[weak self]data, _,error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let result = try JSONDecoder().decode(Meme.self,from: data)
                print (result.title)
                self?.memeTitle = result.title
                self?.memeUrl = result.url
                guard let imageUrl = URL(string: result.url) else {
                    return
                }
                guard let imageData = try? Data(contentsOf: imageUrl) else {
                    return
                }
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self?.titleLabel.text = result.title
                    self?.memeImage.image = image
                    //self.imageURL = result.url
                }
            }
            catch {
                print (error)
            }
        }
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
