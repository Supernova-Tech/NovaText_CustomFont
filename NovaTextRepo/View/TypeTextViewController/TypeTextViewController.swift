//
//  TypeTextViewController.swift
//  NovaTextRepo
//
//  Created by MBA0217 on 5/12/21.
//

import UIKit
import Combine

protocol TypeTextViewControllerDelegate: class {
    func typeTextViewController(controller: TypeTextViewController, performNeeded action: TypeTextViewController.Action)
}

class TypeTextViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    var setTextPublisher: PassthroughSubject = PassthroughSubject<String?, Never>()
    var getTextPublisher: PassthroughSubject = PassthroughSubject<String?, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        textView.becomeFirstResponder()
        getTextPublisher.sink(receiveValue: { value in
            self.placeHolderLabel.isHidden = value != nil
            self.textView.text = value
        })
        .store(in: &self.subscriptions)
    }
    
    enum Action {
        case setText(_ text: String?)
    }
    weak var delegate: TypeTextViewControllerDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    @IBAction func cancelButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func doneButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: false) { [weak self] in
            guard let this = self, let text =  this.textView.text else { return }
//            this.delegate?.typeTextViewController(controller: this, performNeeded: Action.setText(this.textView.text))
            if text.isEmpty {
                this.setTextPublisher.send("Please Tap To \n Edit Text")
            } else {
                this.setTextPublisher.send(this.textView.text)
            }
        }
    }
}

extension TypeTextViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        placeHolderLabel.isHidden = textView.text.count != 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        return updatedText.count <= 200
    }
}
