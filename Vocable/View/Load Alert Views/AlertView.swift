import Foundation
import UIKit

class AlertView{
    
    static let shared = AlertView()
    
    var updateAccesibility = UIAlertController(title: "Error", message: "Enable recording features", preferredStyle: .alert)
    
    var offline = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    func offlineAlert()->UIAlertController{
        let offline = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let attributedText = NSMutableAttributedString(string: "You seem to be offline, check connection and try again", attributes: [NSAttributedString.Key.font: UIFont(name:"Roboto-Bold", size: 16)!])
        let ok = UIAlertAction(title: "ok", style: .default, handler: { (action) -> Void in})
        offline.addAction(ok)
        offline.setValue(attributedText, forKey: "attributedMessage")
        return offline
    }
    
    func returnPracticeError()->UIAlertController{
        let practiceError = UIAlertController(title: "Alert", message: "Problem downloading practice data", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: { (action) -> Void in
            Protocols.quizProtocol?.close()
        })
        practiceError.addAction(ok)
        return practiceError
    }
    
    func returnUpdateNameForm()->UIAlertController{
        var textField:UITextField?
        let alertController = UIAlertController(title: "Update your display name",message: "", preferredStyle: .alert)
        alertController.addTextField { (pTextField) in
            pTextField.placeholder = "Enter name.."
            pTextField.clearButtonMode = .whileEditing
            pTextField.borderStyle = .none
            textField = pTextField}
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))

        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (pAction) in
            let inputValue = textField?.text
            LoginModel.shared.updateUserName(name: inputValue ?? "-")
            Protocols.profileDelegate?.updateName(name:inputValue ?? "-")
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    
    func returnProblemAlert(eng:String,ita:String) -> UIAlertController{
        var textField:UITextField?
        let alertController = UIAlertController(title: "Let us know how to fix it",message: "What's the problem?", preferredStyle: .alert)
        alertController.addTextField { (pTextField) in
            pTextField.placeholder = "Tell us the problem"
            pTextField.clearButtonMode = .whileEditing
            pTextField.borderStyle = .none
            textField = pTextField}
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))

        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (pAction) in
            let inputValue = textField?.text
            NetworkModel.shared.report(message: "User ID: \(UserData.id)\nEmail: \(UserData.id)\nEng: \(eng)\nIta: \(ita)\nUAnswer: \(UserDefaults.standard.string(forKey: "reportAnswer")!)\nUMessage: \(inputValue ?? "nil value")", subject: "Vocable bug report: Something else")
            Protocols.quizProtocol?.disableReport()
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        return alertController
    }
    
    func returnSentAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "We recieved your message",message: "Thank you, we will take a look as soon as possible", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    func modelDownloading()->UIAlertController{
        let alertController = UIAlertController(title: "Alert", message: "Translation tools are just finishing download, please try again shortly", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) -> Void in
            Protocols.translateDelegate?.dismiss()
            Protocols.imageRecognitionDelegate?.dismiss()
        }))
        return alertController
    }
    
    
    func returnEmailLogin() -> UIAlertController{
        let alertController = UIAlertController(title: "Check your email",message: "We've emailed you a link to log in to Vocable, make sure to check your junk folder in case you don't see it", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
            Protocols.loginVCDelegate?.removeLoading()
        }))
        alertController.addAction(UIAlertAction(title: "Open Mail", style: .default, handler: { (pAction) in
            let mailURL = URL(string: "message://")!
            if UIApplication.shared.canOpenURL(mailURL) {UIApplication.shared.open(mailURL)}
            Protocols.loginVCDelegate?.removeLoading()
        }))
        return alertController
    }
    
    func returnMaxLivesAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "Max lives reached",message: "You currently have the maximum number of lives, come back when you have less than 5 lives", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    func returnNoAdAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "Unable to load Ad",message: "There is no Ad available at the moment, please come back and try again later", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    func returnExchangeLimitAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "Exchange limit reached",message: "Your lives for XP exchange limit has been reached, come back tomorrow to exchange more lives", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    func returnEmailErrorAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "An error occured",message: "Some error occured, please try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            Protocols.loginVCDelegate?.removeLoading()
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    func returnErrorAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "An error occured",message: "Some error occured, please try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    func returnLivesSuccessAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "Success",message: "Lives updated successfuly", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    func returnInsufficientXPAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "Insufficient XP",message: "You don't currently have enough XP to exchange for this number of lives", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    func returnLinkAlert() -> UIAlertController{
        let alertController = UIAlertController(title: "Link expired",message: "This link has expired, try logging in again to generate a new link", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    func returnRestoreSuccess() -> UIAlertController{
        let alertController = UIAlertController(title: "Restore Successful",message: "Auto renewable subscription succesfully restored", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    func returnDeleteAccount() -> UIAlertController{
        let alertController = UIAlertController(title: "Warning",message: "If you choose to continue with account deletion all previous progress and profile data will be deleted and cannot be restored, proceed with caution", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
            Protocols.settingsDelegate?.deleteAccount()
        }))
        return alertController
    }
    
    func returnRestoreFailure() -> UIAlertController{
        let alertController = UIAlertController(title: "Restore failed",message: "Unable to find an active subscription", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
    func returnActionSheet(question:String) -> UIAlertController{
        let actionSheetController = UIAlertController(title: "What's the problem?", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true)}
        let action1 = UIAlertAction(title: "My answer can also be right", style: .default) { action -> Void in
            NetworkModel.shared.report(message: question, subject: "Vocable bug report: My answer can also be right")
            Protocols.quizProtocol?.disableReport()
            Protocols.quizProtocol?.reportSent()}
        let action2 = UIAlertAction(title: "Something else", style: .default) { action -> Void in
            Protocols.quizProtocol?.report()}
        actionSheetController.addAction(action1)
        actionSheetController.addAction(action2)
        actionSheetController.addAction(cancelAction)
        return actionSheetController
    }
    
    func closeQuizAlert()->UIAlertController{
        let alertController = UIAlertController(title: "Quit pracitce",message: "If you leave then your progress so far will be lost.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Quit practice", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: Protocols.quizProtocol?.close)
        }))
        alertController.addAction(UIAlertAction(title: "Continue practice", style: .default, handler: { (pAction) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        return alertController
    }
    
}
