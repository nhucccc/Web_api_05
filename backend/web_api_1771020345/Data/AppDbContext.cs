using Microsoft.EntityFrameworkCore;
using web_api_1771020345.Models;

namespace web_api_1771020345.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options) { }

        public DbSet<Customer> Customers { get; set; }
        public DbSet<Table> Tables { get; set; }
        public DbSet<MenuItem> MenuItems { get; set; }
        public DbSet<Reservation> Reservations { get; set; }
        public DbSet<ReservationItem> ReservationItems { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // ===== CUSTOMER =====
            modelBuilder.Entity<Customer>()
                .HasIndex(x => x.Email)
                .IsUnique();

            // ===== TABLE =====
            modelBuilder.Entity<Table>()
                .HasIndex(x => x.TableNumber)
                .IsUnique();

            // ===== RESERVATION =====
            modelBuilder.Entity<Reservation>()
                .HasIndex(x => x.ReservationNumber)
                .IsUnique();

            modelBuilder.Entity<Reservation>(entity =>
            {
                entity.Property(x => x.Subtotal).HasPrecision(18, 2);
                entity.Property(x => x.ServiceCharge).HasPrecision(18, 2);
                entity.Property(x => x.Discount).HasPrecision(18, 2);
                entity.Property(x => x.Total).HasPrecision(18, 2);

                // OPTIONAL nhưng đẹp bài
                entity.Property(x => x.CreatedAt)
                      .HasDefaultValueSql("GETUTCDATE()");
            });

            // ===== MENU ITEM =====
            modelBuilder.Entity<MenuItem>(entity =>
            {
                entity.Property(x => x.Price).HasPrecision(18, 2);
                entity.Property(x => x.Rating).HasPrecision(3, 2);
            });

            // ===== RESERVATION ITEM =====
            modelBuilder.Entity<ReservationItem>(entity =>
            {
                entity.Property(x => x.Price).HasPrecision(18, 2);
            });

            modelBuilder.Entity<ReservationItem>()
                .HasOne(x => x.Reservation)
                .WithMany(x => x.ReservationItems)
                .HasForeignKey(x => x.ReservationId)
                .OnDelete(DeleteBehavior.Cascade);

            // ===== 🔥 QUAN HỆ RESERVATION ↔ TABLE (PHẦN MÀY HỎI) =====
            modelBuilder.Entity<Reservation>()
                .HasOne<Table>()
                .WithMany()
                .HasForeignKey(r => r.TableNumber)
                .HasPrincipalKey(t => t.TableNumber)
                .OnDelete(DeleteBehavior.Restrict);
        }
    }
}
