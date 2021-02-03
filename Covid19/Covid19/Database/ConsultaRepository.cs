using Covid19.Model;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace Covid19.Database
{
    public class ConsultaRepository : IConsultaRespository
    {

        private readonly Covid19DbContext _context;

        public ConsultaRepository(Covid19DbContext context)
        {
            _context = context;
        }

        public async Task<List<Consulta>> FindAsync(Expression<Func<Consulta, bool>> filter = null)
        {
            if (filter == null)
                return await _context.Consultas.ToListAsync();
            return await _context.Consultas.Where(filter).ToListAsync();
        }

        public async Task InsertAsync(params Consulta[] obj)
        {
            await _context.Consultas.AddRangeAsync(obj);
            await _context.SaveChangesAsync();
        }
    }
}
