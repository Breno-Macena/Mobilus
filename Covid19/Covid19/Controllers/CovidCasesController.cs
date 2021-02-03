using Covid19.Database;
using Covid19.Model;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Covid19.Controllers {
    [ApiController]
    [Route("[controller]")]
    public class CovidCasesController : ControllerBase
    {

        private readonly Webservice.Webservice _webservice;
        private IConsultaRespository consultaRespository;

        public CovidCasesController(Webservice.Webservice webservice, IConsultaRespository consultaRespository)
        {
            _webservice = webservice;
            this.consultaRespository = consultaRespository;
        }

        [HttpGet]
        public async Task<IEnumerable<CovidCase>> Get()
        {
            var cases =  await _webservice.GetLastSixMonthsBrazilCovidCases();
            return cases;
        }

        [HttpPost]
        public async Task Post(Consulta consulta)
        {
            await consultaRespository.InsertAsync(consulta);
        }
    }
}
