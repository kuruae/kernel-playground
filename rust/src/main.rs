#![no_std]
#![no_main]

const VGA_WIDTH: usize = 80;
const VGA_BUFER: *mut u16 = 0xB8000 as *mut u16;

#[derive(Clone, Copy)]
struct Point {
    x: usize,
    y: usize,
}

#[repr(u8)]
enum Color {
    Black = 0,
    White = 15,
}

use core::panic::PanicInfo;
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

fn vga_color(fg: Color, bg: Color) -> u8 {
    (bg as u8) << 4 | (fg as u8)
}

fn vga_entry(ch: u8, color: u8) -> u16 {
    ch as u16 | (color as u16) << 8
}

fn vga_putchar(ch: u8, cursor: Point) {
    let entry = vga_entry(ch, vga_color(Color::White, Color::Black));
    unsafe {
        VGA_BUFER
            .add(cursor.y * VGA_WIDTH + cursor.x)
            .write_volatile(entry);
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn kmain() -> ! {
    let cursor = Point { x: 40, y: 10 };
    vga_putchar(b'X', cursor);

    loop {}
}
