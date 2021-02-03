using Covid19.Model;
using Microsoft.EntityFrameworkCore;

namespace Covid19.Database {
    public class Covid19DbContext: DbContext
    {
        public DbSet<CovidCase> CovidCases { get; set; }
        public DbSet<Consulta> Consultas { get; set; }

        public Covid19DbContext(DbContextOptions options): base(options)
        {

        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Consulta>().HasKey(c => c.Id);
            modelBuilder.Entity<Consulta>().Property(c => c.Id).ValueGeneratedOnAdd();
        }

    }
}
