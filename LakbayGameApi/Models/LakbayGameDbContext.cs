using Microsoft.EntityFrameworkCore;

namespace LakbayGameApi.Models
{
    public class LakbayGameDbContext : DbContext
    {

        public LakbayGameDbContext(DbContextOptions<LakbayGameDbContext> options) : base(options)
        {
       }

        public DbSet<Users> Users { get; set; }
        public DbSet<Points> Points { get; set; }
        public DbSet<TotalPoints> TotalPoints { get; set; }
        public DbSet<DailyRewardRequest> DailyRewards { get; set; }
        public DbSet<LessonActivity> LessonActivities { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.ApplyConfigurationsFromAssembly(
                typeof(LakbayGameDbContext).Assembly
            );
        }
    }
}