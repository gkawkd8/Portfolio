//
//  MovieInformationViewController.swift
//  Travel
//
//  Created by 황재현 on 05/08/2019.
//  Copyright © 2019 TJ. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

var arrmovieLike: Array<String> = ["", "", ""]
var arrmovieUID: Array<String> = ["", "", ""]
var intmovieCount: Int = 0

class MovieInformationViewController: UIViewController {
    var movieViewController: MovieViewController? = nil
    var structMovie: StructMovie = StructMovie()
    var structLike: StructLike = StructLike()
    var dicFavorite:[String:Any]? = nil
    //var arrayMovie = Array<StructMovie>()
    
    var db: Firestore!
    let storage = Storage.storage()
    
    var index: Int = 0
    var isFavorite = false

    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDirector: UILabel!
    @IBOutlet weak var lblReadRole: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var btnReservation: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        lblFirst.text = structMovie.movieTitle
        imgView.sd_setImage(with: URL(string: structMovie.movieImg!), placeholderImage: UIImage(named: "placeholder.png"))
        lblTitle.text = structMovie.movieTitle
        lblDirector.text = structMovie.movieDirector
        lblReadRole.text = structMovie.movieReadRole
        let newMovieSummary = structMovie.movieSummary?.replacingOccurrences(of: "\\n", with: "\n")
        lblSummary.text = newMovieSummary
        
        self.view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        // 라벨 두줄이상 사용 가능
        lblReadRole.numberOfLines = 0
        lblSummary.numberOfLines = 0
        // 단어가 끝나고 줄 바꿈
        lblReadRole.lineBreakMode = .byWordWrapping
        lblSummary.lineBreakMode = .byWordWrapping
        // 맨위에서 시작
        lblReadRole.sizeToFit()
        lblSummary.sizeToFit()
        
        btnReservation.backgroundColor = UIColor.blue
        btnReservation.tintColor = UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        print(dicFavorite!["movieArray"]!)
        print(structLike.movieArray!)
        var boolFavorite = false
        
