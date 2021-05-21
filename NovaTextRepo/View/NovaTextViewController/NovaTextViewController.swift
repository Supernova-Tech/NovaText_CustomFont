//
//  NovaTextViewController.swift
//  NovaTextRepo
//
//  Created by MBA0217 on 5/11/21.
//

import UIKit
import Combine

class NovaTextViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var displayLabel: UILabel!
    
    var font: UIFont = .monospacedDigitSystemFont(ofSize: 50, weight: .heavy) {
        didSet {
            displayLabel.font = font
        }
    }
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nova Text Project"
        configCollectionView()
        // Do any additional setup after loading the view.
        configUI()
        printResult()
    }
    
    private func configCollectionView() {
        collectionView.register(UINib(nibName: "FontsCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configUI() {
        displayView.layer.borderColor = UIColor.black.cgColor
        displayView.layer.borderWidth = 5
        displayLabel.text = "Please Tap To \n Edit Text"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToTypeText(_:)))
        displayView.addGestureRecognizer(tapGesture)
        runAnimation()
    }
    
    private func runAnimation() {
        changeTextColorDependImageColor()
        self.displayView.alpha = 0
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.6) {
                self.displayView.frame.origin.y = self.collectionView.frame.minY
                self.displayLabel.font = self.font
            }
            
            UIView.animate(withDuration: 1.5) {
                self.displayView.alpha = 1
            }
        }
    }
    
    private func printResult() {
        if let text = displayLabel.text {
            let arr = text.split(separator: "\n")
            print("========", arr)
        }
    }
    
    @objc private func goToTypeText(_ gesture: UITapGestureRecognizer?) {
        let vc = TypeTextViewController()
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let text = self.displayLabel.text, !text.elementsEqual("Please Tap To \n Edit Text") {
                vc.getTextPublisher.send(text)
            }
        }
        vc.setTextPublisher.sink(receiveValue: { value in
            self.displayLabel.text = value
        })
        .store(in: &subscriptions)
//        vc.delegate = self
        present(vc, animated: true) {
//            if let text = self.displayLabel.text, !text.elementsEqual("Please Tap To \n Edit Text") {
//                vc.getTextPublisher.send(text)
//            }
        }
    }
}

extension NovaTextViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            self.backgroundImageView.image = #imageLiteral(resourceName: "black-bgr")
        } else {
            self.backgroundImageView.image = #imageLiteral(resourceName: "white-bgr")
        }
        changeTextColorDependImageColor()
        self.displayView.alpha = 0
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.6) {
                self.displayView.frame.origin.y = self.collectionView.frame.minY
                switch indexPath.row {
                case 0:
                    self.font = .monospacedDigitSystemFont(ofSize: 50, weight: .heavy)
                case 1:
                    self.font = .boldSystemFont(ofSize: 50)
                case 2:
                    self.font = .italicSystemFont(ofSize: 50)
                case 3:
                    self.font = .monospacedDigitSystemFont(ofSize: 50, weight: .bold)
                case 4:
                    self.font = .preferredFont(forTextStyle: .body)
                case 5:
                    self.font = .monospacedSystemFont(ofSize: 50, weight: .black)
                default:
                    self.font = .systemFont(ofSize: 50)
                }
            }
            
            UIView.animate(withDuration: 1.5) {
                self.displayView.alpha = 1
            }
        }
        self.indexPath = indexPath
        collectionView.reloadData()
    }
}

extension NovaTextViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FontsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 5
        switch indexPath.row {
        case 0:
            cell.updateUI(font: .monospacedDigitSystemFont(ofSize: 18, weight: .heavy), isSelecting: self.indexPath == indexPath)
        case 1:
            cell.updateUI(font: .boldSystemFont(ofSize: 18), isSelecting: self.indexPath == indexPath)
        case 2:
            cell.updateUI(font: .italicSystemFont(ofSize: 18), isSelecting: self.indexPath == indexPath)
        case 3:
            cell.updateUI(font: .monospacedDigitSystemFont(ofSize: 18, weight: .bold), isSelecting: self.indexPath == indexPath)
        case 4:
            cell.updateUI(font: .preferredFont(forTextStyle: .body), isSelecting: self.indexPath == indexPath)
        case 5:
            cell.updateUI(font: .monospacedSystemFont(ofSize: 18, weight: .black), isSelecting: self.indexPath == indexPath)
        default:
            cell.updateUI(font: .systemFont(ofSize: 18), isSelecting: self.indexPath == indexPath)
        }
        return cell
    }
    
}

extension NovaTextViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30) / 3, height: (UIScreen.main.bounds.width - 30) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
//
//extension NovaTextViewController: TypeTextViewControllerDelegate {
//    func typeTextViewController(controller: TypeTextViewController, performNeeded action: TypeTextViewController.Action) {
//        switch action {
//        case .setText(let text):
//            if let text = text {
//                displayLabel.text = text
//            } else {
//                displayLabel.text = "Please Tap To \n Edit Text"
//            }
//        }
//    }
//}

extension NovaTextViewController {
    private func changeTextColorDependImageColor() {
        if let isLight: Bool = backgroundImageView.image?.areaAverage().isLight() {
            displayView.layer.borderColor = isLight ? UIColor.black.cgColor : UIColor.white.cgColor
            displayLabel.textColor = isLight ? .black : .white
        }
        
    }
}
