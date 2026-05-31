using Microsoft.EntityFrameworkCore;

namespace LakbayGameApi.Models
{
    public class LakbayGameDbContext : DbContext
    {

        public LakbayGameDbContext(DbContextOptions<LakbayGameDbContext> options) : base(options)
        {
        }

        public DbSet<Users> Users { get; set; }
    }
}
