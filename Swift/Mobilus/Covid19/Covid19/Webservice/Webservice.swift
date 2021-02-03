

import Foundation
import Alamofire

class Webservice: NSObject {
    
    // O MAC Mini utilizado neste projeto não me pertence e eu apenas o uso
    // para projetos XCode. O projeto ASP.NET Core é executado em uma
    // máquina Windows. Por isso, foi necessário configurar o Visual Studio
    // para permitir acesso de máquinas da minha rede local ao servidor IIS.
    // Caso os projetos sejam executados na mesma máquina, basta alterar a
    // URL abaixo para http://localhost:<porta que o Visual Studio escolheu>
    private let BASE_URL = "http://192.168.100.9:45455/"
    
    func getCovidCases(completion: @escaping(Result<[CovidCase]>) -> Void) {
        var covidCases: [CovidCase] = []
        guard let url = URL(string: "\(BASE_URL)covidcases") else {
            return
        }
        Alamofire.request(url, method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let jsonData = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.webserviceDateFormat)
                    covidCases = try decoder.decode([CovidCase].self, from: jsonData)
                } catch let err {
                    fatalError("Não foi possível converter o json! \(err)")
                }
                completion(.success(covidCases))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func sendConsultas(consulta: Consulta){
        guard let url = URL(string: "\(BASE_URL)covidcases") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var consultaDic: Dictionary<String, Any> = [:]
        consultaDic["maxMortes"] = consulta.maxMortes
        consultaDic["dataConsulta"] = consulta.dataConsulta
        consultaDic["latitude"] = consulta.latitude
        consultaDic["longitude"] = consulta.longitude
        let json = try! JSONSerialization.data(withJSONObject: consultaDic, options: [])
        request.httpBody = json
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        Alamofire.request(request)
    }
}
