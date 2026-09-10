// vault-stats.cs — read-only stats for an Obsidian vault. Requires .NET 10+.
// Usage: dotnet run vault-stats.cs -- "/path/to/vault"
// It never writes; it only reads *.md files and prints a summary.
//:package
using System.Text.RegularExpressions;

if (args.Length == 0)
{
    Console.WriteLine("usage: dotnet run vault-stats.cs -- \"/path/to/vault\"");
    return 1;
}

var root = new DirectoryInfo(args[0]);
if (!root.Exists)
{
    Console.WriteLine($"not found: {root.FullName}");
    return 1;
}

var notes = root.GetFiles("*.md", SearchOption.AllDirectories)
    .Where(f => !f.FullName.Contains($"{Path.DirectorySeparatorChar}.git{Path.DirectorySeparatorChar}")
             && !f.FullName.Contains($"{Path.DirectorySeparatorChar}.obsidian{Path.DirectorySeparatorChar}"))
    .ToList();

var tagCounts = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
long words = 0;
int missingH1 = 0;

foreach (var note in notes)
{
    string text;
    try { text = File.ReadAllText(note.FullName); }
    catch { continue; } // unreadable file: skip, keep going

    words += Regex.Matches(text, @"\S+").Count;
    if (!Regex.IsMatch(text, @"^#\s+\S", RegexOptions.Multiline)) missingH1++;

    foreach (Match m in Regex.Matches(text, @"(?<=^|\s)#([\p{L}\p{N}_/-]+)"))
        tagCounts[m.Groups[1].Value] = tagCounts.TryGetValue(m.Groups[1].Value, out int n) ? n + 1 : 1;
}

Console.WriteLine($"vault : {root.FullName}");
Console.WriteLine($"notes : {notes.Count}");
Console.WriteLine($"words : {words}");
Console.WriteLine($"no h1 : {missingH1}");
Console.WriteLine("top tags:");
foreach (var (tag, count) in tagCounts.OrderByDescending(kv => kv.Value).Take(10))
    Console.WriteLine($"  #{tag} x{count}");

return 0;
