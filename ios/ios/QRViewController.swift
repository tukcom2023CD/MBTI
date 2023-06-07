//
//  QRViewController.swift
//  ios
//
//  Created by 장지수 on 2023/01/25.
//

import UIKit
import AVFoundation
import Alamofire
import RealmSwift



class QRViewController: UIViewController {
    
    //실시간 캡처를 수행하기 위해서 AVCaptureSession 개체를 인스턴스화.
    private var captureSession = AVCaptureSession()
    var synthesizer = AVSpeechSynthesizer()
    var realm = try! Realm()
    var timeTrigger = true
    var realTime = Timer()
    var result = true
    //    func moveresult(){
    ////        let resultview = self.storyboard?.instantiateViewController(withIdentifier: "QRCresult")
    ////        resultview?.modalTransitionStyle = UIModalTransitionStyle.coverVertical
    ////        self.present(resultview!, animated: true, completion: nil)
    //        let selectViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectViewController") as! SelectViewController
    //        let navigationController = UINavigationController(rootViewController: selectViewController)
    //        self.present(navigationController, animated: true, completion: nil)
    //    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        basicSetting()
    }
    func shouldShowAllergyView() -> Bool {
        var string = UserDefaults.standard.string(forKey: "myStringKey")
        if string == nil {
            return true
        }
        else {
            return false
        }
    }
    func shouldShowTutorialView() -> Bool {
        var initialcheck = UserDefaults.standard.string(forKey: "tutorialcheckkey")
        if initialcheck == nil {
            return true
        }
        else {
            return false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if shouldShowTutorialView() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tutorialVC = storyboard.instantiateViewController(withIdentifier: "tutorialView") as! TutorialViewcontroller
            tutorialVC.modalPresentationStyle = .fullScreen
            textToSpeech("초기 실행으로 튜토리얼 화면으로 이동합니다.", synthesizer)
            present(tutorialVC, animated: true, completion: nil)
            captureSession.stopRunning()
            stopAction()
        }
        else if shouldShowAllergyView() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let allergyVC = storyboard.instantiateViewController(withIdentifier: "testView") as! testViewController
            allergyVC.modalPresentationStyle = .fullScreen
            textToSpeech("알레르기 설정을 하지 않아 알레르기 설정 화면으로 이동합니다.", synthesizer)
            present(allergyVC, animated: true, completion: nil)
            captureSession.stopRunning()
            stopAction()
        }
        else {
            captureSession.startRunning()
            startAction()
        }
    }
    
    @IBAction func back(_ sender: Any){
        let AllergyViewController = self.storyboard?.instantiateViewController(withIdentifier: "testView") as! testViewController
        AllergyViewController.modalPresentationStyle = .fullScreen // 화면이 사라지지 않는 문제가 계속 발생할 경우 추가해주세요.
        self.present(AllergyViewController, animated: true, completion: nil)
        captureSession.stopRunning()
        stopAction()
    }
    
}

extension QRViewController {
    
