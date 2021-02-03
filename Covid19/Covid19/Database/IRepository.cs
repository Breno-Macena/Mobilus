using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace Covid19.Database
{
    public interface IRepository<TEntity> where TEntity : class
    {
        Task<List<TEntity>> FindAsync(Expression<Func<TEntity, bool>> filter = null);
        Task InsertAsync(params TEntity[] obj);
    }
}
