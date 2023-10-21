const std = @import("std");

// returns the elf with the highest calorie count
pub fn countCalories() !u64 {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    std.debug.print("Finding which elf has the most calories.", .{});

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    const maxLineLength = 512;

    var buf: [maxLineLength]u8 = undefined;

    var elfCalorieSum: u64 = 0;
    var highestCalorieSum: u64 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const sanitized_line = std.mem.trim(u8, line, "\r\n");
        // reset condition
        if (sanitized_line.len == 0) {
            highestCalorieSum = @max(elfCalorieSum, highestCalorieSum);
            elfCalorieSum = 0;
            continue;
        }
        // trim the space at the end of the line

        std.debug.print("[{s}]\n", .{sanitized_line});
        const calories = try std.fmt.parseInt(u64, sanitized_line, 10);
        elfCalorieSum += calories;
    }

    highestCalorieSum = @max(elfCalorieSum, highestCalorieSum);
    return highestCalorieSum;
}

pub fn main() !void {
    var calories = try countCalories();

    const out = std.io.getStdOut().writer();

    try out.print("The elf with the highest calorie count is carrying {d}", .{calories});
}
