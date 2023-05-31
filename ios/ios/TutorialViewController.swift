//
//  TutorialViewController.swift
//  ios
//
//  Created by 박세인 on 2023/05/22.
//

import AVFoundation
import UIKit

class TutorialViewcontroller : UIViewController{
    var synthesizer = AVSpeechSynthesizer()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func TutorialCheck(_ sender: Any) {
        var tutorialcheck = "OK"
        UserDefaults.standard.set(tutorialcheck, forKey: "tutorialcheckkey")
        self.dismiss(animated: true)
    }
    @IBAction func AllergyTutorial(_ sender: Any) {
        textToSpeech("알레르기 화면 설명입니다. 초기 앱 실행 시 알레르기 설정이 안된 상태이면 QR 화면으로 바로 가지 않고 알레르기 설정 화면으로 넘어갑니다. 알레르기 화면에서 위에 알레르기 음성 인식 버튼이 있습니다. 해당 버튼을 클릭하면 음성 녹음이 시작되고 버튼을 다시 클릭하면 녹음이 멈춥니다. 음성 인식된 내용은 아래 텍스트 칸에 표시가 되고 클릭 시 확인할 수 있습니다. 화면 하단에는 QR 인식 화면으로 넘어갈 수 있는 버튼이 있습니다. ", synthesizer)
    }
    @IBAction func QRViewTutorial(_ sender: Any) {
        textToSpeech("제품에 있는 QR을 인식할 수 있는 화면입니다. 화면에 QR이 인식 되지 않으면 진동이나 음성 메세지로 안내합니다. QR 인식 성공 시 결과 화면으로 이동합니다.", synthesizer)
    }
    @IBAction func ResultTutorial(_ sender: Any) {
        textToSpeech("인식된 제품의 정보를 보여주는 화면으로 위에서 부터 상품 정보, 제조원, 알레르기 순으로 표시됩니다. 설정된 알레르기가 인식된 제품의 성분에 있으면 음성 메세지로 안내합니다.", synthesizer)
    }
}
