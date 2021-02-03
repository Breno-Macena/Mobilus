using Covid19.Model;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;

namespace Covid19.Webservice
{
    public class Webservice
    {
        private readonly HttpClient _httpClient;

        public Webservice(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<IEnumerable<CovidCase>> GetLastSixMonthsBrazilCovidCases()
        {
            DateTime dateTime = DateTime.Now.AddMonths(-6).Date;
            var httpResponse = await _httpClient.GetAsync($"brazil?from={dateTime:yyyy-MM-dd}&to={DateTime.Now.Date:yyyy-MM-dd}");
            httpResponse.EnsureSuccessStatusCode();
            return await httpResponse.Content.ReadAsAsync<IEnumerable<CovidCase>>();
        }
    }
}
