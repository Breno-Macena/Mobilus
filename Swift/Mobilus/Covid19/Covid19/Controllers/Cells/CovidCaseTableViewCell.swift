

import UIKit

class CovidCaseTableViewCell: UITableViewCell {

    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var mortes: UILabel!
    @IBOutlet weak var mortesAcumuladas: UILabel!
    
    func setUpCell(caso: CovidCase, casoAnterior: CovidCase){
        data.text = caso.date.toBrazilianFormat()
        mortes.text = "\(caso.deaths - casoAnterior.deaths)"
        mortesAcumuladas.text = "\(caso.deaths)"
    }

}
