//
//  UpmeCheckDataStepC.swift
//  Upme-Professional
//
//  Created by Nucleus on 24/07/17.
//  Copyright © 2017 Nucleus. All rights reserved.
//

import Foundation

//MARK: - SignUp Part 1 Check Data

public class UpmeP1CheckDataStepC:SignUpCheckDataStepC{
    public var canEdit: Bool = true
    
    public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    public func didTapNextStep(_ answers:[String : Any], onVC vc: UIViewController, completion: @escaping (Bool,[String:Any]?) -> ()) {
        
        if let token = PushNotificationHelper.deviceToken{
            Professional_CRUD.signUpWith(Params: answers,deviceToken: token) { (success, responseDict) in
                
                if !success{
                    if let data = responseDict{
                        RequestError.showAlertFor(data: data, onVC: vc)
                    }
                    else{
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        UIView.showAlert(OnVC: vc, WithTitle: nil, Message: "Não foi possivel enviar suas informações", AndActions: [okAction])
                    }
                }
                else{
                    self.canEdit = false
                    /*if let data = responseDict, let id = data[Professional_Keys._id] as? String {
                     completion(true,[Professional_Keys._id:])
                     }*/
                }
                completion(success,responseDict)
            }
        }
        else{
            
            PushNotificationHelper.currentAuthorizationStatus(completion: { (status) in
                if status != .authorized{
                    PushNotificationHelper.showFixPermissionAlert(OnVC: vc,WithTitle: nil, Message: "Upme precisa de permissão para enviar-lhe notificações. Por favor altere a permissão em Ajustes para continuar o cadastro", yesBtnTitle: "Ajustes", noBtnTitle: "Cancelar")
                }
            })
            
            completion(false,nil)
        }
        
    }
    
    
    public func numberOfSections(Answers answers: [String : Any]) -> Int {
        return 1
    }
    
    public func numberOfRows(Answers answers: [String : Any], Section section: Int) -> Int {
        return answers.keysArray().count
    }
    
    public func dataFor(Answers answers: [String : Any], AtIndexPath indexPath: IndexPath) -> (key: String, value: String?) {
        //let section = indexPath.section
        let row = indexPath.row
        
        switch row {
        case 0:
            let name = answers[ProfAccount_Keys.name] as? String
            return ("Nome",name)
        case 1:
            let cpf = SignUpMask.cpf.applyOnText(text: answers[ProfAccount_Keys.cpf] as! String)!
            return ("CPF",cpf)
        case 2:
            let phoneNumber = SignUpMask.brPhone.applyOnText(text: answers[ProfAccount_Keys.phone_number] as! String)!
            return ("Telefone",phoneNumber)
        case 3:
            return ("E-mail",answers[ProfAccount_Keys.email] as? String)
        case 4:
            return ("Senha",answers[ProfAccount_Keys.password] as? String)
        default:
            return ("Extra",nil)

        }
    }
    
    public func titleForHeader(Answers answers: [String : Any], InSection section: Int) -> String? {
        return "Conta"
    }
    
    public func didSelectAnswerAt(IndexPath indexPath: IndexPath, onVC vc: UIViewController, fromAnswers answers: [String : Any]) {
        
        switch indexPath.row {
        case 0:
            vc.performSegue(withIdentifier: "reviewName", sender: answers)
        case 1:
            vc.performSegue(withIdentifier: "reviewCPF", sender: answers)
        case 2:
            vc.performSegue(withIdentifier: "reviewPhoneNumber", sender: answers)
        case 3:
            vc.performSegue(withIdentifier: "reviewEmail", sender: answers)
        case 4:
            vc.performSegue(withIdentifier: "reviewPassword", sender: answers)
        default:
            break
        }
    }
}


//MARK: - Address Check Data

public class UpmeP2AddressCheckDataStepC:SignUpCheckDataStepC{
    public var canEdit: Bool = true
    
    public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextStep"{
            if let vc = segue.destination as? SignUpCheckDataStepVC{
                vc.controller = UpmeP2CheckDataStepC()
            }
        }
    }

    public func didTapNextStep(_ answers:[String : Any], onVC vc: UIViewController, completion: @escaping (Bool,[String:Any]?) -> ()) {
        self.canEdit = true
        completion(true,nil)
    }
    
    
    public func numberOfSections(Answers answers: [String : Any]) -> Int {
        return 1
    }
    
    public func numberOfRows(Answers answers: [String : Any], Section section: Int) -> Int {

        return 7//addressAnswers.keysArray().count
    }
    
    public func dataFor(Answers answers: [String : Any], AtIndexPath indexPath: IndexPath) -> (key: String, value: String?) {
        let addressAnswers = answers[ProfProfile_Keys.storeAddress] as! [String:String]
        //let section = indexPath.section
        let row = indexPath.row

        switch row {
        case 0:
            let cep = addressAnswers[Address_Keys.postalCode]
            return ("CEP",SignUpMask.cep.applyOnText(text: cep ?? ""))
        case 1:
            let uf = addressAnswers[Address_Keys.district]
            return ("UF",uf)
        case 2:
            let city = addressAnswers[Address_Keys.city]
            return ("Cidade",city)
        case 3:
            let neighborhood = addressAnswers[Address_Keys.neighborhood]
            return ("Bairro",neighborhood)
        case 4:
            let street = addressAnswers[Address_Keys.place]
            return ("Rua",street)
        case 5:
            let number = addressAnswers[Address_Keys.number]
            return ("Número",number)
        case 6:
            let complement = addressAnswers[Address_Keys.complement]
            return ("Complemento",complement)
        default:
            return ("Extra",nil)
        }
    }
    
    public func titleForHeader(Answers answers: [String : Any], InSection section: Int) -> String? {
        return "Endereço"
    }
    
    public func didSelectAnswerAt(IndexPath indexPath: IndexPath, onVC vc: UIViewController, fromAnswers answers: [String : Any]) {
        
        switch indexPath.row {
        case 0:
            vc.performSegue(withIdentifier: "reviewCEP", sender: answers)
        case 1:
            vc.performSegue(withIdentifier: "reviewUF", sender: answers)
        case 2:
            vc.performSegue(withIdentifier: "reviewCidade", sender: answers)
        case 3:
            vc.performSegue(withIdentifier: "reviewBairro", sender: answers)
        case 4:
            vc.performSegue(withIdentifier: "reviewRua", sender: answers)
        case 5:
            vc.performSegue(withIdentifier: "reviewNumero", sender: answers)
        case 6:
            vc.performSegue(withIdentifier: "reviewComplemento", sender: answers)
        default:
            break
        }
        
    }
}
//MARK: - Final Check Data

