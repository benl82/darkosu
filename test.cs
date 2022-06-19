using System;
using System.Diagnostics;
class Test {
    private static void run_cmd(string cmd, string args)
    {
        // cmd the path to python.exe, args the path to .py file + any extra cmd line args sep by spaces
        ProcessStartInfo start = new ProcessStartInfo();
        start.FileName = cmd;
        start.Arguments = args;
        start.UseShellExecute = false;
        start.RedirectStandardOutput = true;
        using(Process process = Process.Start(start))
        {
            using(StreamReader reader = process.StandardOutput)
            {
                string result = reader.ReadToEnd();
                Console.Write(result);
            }
        }
    }
    public static void Main() {
        run_cmd("C:\\Users\\xoxze\\AppData\\Local\\Programs\\Python\\Python310\\python.exe", "C:\\Users\\xoxze\\Documents\\darkosu\\test.py");
        Console.WriteLine("hi from c#");
    }
}

Test.Main();