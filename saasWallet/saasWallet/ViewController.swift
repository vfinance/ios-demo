//
//  ViewController.swift
//  saasWallet
//
//  Created by huangjiawei on 16/10/19.
//  Copyright © 2016年 vfinance. All rights reserved.
//

import UIKit
import saasWalletSDK

class ViewController: UIViewController, SaasWalletSDKDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var payInfoContainerView: UIView!
    
    @IBOutlet weak var payAmountTextField: UITextField!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var orderNumberTextField: UITextField!
    
    @IBOutlet weak var payChannelTableView: UITableView!
    @IBOutlet weak var payChannelTableViewHeightConstraint: NSLayoutConstraint!
    
    var payChannels: [String] = []
    var selectedPayChannelIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configView()
        
        payChannelTableView.delegate = self
        payChannelTableView.dataSource = self
        payChannelTableView.backgroundColor = UIColor.clear
        payChannelTableView.tableFooterView = UIView()
        payChannelTableView.isScrollEnabled = false
        payChannelTableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        
        SaasWalletSDK.setSaasWalletSDKDelegate(self)
        SaasWalletSDK.queryPayChannel()
        
        payInfoContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGestureRecognized)))
        payAmountTextField.delegate = self
        productNameTextField.delegate = self
        orderNumberTextField.delegate = self
        
        payAmountTextField.text = "0.1"
        payAmountTextField.isEnabled = false
        productNameTextField.text = "测试商品"
        orderNumberTextField.text = "demo"+String(format: "%.0f", NSDate().timeIntervalSince1970*1000.0)
    }
    
    func tapGestureRecognized() {
        payAmountTextField.resignFirstResponder()
        productNameTextField.resignFirstResponder()
        orderNumberTextField.resignFirstResponder()
    }
    
    func configView() {
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 130/255.0, green: 131/255.0, blue: 132/255.0, alpha: 1.0)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        payInfoContainerView.addSubview(separator)
        
        payInfoContainerView.addConstraints([
            NSLayoutConstraint(item: separator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0.5),
            NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: payAmountTextField, attribute: .bottom, multiplier: 1.0, constant: 10.0),
            NSLayoutConstraint(item: separator, attribute: .leading, relatedBy: .equal, toItem: payInfoContainerView, attribute: .leading, multiplier: 1.0, constant: 18.0),
            NSLayoutConstraint(item: separator, attribute: .trailing, relatedBy: .equal, toItem: payInfoContainerView, attribute: .trailing, multiplier: 1.0, constant: -18.0)
            ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onSaasWalletSDKResp(_ resp: VFBaseResp!) {
        switch resp.type {
        case VFObjsType.payResp:
            if let index = selectedPayChannelIndex {
                if index < payChannels.count {
                    SaasWalletSDK.notifyTradeResult(orderNumberTextField.text, andChannelCode: payChannels[index])
                }
            }
            if let resp = resp as? VFPayResp {
                if resp.resultCode == 0 {
                    self.showAlertView(message: resp.resultMsg)
                }
                else {
                    self.showAlertView(message: "\(resp.resultMsg ?? ""): \(resp.errDetail ?? "")")
                }
            }
        case VFObjsType.queryChannel:
            if resp.resultCode == VFErrCode.success.rawValue {
                let result = resp.resultMsg!
                let channelArray = result.components(separatedBy: ",")
                payChannels.removeAll()
                
                for channel in channelArray {
                    if channel == "ALIAPPPAY" {
                        payChannels.append("alipay")
                    }
                    else if channel == "WXAPPPAY" {
                        payChannels.append("wxpay")
                    }
                    else if channel == "UNIONPAY" {
                        payChannels.append("unpay")
                    }
                }
                
                payChannelTableView.reloadData()
            }
            else {
                self.showAlertView(message: resp.resultMsg)
            }
        default:
            break
        }
    }
    
    func showAlertView(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.textLabel?.textColor = UIColor.black
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.detailTextLabel?.textColor = UIColor(white: 152/255.0, alpha: 1.0)
        
        let payChannel = payChannels[indexPath.row]
        
        switch payChannel {
        case "alipay":
            cell.imageView?.image = UIImage(named: "alipay_icon")
            cell.textLabel?.text = "支付宝支付"
            cell.detailTextLabel?.text = "使用支付宝支付, 以人民币CNY计费"
        case "wxpay":
            cell.imageView?.image = UIImage(named: "wxpay_icon")
            cell.textLabel?.text = "微信支付"
            cell.detailTextLabel?.text = "使用微信支付, 以人民币CNY计费"
        case "unpay":
            cell.imageView?.image = UIImage(named: "unpay_icon")
            cell.textLabel?.text = "银联在线"
            cell.detailTextLabel?.text = "使用银联在线支付, 以人民币CNY计费"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        payAmountTextField.resignFirstResponder()
        productNameTextField.resignFirstResponder()
        orderNumberTextField.resignFirstResponder()
        
        if payAmountTextField.text!.isEmpty {
            self.showAlertView(message: "请输入支付金额")
            return
        }
        
        if productNameTextField.text!.isEmpty {
            self.showAlertView(message: "请输入商品名称")
            return
        }
        
        if orderNumberTextField.text!.isEmpty {
            self.showAlertView(message: "请输入订单编号")
            return
        }
        
        let payChannel = payChannels[indexPath.row]
        
        let payRequest = VFPayReq()
        
        switch payChannel {
        case "wxpay":
            payRequest.channel = PayChannel.wxApp
        case "alipay":
            payRequest.channel = PayChannel.aliApp
        case "unpay":
            payRequest.channel = PayChannel.unApp
        default:
            print("unsupported channel")
            return
        }
        
        selectedPayChannelIndex = indexPath.row
        
        payRequest.title = productNameTextField.text
        payRequest.totalFee = "\(Int(Double(payAmountTextField.text!)!*100))"
        payRequest.billNo = orderNumberTextField.text
        payRequest.scheme = "vfsaaswallet"
        payRequest.billTimeOut = 300
        payRequest.viewController = self
        payRequest.cardType = 0
        payRequest.optional = NSMutableDictionary()
        
        SaasWalletSDK.sendVFReq(payRequest)
    }
    
    // MARK: - Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        if textField == payAmountTextField {
            
            if (textField.text?.characters.count)! + string.characters.count - range.length > 12 {
                return false
            }
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            let expression = "^([1-9][0-9]*|0)((\\.)[0-9]{0,2})?$"
            
            if let regex = try? NSRegularExpression(pattern: expression, options: .caseInsensitive) {
                if regex.numberOfMatches(in: newString, options: .withTransparentBounds, range: NSMakeRange(0, newString.characters.count)) == 1 {
                    return true
                }
                else {
                    return false
                }
            }
            
            return true
        }
        else {
            if (textField.text?.characters.count)! + string.characters.count - range.length > 24 {
                return false
            }
            
            return true
        }
    }
    
}