public class UpmeP2CheckDataStepC:SignUpCheckDataStepC{
    public var canEdit: Bool = true
    
    public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let check = segue.destination as? SignUpCheckDataStepVC{
            check.controller = UpmeP2AddressCheckDataStepC()
        }
    }
    
    public func didTapNextStep(_ answers:[String : Any], onVC vc: UIViewController, completion: @escaping (Bool,[String:Any]?) -> ()) {
        
        if let id = UpmeSingleton.sharedInstance.professional?.id{
            
            //Correct method to be executed
            Professional_CRUD.finishSignUpWith(Params: answers, ID: id) { (success, jsonData) in
                
                DispatchQueue.main.async {
                    
                    if success{
                        if let jsonData = jsonData{
                            self.canEdit = false
                            //error
                            UpmeSingleton.sharedInstance.professional?.updateWithDictJSON(jsonData)
                            UpmeSingleton.sharedInstance.loadUserStufs()
                        }
                        //perform some segue to another vc where user will read some messages
                    }
                    else{
                        if let errors = jsonData{
                            //error 400 must be threated
                            RequestError.showAlertFor(data: errors, onVC: vc)
                        }
                    }
                    completion(success,jsonData)
                    
                }
                
            }
        }

    }
    //name,genero,nome estabelecimento, publico alvo, endereço, certificados
    
    public func numberOfSections(Answers answers: [String : Any]) -> Int {
        return 2
    }
    
    public func numberOfRows(Answers answers: [String : Any], Section section: Int) -> Int {
        
        return section == 0 ? 2 : 1
    }
    
    public func dataFor(Answers answers: [String : Any], AtIndexPath indexPath: IndexPath) -> (key: String, value: String?) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0{//dados pessoais
            switch row {
            case 0:
                var type:String?
                if let dict = answers[ProfBilling_Keys.taxDocument] as? [String:Any], let doc = TaxDocument(JSON: dict){
                    type = doc.type?.stringValue ?? ""
                }
                return ("Documento",type)
            case 1:
                let certificates = answers[ProfProfile_Keys.certificates] as! [[String:Any]]
                return ("Certificados","\(certificates.count)")
            default:
                return ("Extra",nil)
            }
        }
        else{
            
            switch row {
            /*case 0:
                let myBusiness = answers[ProfProfile_Keys.establishment_name] as! String
                return ("Nome",myBusiness)
            case 1:
                let audience = answers[ProfProfile_Keys.audience] as! String
                var text = "Unissex"
                
                if audience.compare(TargetAudience.men.rawValue) == .orderedSame{
                    text = "Masculino"
                }
                else if audience.compare(TargetAudience.women.rawValue) == .orderedSame{
                    text = "Feminino"
                }
                
                return ("Público Alvo",text)*/
            case 0:
                let addressDict = answers[ProfProfile_Keys.storeAddress] as! [String:String]
                let adressObject = Address(JSON: addressDict)!
                
                return ("Endereço",adressObject.mainString()!+"; "+adressObject.secondaryString())
            default:
                return ("Extra",nil)
            }

            
        }
        
    }
    
    public func titleForHeader(Answers answers: [String : Any], InSection section: Int) -> String? {
        return section == 0 ? "Dados Pessoais" : "Meu Negócio"
    }
    
    public func didSelectAnswerAt(IndexPath indexPath: IndexPath, onVC vc: UIViewController, fromAnswers answers: [String : Any]) {
        let section = indexPath.section
        if section == 0{
            switch indexPath.row {
            case 0:
                vc.performSegue(withIdentifier: "reviewTaxDocument", sender: answers)
            case 1:
                vc.performSegue(withIdentifier: "reviewCertificates", sender: answers)
            default:
                break
            }
        }
        else{
            switch indexPath.row {
            /*case 0:
                vc.performSegue(withIdentifier: "reviewBusiness", sender: answers)
            case 1:
                vc.performSegue(withIdentifier: "reviewAudience", sender: answers)*/
            case 0:
                vc.performSegue(withIdentifier: "reviewAddress", sender: answers)
            default:
                break
            }
        }
        
    }
}
