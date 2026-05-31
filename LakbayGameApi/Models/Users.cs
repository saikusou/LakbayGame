using System.ComponentModel.DataAnnotations;

namespace LakbayGameApi.Models
{
    public class Users
    {

        [Key]

        public int UserId { get; set; }
        public required string UserName { get; set; }
        public required string Email { get; set; }
        public required string Gender { get; set; }
        public required string Password { get; set; }

    }
}
