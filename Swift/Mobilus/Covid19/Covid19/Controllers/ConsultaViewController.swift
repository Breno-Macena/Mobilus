

import UIKit
import CoreLocation

class ConsultaViewController: UIViewController, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    var covidCases: [CovidCase] = []
    
    @IBOutlet weak var mortes: UILabel!
    @IBOutlet weak var dataConsulta: UILabel!
    @IBOutlet weak var location: UILabel!
    
    private var maxMortes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        dataConsulta.text = Date().toBrazilianFormat()
        
        covidCases = covidCases.sorted { $0.date > $1.date }
        
        let casos = getCasosUltimoMes()
        let mortesPorDia = getMortesPorDia(casos: casos)
        maxMortes = mortesPorDia.values.max()!
        mortes.text = "\(mortesPorDia.values.max()!)"
    }
    
    private func setUpLocationManager(){
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            self.location.text = "lat: \(loc.coordinate.latitude), long: \(loc.coordinate.longitude)"
            
            let consulta = Consulta()
            consulta.maxMortes = self.maxMortes
            consulta.dataConsulta = Date().toString()
            consulta.latitude = loc.coordinate.latitude
            consulta.longitude = loc.coordinate.longitude
            
            Webservice().sendConsultas(consulta: consulta)
        }
    }
    
    private func getCasosUltimoMes() -> [CovidCase]{
        // desconsidera a data atual por não ter dados
        guard let ontem = Date().getDateFor(days: -1) else { return [] }
        guard let ultimoMes = ontem.getDateFor(days: -32) else { return [] }
        return covidCases.filter { $0.date >= ultimoMes }
    }
    
    private func getMortesPorDia(casos: [CovidCase]) -> Dictionary<Date, Int> {
        var result: Dictionary<Date, Int> = [:]
        var count = 0
        for caso in casos {
            if(count == casos.count - 2) {
                break
            }
            let casoAnterior = casos[count+1]
            let mortes = caso.deaths - casoAnterior.deaths
            result[caso.date] = mortes
            count += 1
        }
        return result
    }

}
