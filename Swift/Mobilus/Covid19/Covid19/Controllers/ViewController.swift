

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var datasUltimaSemana: UILabel!
    @IBOutlet weak var mediaMovelUltimaSemana: UILabel!
    @IBOutlet weak var percentualComparativoUltimaSemana: UILabel!
    @IBOutlet weak var dadosUltimaSemana: UITableView!
    
    @IBOutlet weak var datasPenultimaSemana: UILabel!
    @IBOutlet weak var mediaMovelPenultimaSemena: UILabel!
    @IBOutlet weak var percentualComparativoPenultimaSemana: UILabel!
    @IBOutlet weak var dadosPenultimaSemana: UITableView!
    
    private var covidCases: [CovidCase] = []
    
    private var casosUltimaSemana: [CovidCase] = []
    private var casosPenultimaSemana: [CovidCase] = []
    
    private var mmUltimaSemana: Float = 0.0
    private var mmPenultimaSemana: Float = 0.0
    
    private var percentualComparativo: Float = 0.0
    
    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var consultaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dadosUltimaSemana.delegate = self
        dadosUltimaSemana.dataSource = self
        dadosPenultimaSemana.delegate = self
        dadosPenultimaSemana.dataSource = self
        
        consultaButton.isHidden = true
        
        Webservice().getCovidCases { result in
            switch result {
            case .success(let covidCases):
                self.covidCases = covidCases
                self.consultaButton.isHidden = false
                
                // desconsidera a data atual por não ter dados
                guard let ontem = Date().getDateFor(days: -1) else { return }
                guard let umaSemanaAtras = ontem.getDateFor(days: -7) else { return }
                guard let duasSemanasAtras = ontem.getDateFor(days: -14) else { return }
                
                self.casosUltimaSemana = covidCases
                    .filter { $0.date >= umaSemanaAtras }
                    .sorted { $0.date > $1.date }
                self.casosPenultimaSemana = covidCases
                    .filter { $0.date >= duasSemanasAtras && $0.date <= umaSemanaAtras }
                    .sorted { $0.date > $1.date }
                self.dadosUltimaSemana.reloadData()
                self.dadosPenultimaSemana.reloadData()
                
                do {
                    self.mmUltimaSemana = try MediaMovel.mediaMovel(cases: self.casosUltimaSemana)
                    self.mmPenultimaSemana = try MediaMovel.mediaMovel(cases: self.casosPenultimaSemana)
                    self.percentualComparativo = self.mmPenultimaSemana * 100 / self.mmUltimaSemana
                    
                    self.setUpLabels()
                    
                    
                    
                } catch let err {
                    print(err)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setUpLabels(){
        setUpDatasUltimaSemana()
        setUpDatasPenultimaSemana()
        setUpMediaMovelUltimaSemana()
        setUpMediaMovelPenultimaSemana()
        setUpPercentualComparativoUltimaSemana()
        setUpPercentualComparativoPenultimaSemana()
    }
    
    private func setUpDatasUltimaSemana() {
        let ini = casosUltimaSemana[0].date.getDateFor(days: 1)!.toBrazilianFormat()
        let fim = casosUltimaSemana[casosUltimaSemana.count - 1].date.toBrazilianFormat()
        datasUltimaSemana.text = "Última semana (\(ini) - \(fim))"
    }
    
    private func setUpMediaMovelUltimaSemana() {
        mediaMovelUltimaSemana.text = "Média: \(Int(mmUltimaSemana.rounded()))"
    }
    
    private func setUpPercentualComparativoUltimaSemana(){
        var text = mmUltimaSemana > mmPenultimaSemana ? "+" : "-"
        text += " \(String(format: "%.2f", abs(100 - percentualComparativo)))% em relação à penúltima semana."
        percentualComparativoUltimaSemana.text = text
    }
    
    private func setUpDatasPenultimaSemana() {
        let ini = casosPenultimaSemana[0].date.getDateFor(days: 1)!.toBrazilianFormat()
        let fim = casosPenultimaSemana[casosPenultimaSemana.count - 1].date.toBrazilianFormat()
        datasPenultimaSemana.text = "Penúltima semana (\(ini) - \(fim))"
    }
    
    private func setUpMediaMovelPenultimaSemana() {
        mediaMovelPenultimaSemena.text = "Média: \(Int(mmPenultimaSemana.rounded()))"
    }
    
    private func setUpPercentualComparativoPenultimaSemana(){
        var text = mmPenultimaSemana > mmUltimaSemana ? "+" : "-"
        text += " \(String(format: "%.2f", abs(100 - percentualComparativo)))% em relação à última semana."
        percentualComparativoPenultimaSemana.text = text
    }
    
    @IBAction func onButtonTap() {
        let viewController : ConsultaViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ConsultaViewController"))! as! ConsultaViewController
        viewController.covidCases = covidCases
        self.present(viewController, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == dadosUltimaSemana) {
            return casosUltimaSemana.count - 1
        }
        else {
            return casosPenultimaSemana.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CovidCaseTableViewCell
        var casoAnterior: CovidCase
        var caso: CovidCase
        if (tableView == dadosUltimaSemana) {
            cell = dadosUltimaSemana.dequeueReusableCell(withIdentifier: "UltimaSemanaTableViewCell", for: indexPath) as! CovidCaseTableViewCell
            casoAnterior = casosUltimaSemana[indexPath.row + 1]
            caso = casosUltimaSemana[indexPath.row]
        }
        else {
            cell = dadosPenultimaSemana.dequeueReusableCell(withIdentifier: "PenultimaSemanaTableViewCell", for: indexPath) as! CovidCaseTableViewCell
            casoAnterior = casosPenultimaSemana[indexPath.row + 1]
            caso = casosPenultimaSemana[indexPath.row]
            
        }
        cell.setUpCell(caso: caso, casoAnterior: casoAnterior)
        return cell
    }
    
}
