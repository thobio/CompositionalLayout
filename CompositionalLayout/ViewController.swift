//
//  ViewController.swift
//  CompositionalLayout
//
//  Created by Thobio Joseph on 20/01/23.
//

import UIKit
import LBTATools

class ViewController: UIViewController {

    lazy var buttonLoaction = UIButton(title: "Home         ", titleColor: .black, font: .boldSystemFont(ofSize: 16), backgroundColor: .clear, target: self, action: #selector(loactionButtonAction))
    let labelLoacton = UILabel(text: "Opposite of SRA 115",font: .systemFont(ofSize: 12),textColor: .systemGray, textAlignment: .center, numberOfLines: 1)
    let searchButton = UIButton(image: UIImage(named: "user")!,tintColor: .black)
    let languageButton = UIButton(image: UIImage(systemName: "repeat.circle")!,tintColor: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
    }
    
    
    fileprivate func setupNavBar(){
        let coverWhiteView = UIView(backgroundColor: .white)
        view.addSubview(coverWhiteView)
        coverWhiteView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        let safeAreaTop = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        coverWhiteView.constrainHeight(safeAreaTop)
        
        let width = view.frame.width - 120 - 16 - 90 - 40
        
        let titleView = UIView()
        titleView.backgroundColor = .clear
        titleView.frame = .init(x: 0, y: 0, width: width, height: 50)
        
        buttonLoaction.titleLabel?.textAlignment = .left
        buttonLoaction.setImage(UIImage(systemName: "chevron.down")!, for: [])
        buttonLoaction.semanticContentAttribute = .forceRightToLeft
        buttonLoaction.tintColor = .black
        let imageLoaction = UIImageView(image: UIImage(named: "location"))
        
        let views = UIView()
        views.stack(buttonLoaction,labelLoacton)
        titleView.hstack(imageLoaction.withHeight(40).withWidth(40),views.withWidth(120).withHeight(40),UIView(backgroundColor: .clear).withWidth(width),languageButton.withWidth(40),searchButton.withWidth(40),spacing:5)
        
        navigationItem.titleView = titleView
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaTop = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        let magicalSafeAreaTop:CGFloat = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        let offset = scrollView.contentOffset.y + magicalSafeAreaTop
        let alpha = 1 - ((scrollView.contentOffset.y + magicalSafeAreaTop) / magicalSafeAreaTop)
        [buttonLoaction,labelLoacton,searchButton].forEach { $0.alpha = alpha }
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    @objc func loactionButtonAction(){
        
    }
    
    func setupCollectionView(){
        let searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ViewController.getCompositionalLayout())
        searchCollectionView.frame = self.view.frame
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.backgroundColor = .white
        searchCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(searchCollectionView)
    }
    
   static func getCompositionalLayout()-> UICollectionViewCompositionalLayout{
       return UICollectionViewCompositionalLayout { (sectionNumber,env) -> NSCollectionLayoutSection? in
           if sectionNumber == 0 {
               let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
               item.contentInsets.trailing = 1
               item.contentInsets.bottom = 10
               let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
               let section = NSCollectionLayoutSection(group: group)
               section.orthogonalScrollingBehavior = .paging
               return section
           }else {
               //MARK: - first Item
               let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
               item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
               //MARK: - Group first
               let firstGroupItem1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
               firstGroupItem1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
               let firstGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)), subitems: [firstGroupItem1])
               
               //MARK: - Group Second
               let secondGroupItem1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)))
               secondGroupItem1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
               let secondGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)), subitems: [secondGroupItem1])
               
               //MARK: - Container Group with item & Group first and second
               let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(600)), subitems: [item,firstGroup,secondGroup])
               
               return NSCollectionLayoutSection(group: containerGroup)
           }
       }
    }
    

}

extension ViewController :UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        }else{
            return 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
         cell.backgroundColor = .random
        return cell
    }
}


extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0.4 ... 1), green: .random(in: 0.4 ... 1), blue: .random(in: 0.4 ... 1), alpha: 1)
    }
}
