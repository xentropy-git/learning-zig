const std = @import("std");
const test_allocator = std.testing.allocator;

pub fn main() !void {
    try load_input();
}

pub fn load_input() !void {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var sum: u64 = 0;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var digits = try extract_digits(line);
        sum = sum + digits;
    }
    std.debug.print("{d}\n", .{sum});
}

pub fn extract_digits(line: []u8) !u8 {
    var start: u8 = 0;
    var end: u8 = 0;
    var digits: u8 = 0;

    for (line) |char| {
        if (char >= 48 and char <= 57) {
            // character is a digit
            var digit = char - 48;
            if (start == 0) {
                start = digit;
                digits = 1;
            } else {
                end = digit;
                digits = 2;
            }
        }
    }
    if (digits == 0) return 0;
    // example shows that the result is always a 2 digit number, even if it only has one number.
    if (digits == 1) end = start;
    // must be a 2 digit number line
    var two_digit = start * 10 + end;
    return two_digit;
}
