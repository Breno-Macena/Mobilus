using Covid19.Model;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace Covid19.Database
{
    public class CaseCovidRepository : ICaseCovidRepository
    {
        private readonly Covid19DbContext _context;
        public CaseCovidRepository(Covid19DbContext context)
        {
            _context = context;
        }

        public async Task<List<CovidCase>> FindAsync(Expression<Func<CovidCase, bool>> filter = null)
        {
            if (filter == null)
                return await _context.CovidCases.ToListAsync();
            return await _context.CovidCases.Where(filter).ToListAsync();
        }

        public async Task InsertAsync(params CovidCase[] obj)
        {
            await _context.CovidCases.AddRangeAsync(obj);
            await _context.SaveChangesAsync();
        }
    }
}
