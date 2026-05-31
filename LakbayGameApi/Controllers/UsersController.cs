using LakbayGameApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[Route("users")]
[ApiController]
public class UsersController : ControllerBase
{
    private readonly LakbayGameDbContext _context;
    public UsersController(LakbayGameDbContext context)
    {
        _context = context;
    }

    // GET: api/Users
    [HttpGet("getAllUsers")]
    public async Task<ActionResult<IEnumerable<Users>>> GetUsers()
    {
        return await _context.Users.ToListAsync();
    }

    // GET: api/Users/5
    [HttpGet("getUserById/{userid}")]
    public async Task<ActionResult<Users>> GetUsers(int userid)
    {
        var users = await _context.Users.FindAsync(userid);

        if (users == null)
        {
            return NotFound();
        }

        return users;
    }

    // PUT: api/Users/5
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPut("{userid}")]
    public async Task<IActionResult> PutUsers(int? userid, Users users)
    {
        if (userid != users.UserId)
        {
            return BadRequest();
        }

        _context.Entry(users).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!UsersExists(userid))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return NoContent();
    }

    // POST: api/Users
    // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
    [HttpPost("signUp")]
    public async Task<ActionResult<Users>> PostUsers(Users users)
    {
        _context.Users.Add(users);
        await _context.SaveChangesAsync();

        return CreatedAtAction("GetUsers", new { userid = users.UserId }, users);
    }

    // DELETE: api/Users/5
    [HttpDelete("{userid}")]
    public async Task<IActionResult> DeleteUsers(int? userid)
    {
        var users = await _context.Users.FindAsync(userid);
        if (users == null)
        {
            return NotFound();
        }

        _context.Users.Remove(users);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool UsersExists(int? userid)
    {
        return _context.Users.Any(e => e.UserId == userid);
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u =>
            (u.UserName == request.Login || u.Email == request.Login) &&
            u.Password == request.Password);

        if (user == null)
        {
            return Unauthorized(new
            {
                message = "Invalid username/email or password"
            });
        }

        return Ok(new
        {
            userId = user.UserId,
            userName = user.UserName,
            email = user.Email,
            gender = user.Gender
        });
    }
}