const std = @import("std");

/// The default formatter that prints the value with 2 decimal places (precision can be changed)
pub fn default(
    options: struct {
        comptime precision: ?u8 = 2,
    },
) *const fn (std.mem.Allocator, *std.ArrayList(u8), f32) anyerror!void {
    if (options.precision == null) {
        return &struct {
            pub fn lambda(allocator: std.mem.Allocator, buffer: *std.ArrayList(u8), value: f32) anyerror!void {
                try buffer.print(allocator, "{d}", .{value});
            }
        }.lambda;
    } else {
        const precision_str = std.fmt.comptimePrint("{}", .{options.precision.?});

        return &struct {
            pub fn lambda(allocator: std.mem.Allocator, buffer: *std.ArrayList(u8), value: f32) anyerror!void {
                try buffer.print(allocator, "{d:." ++ precision_str ++ "}", .{value});
            }
        }.lambda;
    }
}

/// The default formatter that prints the value with 2 decimal places (precision can be changed)
pub fn scientific(
    options: struct {
        comptime precision: ?u8 = 2,
    },
) *const fn (*std.ArrayList(u8), f32) anyerror!void {
    if (options.precision == null) {
        return &struct {
            pub fn lambda(buffer: *std.ArrayList(u8), value: f32) anyerror!void {
                try buffer.writer().print("{}", .{value});
            }
        }.lambda;
    } else {
        const precision_str = std.fmt.comptimePrint("{}", .{options.precision.?});

        return &struct {
            pub fn lambda(buffer: *std.ArrayList(u8), value: f32) anyerror!void {
                try buffer.writer().print("{:." ++ precision_str ++ "}", .{value});
            }
        }.lambda;
    }
}