        // '좋아요'가 되있는지 장소이름 확인 후 있으면 '좋아요'가 적용
        for placeName in self.dicFavorite!["movieArray"] as! NSArray {
            if let name = placeName as? String {
                if name ==  self.structMovie.movieTitle {
                    print("좋아요적용")
                    boolFavorite = true
                    break
                }
            }
        }
        if boolFavorite == true {
            self.isFavorite = true
            self.btnLike.setImage(UIImage(named: "likeon.png"), for: .normal)
        } else {
            self.isFavorite = false
            self.btnLike.setImage(UIImage(named: "likeoff.png"), for: .normal)
        }
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let newVC: MovieSearchViewController = storyboard.instantiateViewController(withIdentifier: "MovieSearchViewController") as! MovieSearchViewController
        newVC.structMovie = self.structMovie
        newVC.index = index
        
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func btnLikeClicked(_ sender: UIButton) {
        // '좋아요'를 취소했을 때
        if isFavorite == true {
            self.isFavorite = false
            btnLike.setImage(UIImage(named: "likeoff.png"), for: .normal)
            self.view.makeToast("저장이 삭제되었습니다.", duration: 2.0, position: .bottom)
            self.structLike.movieLikeCount! -= 1
            // '좋아요'를 취소했을 때 눌른 정보를 찜한 목록에서 삭제
            let docRef = db.collection("movies").document("\(structMovie.docID!)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    
                    if self.structLike.movieArray![0] == self.structMovie.movieTitle &&
                        self.structLike.movieUID![0] == self.structMovie.uid {
                        self.structLike.movieArray![0] = ""
                        self.structLike.movieUID![0] = ""
                        self.structLike.moviePath![0] = ""
                        self.arrayupdateDate(arr: self.structLike.movieArray!)
                        self.uidupdateDate(uid: self.structLike.movieUID!)
                        self.pathupdateDate(path: self.structLike.moviePath!)
                        self.likeupdateDate(count: self.structLike.movieLikeCount!)
                        print(self.structLike.movieArray!)
                        print(self.structLike.movieUID!)
                        print(self.structLike.moviePath!)
                        print(self.structLike.movieLikeCount!)
                        
                        self.movieViewController?.structLike = self.structLike
                    } else if self.structLike.movieArray![1] == self.structMovie.movieTitle &&
                        self.structLike.movieUID![1] == self.structMovie.uid {
                        self.structLike.movieArray![1] = ""
                        self.structLike.movieUID![1] = ""
                        self.structLike.moviePath![1] = ""
                        self.arrayupdateDate(arr: self.structLike.movieArray!)
                        self.uidupdateDate(uid: self.structLike.movieUID!)
                        self.pathupdateDate(path: self.structLike.moviePath!)
                        self.likeupdateDate(count: self.structLike.movieLikeCount!)
                        print(self.structLike.movieArray!)
                        print(self.structLike.movieUID!)
                        print(self.structLike.moviePath!)
                        print(self.structLike.movieLikeCount!)
                        
                        self.movieViewController?.structLike = self.structLike
                    } else if self.structLike.movieArray![2] == self.structMovie.movieTitle &&
                        self.structLike.movieUID![2] == self.structMovie.uid {
                        self.structLike.movieArray![2] = ""
                        self.structLike.movieUID![2] = ""
                        self.structLike.moviePath![2] = ""
                        self.arrayupdateDate(arr: self.structLike.movieArray!)
                        self.uidupdateDate(uid: self.structLike.movieUID!)
                        self.pathupdateDate(path: self.structLike.moviePath!)
                        self.likeupdateDate(count: self.structLike.movieLikeCount!)
                        print(self.structLike.movieArray!)
                        print(self.structLike.movieUID!)
                        print(self.structLike.moviePath!)
                        print(self.structLike.movieLikeCount!)
                        
                        self.movieViewController?.structLike = self.structLike
                    }
                } else {
                    print("Document does not exist")
                }
            }
        } else {
            // '좋아요'를 했을 때
            //var countFavorite = 0
            for placeName in self.dicFavorite!["movieArray"] as! NSArray {
                if let name = placeName as? String {
                    if name.count > 0 {
                        //countFavorite += 1
                    }
                }
            }
            if structLike.movieLikeCount! >= 3 {
                // '좋아요'의 갯수가 3개 초과되면 alert창 생성
                let logoutAlert = UIAlertController(title: "", message: "더 이상 찜하실 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
                let noAlert = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                logoutAlert.addAction(noAlert)
                
                present(logoutAlert, animated: true, completion: nil)
                
                return
            }
            self.isFavorite = true
            btnLike.setImage(UIImage(named: "likeon.png"), for: .normal)
            self.view.makeToast("항목이 저장됩니다.", duration: 2.0, position: .bottom)
            structLike.movieLikeCount! += 1
            // '좋아요'를 눌렀을 때 눌른 정보를 찜한 목록에 저장
            let docRef = db.collection("movies").document("\(structMovie.docID!)")
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    if self.structLike.movieArray![0] == "" {
                        self.structLike.movieArray![0] = self.structMovie.movieTitle ?? "테스트1"
                        self.structLike.movieUID![0] = self.structMovie.uid ?? "uid test1"
                        self.structLike.moviePath![0] = "movies/\(self.structMovie.docID!)"
                        self.arrayupdateDate(arr: self.structLike.movieArray!)
                        self.uidupdateDate(uid: self.structLike.movieUID!)
                        self.pathupdateDate(path: self.structLike.moviePath!)
                        self.likeupdateDate(count: self.structLike.movieLikeCount!)
                        print(self.structLike.movieArray!)
                        print(self.structLike.movieUID!)
                        print(self.structLike.moviePath!)
                        print(self.structLike.movieLikeCount!)
                        
                        self.movieViewController?.structLike = self.structLike
                    } else if self.structLike.movieArray![1] == "" {
                        self.structLike.movieArray![1] = self.structMovie.movieTitle ?? "테스트1"
                        self.structLike.movieUID![1] = self.structMovie.uid ?? "uid test1"
                        self.structLike.moviePath![1] = "movies/\(self.structMovie.docID!)"
                        self.arrayupdateDate(arr: self.structLike.movieArray!)
                        self.uidupdateDate(uid: self.structLike.movieUID!)
                        self.pathupdateDate(path: self.structLike.moviePath!)
                        self.likeupdateDate(count: self.structLike.movieLikeCount!)
                        print(self.structLike.movieArray!)
                        print(self.structLike.movieUID!)
                        print(self.structLike.moviePath!)
                        print(self.structLike.movieLikeCount!)
                        
                        self.movieViewController?.structLike = self.structLike
                    } else if self.structLike.movieArray![2] == "" {
                        self.structLike.movieArray![2] = self.structMovie.movieTitle ?? "테스트1"
                        self.structLike.movieUID![2] = self.structMovie.uid ?? "uid test1"
                        self.structLike.moviePath![2] = "movies/\(self.structMovie.docID!)"
                        self.arrayupdateDate(arr: self.structLike.movieArray!)
                        self.uidupdateDate(uid: self.structLike.movieUID!)
                        self.pathupdateDate(path: self.structLike.moviePath!)
                        self.likeupdateDate(count: self.structLike.movieLikeCount!)
                        print(self.structLike.movieArray!)
                        print(self.structLike.movieUID!)
                        print(self.structLike.moviePath!)
                        print(self.structLike.movieLikeCount!)
                        
                        self.movieViewController?.structLike = self.structLike
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    // 업데이트 함수
    func likeupdateDate(count: Int) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["movieLikeCount": count])
        }
    }
    func arrayupdateDate(arr: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["movieArray": arr])
        }
    }
    func uidupdateDate(uid: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["movieUID": uid])
        }
    }
    func pathupdateDate(path: Array<String>) {
        db = Firestore.firestore()
        
        if let email = Auth.auth().currentUser?.email {
            db.collection("favorite").document("\(email)").updateData(["moviePath": path])
        }
    }
    @IBAction func btnBackPage(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//var director: Array<String> = ["김주환",
//                               "존 파브로",
//                               "조철현",
//                               "이상근",
//                               "가이 리치",
//                               "존 왓츠",
//                               "원신연",
//                               "조나단 레빈",
//                               "조시 쿨리",
//                               "크리스 리노드"]
//var readrole: Array<String> = ["박서준(용후), 안성기(안신부), 우도환(지신)",
//                               "도날드 글로버(심바), 비욘세(날라), 제임스 얼 존스(무파사)",
//                               "송강호(세종대왕), 박해일(신미스님), 전미선(소현왕후)",
//                               "조정석(용남), 윤아(의주)",
//                               "메나 마수드(알라딘), 윌 스미스(지니), 나오미 스콧(자스민)",
//                               "톰 홀랜드(피터 파커/스파이더맨), 사무엘L.잭슨(닉 퓨리), 젠다야 콜랜(미쉘 존스)",
//                               "유해진(황해철), 류준열(이장하), 조우진(마병구)",
//                               "샤를리즈 테론(샬롯 필드), 세스 로건(프레드 플라스키), 준 다이앤 라피엘(매기 밀리킨)",
//                               "톰 행크스(우디), 팀 알렌(버즈), 애니 파츠(보핍)",
//                               "패튼 오스왈트(맥스), 케빈 하트(스노우볼), 에릭 스톤스트릿(듀크)"]
//var summary: Array<String> = ["어릴 적 아버지를 잃은 뒤 세상에 대한 불신만 남은 격투기 챔피언'용후'(박서준). 어느 날 원인을 알 수 없는 깊은 상처가 손바닥에 생긴 것을 발견하고, 도움을 줄 누군가가 있다는 장소로 향한다. 그곳에서 바티칸에서 온 구마사제 '안신부'(안성기)를 만나 자신의 상처 난 손에 특별한 힘이 있음을 깨닫게 되는 '용후'. 이를 통해 세상을 혼란에 빠뜨리는 악의 존재를 알게 되고, 강력한 배후이자 악을 퍼뜨리는 검은 주교 '지신'(우도환)을 찾아 나선 '안신부'와 함께 하게 되는데...!",
//                              "새로운 세상, 너의 시대가 올 것이다! 어린 사자 '심바'는 프라이드 랜드의 왕인 아버지 '무파사'를 야심과 욕망이 가득한 삼촌'스카'의 음모로 잃고 왕국에서도 쫓겨난다. 기억해라! 네가 누군지. 아버지의 죽음에 대한 죄책감에 시달리던 '심바'는 의욕 충만한 친구들 '품바'와 '티몬'의 도움으로 희망을 되찾는다. 어느 날 우연히 옛 친구 '날라'를 만난 '심바'는 과거를 마주할 용기를 얻고, 진정한 자신의 모습을 찾아 위대하고도 험난한 도전을 떠나게 되는데...",
//                              "이깟 문자, 주상 죽고 나먼 시체와 함께 묻어버리면 그만이지 문자와 지식을 권력으로 독점했던 시대 모든 신하들의 반대에 무릅쓰고, 훈민정음을 창제했던 세종의 마지막 8년. 나라의 가장 고귀한 임금 '세종'과 가장 천한 신분 스님 '신미'가 만나 백성을 위해 뜻을 모아 나라의 글자를 만들기 시작한다. 모두가 알고 있지만 아무도 모르는 한글 창제의 숨겨진 이야기! 1443, 불굴의 신념으로 한글을 만들었으나 역사에 기록되지 못한 그들의 이야기가 시작된다.",
//                              "짠내 폭발 청년백수, 전대미문의 진짜 재난을 만나다! 대학교 산악 동아리 에이스 출신이지만 졸업 후 몇 년째 취업 실패로 눈칫밥만 먹는 용남은 온 가족이 참석한 어머니의 칠순 잔치에서 연회장 직원으로 취업한 동아리 후배 의주를 만난다 어색한 재회도 잠시, 칠순 잔치가 무르익던 중 의문의 연기가 빌딩에서 피어 오르며 피할 새도 없이 순식간에 도심 전체는 유독가스로 되덮여 일대혼란에 휩싸이게 된다. 용남과 의주는 산악 동아리 시절 쌓아 뒀던 모든 체력과 스킬을 동원해 탈출을 향한 기자를 발휘하기 시작하는데...",
//                              "머니먼 사막 속 신비의 아그라바 왕국의 시대. 좀도둑 '알라딘'은 마법사 '자파'의 의뢰로 마법 램프를 찾아 나섰다가 주인에게 세 가지 소원을 들어주는 지니를 만나게 되고, 자스민 공주의 마음을 얻으려다 생각도 못했던 모험에 휘말리게 되는데...",
//                              "모든 것이 다시 시작된다! \n '엔드게임'이후 변화된 세상, 스파이더맨 '피터 파커'는 학교 친구들과 유럽 여행을 떠나게 된다. 그런 그의 앞에 '닉 퓨리'가 등장해 도움을 요청하고 정체불명의 조력자 '미스테리오'까지 합류하게 되면서 전 세계를 위협하는 새로운 빌런 '엘리멘탈 크리쳐스'와 맞서야만 하는 상황에 놓이게 되는데...",
//                              "임무는 단 하나! 달리고 달려, 일본군을 죽음의 골짜기로 유인하라! 1919년 3.1운동 이후 봉오동 일대에서 독립군의 무장항쟁이 활발해진다. 일본은 신식 무기로 무장한 월강추격대를 필두로 독립군 토벌 작전을 시작하고, 독립군은 불리한 상황을 이겨내기 위해 봉오동 지형을 활용하기로 한다. 항일대도를 휘두르는 비범한 칼쏨시의 해철(유해진)과 발 빠른 독립군 분대장 장하(류준열) 그리고 해철의 오른팔이자 날쌘 저격수 병구(조우진)는 빗발치는 총탄과 포위망을 뚫고 죽음의 골짜기로 일본군을 유인한다. 계곡과 능선을 넘나들며 귀신같은 움직임과 예측할 수 없는 지략을 펼치는 독립군의 활약에 일본군은 당황하기 시작하는데... 1920년 6월, 역사에 기록된 독립군의 첫 승리 봉오동 죽음의 골짜기에 묻혔던 이야기가 지금부터 시작된다.",
//                              "어리다고 놀리지 말아요! 첫사랑 베이비시터 누나 전직 기자 지금은 백수인 '프레드 플라스키'(세스 로건)는 20년 만에 첫사랑 베이비시터'샬롯 필드'(샤를리즈 테론)와 재회한다. 그런데 그녀가!? 미 최연소 국무 장관이자 세계에서 가장 영향력 있는 여성 중 한 명인 '샬롯'이 바로 베이비시터 그녀라는 것은 믿기지 않지만 실화이다. 인생에 공통점이라고는 1도 없는 두 사람. 대선 후보로 출마를 준비 중인 '샬롯'은 모두의 예상을 깨고 자신의 선거 캠페인 연설문 작가로 '프레드'를 고용한다. 어디로 튈지 모르는 '프레드'때문에 선거 캠페인은 연일 비상인 가운데, 뜻밖에 그의 스파크는 '샬롯'과의 로맨스로 튀어 버리는데... 사고 치는데 천부적인 재능이 있는 남자. 머리부터 발끝까지 완벽한 여자 이 조합 실화?",
//                              "우리의 여행은 아직 끝나지 않았다! 장난감의 운명을 거부하고 떠난 새 친구 '포키'를 찾기 위해 길 위에 나선 '우디'는 우연히 오랜 친구 '보핍'을 만나고 그녀를 통해 새로운 세상에 눈을 뜨게 된다. 한편, '버즈'와 친구들은 사라진 '우디'와 '포키'를 찾아 세상 밖 위험천만한 모험을 떠나게 되는데...",
//                              "세상에 나쁜 개는 없다는데...우리 애는 도대체 무슨 생각인거죠? 집을 비우면 닷기 시작되는 펫들의 시크릿 라이프! 집구석 걱정에 하루도 편할 날이 없는 '맥스' 캣닢을 사랑하는 자유로운 영혼 '클로이' 슈퍼히어로를 따라 하는 토끼'스노우볼' 완벽하게 고양이가 되고픈 강아지 '기젯'까지 아직도 나만 몰랐던 마이펫들의 속마음이 공개된다!"]