    private func basicSetting() {
        
        // AVCaptureDevice : capture sessions 에 대한 입력(audio or video)과 하드웨어별 캡처 기능에 대한 제어를 제공하는 장치.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            
            // 시뮬레이터에서는 카메라를 사용할 수 없기 때문에 시뮬레이터에서 실행하면 에러가 발생한다.
            fatalError("No video device found")
        }
        do {
            // 적절한 inputs 설정
            // AVCaptureDeviceInput : capture device 에서 capture session 으로 media 를 제공하는 capture input.
            // 즉, 특정 device 를 사용해서 input 를 초기화.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // session 에 주어진 input 를 추가.
            captureSession.addInput(input)
            
            // 적절한 outputs 설정
            // AVCaptureMetadataOutput : capture session 에 의해서 생성된 시간제한 metadata 를 처리하기 위한 capture output.
            // 즉, 영상으로 촬영하면서 지속적으로 생성되는 metadata 를 처리하는 output 이라는 말.
            let output = AVCaptureMetadataOutput()
            
            // session 에 주어진 output 를 추가.
            captureSession.addOutput(output)
            
            // AVCaptureMetadataOutputObjectsDelegate 포로토콜을 채택하는 delegate 와 dispatch queue 를 설정한다.
            // queue : delegate 의 메서드를 실행할 큐이다. 이 큐는 metadata 가 받은 순서대로 전달되려면 반드시 serial queue(직렬큐) 여야 한다.
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // 리더기가 인식할 수 있는 코드 타입을 정한다. 이 프로젝트의 경우 qr.
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // 카메라 영상이 나오는 layer 와 + 모양 가이드 라인을 뷰에 추가하는 함수 호출.
            setVideoLayer()
            setGuideCrossLineView()
            startAction()
            
            // startRunning() 과 stopRunning() 로 흐름 통제
            // input 에서 output 으로의 데이터 흐름을 시작
            captureSession.startRunning()
        }
        catch {
            print("error")
        }
    }
    private func startAction() {
        if(timeTrigger) {
            checkTimeTrigger()
        }
    }
    private func checkTimeTrigger() {
        realTime = Timer.scheduledTimer(timeInterval: 5, target: self,
                                        selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timeTrigger = false
    }
    @objc func updateCounter() {
        textToSpeech("QR 코드가 인식되지 않았습니다.",synthesizer)
    }
    private func stopAction() {
        timeTrigger = true
        realTime.invalidate()
    }
    
    private func setVideoLayer() {
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //        videoLayer.frame = view.layer.bounds
        //        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        let previewView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.9))
        videoLayer.frame = previewView.bounds
        //        view.addSubview(previewView)
        view.layer.addSublayer(videoLayer)
        //        view.layer.addSublayer(videoLayer)
        
    }
    
    private func setGuideCrossLineView() {
        let guideCrossLine = UIImageView()
        guideCrossLine.image = UIImage(systemName: "plus")
        guideCrossLine.tintColor = .green
        guideCrossLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guideCrossLine)
        
        NSLayoutConstraint.activate([
            guideCrossLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideCrossLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            guideCrossLine.widthAnchor.constraint(equalToConstant: 30),
            guideCrossLine.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}

// metadata capture ouput 에서 생성된 metatdata 를 수신하는 메서드.
// 이 프로토콜은 위에서처럼 AVCaptureMetadataOutput object 가 채택해야만 한다. 단일 메서드가 있고 옵션이다.
// 이 메서드를 사용하면 capture metadata ouput object 가 connection 을 통해서 관련된 metadata objects 를 수신할 때 응답할 수 있다.(아래 메서드의 파라미터를 통해 다룰 수 있다.)
// 즉, 이 프로토콜을 통해서 metadata 를 수신해서 반응할 수 있다.
extension QRViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    
    // caputure output object 가 새로운 metadata objects 를 보냈을 때 알린다.
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        // metadataObjects : 새로 내보낸 AVMetadataObject 인스턴스 배열이다.
        if let metadataObject = metadataObjects.first {
            
            // AVMetadataObject 는 추상 클래스이므로 이 배열의 object 는 항상 구체적인 하위 클래스의 인스턴스여야 한다.
            // AVMetadataObject 를 직접 서브클래싱해선 안된다. 대신 AVFroundation 프레임워크에서 제공하는 정의된 하위 클래스 중 하나를 사용해야 한다.
            // AVMetadataMachineReadableCodeObject : 바코드의 기능을 정의하는 AVMetadataObject 의 구체적인 하위 클래스. 인스턴스는 이미지에서 감지된 판독 가능한 바코드의 기능과 payload 를 설명하는 immutable object 를 나타낸다.
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
                return
            }
            
            // qr코드가 가진 문자열이 URL 형태를 띈다면 출력.(아무런 qr코드나 찍는다고 출력시키면 안되니까 여기서 분기처리 가능. )
            if stringValue.hasPrefix("http://www.foodqr.kr") || stringValue.hasPrefix("https://www.foodqr.kr/foodqr?")  {
                //                UIApplication.shared.open(URL(string:stringValue)!,options: [:])
                UIDevice.vibrate()
                stopAction()
                let startIndex = stringValue.index(stringValue.startIndex,offsetBy: 35)
                let range = startIndex...
                let Prdno = stringValue[range]
                let productId = Int(Prdno)!
                //postTest(String(Prdno),stringValue)
                let DBdata = realm.objects(DBProduct.self).filter("productId == %@",productId)
                
                
                if DBdata.isEmpty {
                    print("데이터 DB에 존재하지 않음.")
                    getTest(prdno: String(Prdno)){ product in
                        // product를 다루는 코드 블록
                        guard let product = product else { return }
                        let dbProduct = DBProduct()
                        dbProduct.productId = product.productId
                        dbProduct.allergy = product.allergy
                        dbProduct.manufacturer = product.manufacturer
                        dbProduct.productname = product.productName
                        do {
                            let realm = try! Realm()
                            try! realm.write {
                                realm.add(dbProduct)
                            }
                        } catch {
                            print("Error initialising new realm \(error)")
                            
                            
                        }
                        DispatchQueue.main.async {
                            let selectViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectViewController") as! SelectViewController
                            selectViewController.selectedProduct = product
                            let navigationController = UINavigationController(rootViewController: selectViewController)
                            navigationController.modalPresentationStyle = .fullScreen
                            self.present(navigationController, animated: true, completion: {
                                // QRViewController를 navigationController 스택에서 제거합니다.
                                if let index = self.navigationController?.viewControllers.firstIndex(of: self) {
                                    self.navigationController?.viewControllers.remove(at: index)
                                }
                            })
                        }
                    }
                }
                else {
                    let products : [Product] = DBdata.compactMap { dbProduct in
                        guard !dbProduct.allergy.isEmpty,
                              !dbProduct.productname.isEmpty,
                              !dbProduct.manufacturer.isEmpty
                        else {
                            return nil
                        }
                        return Product(productId: dbProduct.productId, allergy: dbProduct.allergy, productName: dbProduct.productname, manufacturer: dbProduct.manufacturer)
                    }
                    
                    let selectViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectViewController") as! SelectViewController
                    selectViewController.selectedDBProduct = products
                    let navigationController = UINavigationController(rootViewController: selectViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: {
                        // QRViewController를 navigationController 스택에서 제거합니다.
                        if let index = self.navigationController?.viewControllers.firstIndex(of: self) {
                            self.navigationController?.viewControllers.remove(at: index)
                        }
                    })
                }
                
                
                // startRunning() 과 stopRunning() 로 흐름 통제
                // input 에서 output 으로의 흐름 중지
                self.captureSession.stopRunning()
                //                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    //    func postTest(_ Prdno:String,_ stringValue:String) {
    ////        let url = "https://e5604732-27a0-49d8-a142-83088a72ada2.mock.pstmn.io/list" 테스트.. ( post 성공도 되지 않음. )
    ////        let url = "https://httpbin.org/post" // 테스트 용도 ( 이 url은 post 성공이 되지만, 해당 데이터가 들어가는지 의문 )
    //        let url = "https://9551865c-5b5d-4474-b7b8-61e173a29b95.mock.pstmn.io"
    //        var request = URLRequest(url: URL(string: url)!)
    //        request.httpMethod = "POST"
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.timeoutInterval = 10
    //
    //        let params = ["Prdno":Prdno, "URL":stringValue] as Dictionary
    //        do {
    //            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
    //        } catch {
    //                print("http Body Error")
    //        }
    //        AF.request(request).responseString { (response) in
    //            switch response.result {
    //                case .success:
    //                    print("POST 성공")
    //                    print(response)
    //                case .failure(let error):
    //                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
    //            }
    //        }
    //    }
    //    func getTest(prdno : String){
    //        var components = URLComponents(string: "https://1e7cd63b-50a6-42ee-98b4-84991cb7b775.mock.pstmn.io")
    //        //도메인 뒤에 API 주소 삽입
    //        components?.path = "/api/product/\(prdno)"
    //        //파라미터 추가할거 있으면 작성
    //        //URL 생성
    //        guard let url = components?.url else { return }
    //        //리퀘스트 생성
    //        var request: URLRequest = URLRequest(url: url)
    //        //통신 방법 지정
    //        request.httpMethod = "GET"
    //        //태스크 생성
    //        let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //            //여기서 에러 체크 및 받은 데이터 가공하여 사용
    //            guard let data,
    //                  let str = String(data: data, encoding:.utf8) else { return }
    //            do {
    //                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    //                guard let productId = json?["productId"] as? Int,
    //                      let allergy = json?["allergy"] as? String,
    //                      let productName = json?["productname"] as? String,
    //                      let manufacturer = json?["manufacturer"] as? String else { return }
    //                let product = Product(productId: productId, allergy: allergy, productName: productName, manufacturer: manufacturer)
    //            } catch let error {
    //                print(error.localizedDescription)
    //            }
    //
    //
    //        }
    //        //실행
    //        task.resume()
    //
    //    }
    func getTest(prdno : String, completion: @escaping (Product?) -> Void) {
        var components = URLComponents(string: "https://88d105cd-2761-4ece-a593-39b7760fc167.mock.pstmn.io")
        components?.path = "/api/product/\(prdno)"
        guard let url = components?.url else { return }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let str = String(data: data, encoding:.utf8) else {
                completion(nil)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let productId = json?["productId"] as? Int,
                      let allergy = json?["allergy"] as? String,
                      let productName = json?["productname"] as? String,
                      let manufacturer = json?["manufacturer"] as? String else {
                    completion(nil)
                    return
                }
                let product = Product(productId: productId, allergy: allergy, productName: productName, manufacturer: manufacturer)
                completion(product)
            } catch let error {
                print(error.localizedDescription)
                completion(nil)
            }#imageLiteral(resourceName: "스크린샷 2023-06-07 오후 12.16.53.png")
        }
        task.resume()
    }
}
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
