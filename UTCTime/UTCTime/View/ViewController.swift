//
//  ViewController.swift
//  UTCTime
//
//  Created by Chiwon Song on 2021/05/31.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - MODEL

    struct UtcTimeModel: Codable {
        let id: String
        let currentDateTime: String
        let utcOffset: String
        let isDayLightSavingsTime: Bool
        let dayOfTheWeek: String
        let timeZoneName: String
        let currentFileTime: Int
        let ordinalDate: String
        let serviceResponse: String?

        enum CodingKeys: String, CodingKey {
            case id = "$id"
            case currentDateTime
            case utcOffset
            case isDayLightSavingsTime
            case dayOfTheWeek
            case timeZoneName
            case currentFileTime
            case ordinalDate
            case serviceResponse
        }
    }

    // CONTROLLER

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNow()
    }

    var currentDateTime = Date()

    private func updateDateTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        datetimeLabel.text = formatter.string(from: currentDateTime)
    }

    private func fetchNow() {
        let url = "http://worldclockapi.com/api/json/utc/now"
        
        datetimeLabel.text = "Loading.."
        
        URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] data, _, _ in
            guard let data = data else { return }
            guard let model = try? JSONDecoder().decode(UtcTimeModel.self, from: data) else { return }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"

            guard let now = formatter.date(from: model.currentDateTime) else { return }

            self?.currentDateTime = now

            DispatchQueue.main.async {
                self?.updateDateTime()
            }
        }.resume()
    }

    // MARK: - VIEW

    @IBOutlet var datetimeLabel: UILabel!

    @IBAction func onYesterday() {
        guard let yesterday = Calendar.current.date(byAdding: .day,
                                                    value: -1,
                                                    to: currentDateTime) else {
            return
        }
        currentDateTime = yesterday
        updateDateTime()
    }

    @IBAction func onNow() {
        fetchNow()
    }

    @IBAction func onTomorrow() {
        guard let tomorrow = Calendar.current.date(byAdding: .day,
                                                   value: +1,
                                                   to: currentDateTime) else {
            return
        }
        currentDateTime = tomorrow
        updateDateTime()
    }
}
