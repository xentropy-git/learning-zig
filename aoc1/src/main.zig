const std = @import("std");
const utils = @import("utils.zig");

// returns the elf with the highest calorie count
pub fn countCalories() !u64 {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    std.debug.print("Finding the top 3 elves.", .{});

    var top_elves = [3]u64{ 0, 0, 0 };

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    const maxLineLength = 512;

    var buf: [maxLineLength]u8 = undefined;

    var elfCalorieSum: u64 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const sanitized_line = std.mem.trim(u8, line, "\r\n");
        // reset condition
        if (sanitized_line.len == 0) {
            utils.accumulateMax(&top_elves, elfCalorieSum);
            elfCalorieSum = 0;
            continue;
        }
        // trim the space at the end of the line

        const calories = try std.fmt.parseInt(u64, sanitized_line, 10);
        elfCalorieSum += calories;
    }
    elfCalorieSum = 0;
    for (top_elves) |top_elf| {
        std.debug.print("Top elf: {d}\n", .{top_elf});
        elfCalorieSum += top_elf;
    }

    return elfCalorieSum;
}

pub fn main() !void {
    var calories = try countCalories();

    const out = std.io.getStdOut().writer();

    try out.print("Top 3 elves sum to {d}", .{calories});
}
