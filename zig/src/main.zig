const VGA_HEIGHT: usize = 80;
const VGA_WIDTH: usize = 80;
const VGA_BUFFER: [*]volatile u16 = @ptrFromInt(0xB8000);

const Color = enum(u8) {
    black = 0,
    white = 15,
};

const Point = struct {
    x: usize,
    y: usize,
};

fn vga_color(fg: Color, bg: Color) u8 {
    return @intFromEnum(fg) | (@intFromEnum(bg) << 4);
}

fn vga_entry(ch: u8, color: u8) u16 {
    return @as(u16, ch) | (@as(u16, color) << 8);
}

fn vga_putchar(ch: u8, cursor: Point) void {
    VGA_BUFFER[cursor.y * VGA_WIDTH + cursor.x] = vga_entry(ch, vga_color(.white, .black));
}

export fn kmain() noreturn {
    const cursor = Point{ .x = 40, .y = 10 };
    vga_putchar('Y', cursor);

    while (true) {}
}
