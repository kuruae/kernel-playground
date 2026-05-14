#include "types.hpp"

constexpr auto VGA_WIDTH = 80;
constexpr auto VGA_HEIGHT = 25;
volatile u16 *const VGA_BUFFER = reinterpret_cast<volatile u16 *>(0xB8000);

constexpr u8 vga_color(u8 fg, u8 bg) { return ((bg << 4) | fg); }

constexpr u16 vga_entry(char ch, u8 color) {
  return static_cast<u16>(ch) | (static_cast<u16>(color) << 8);
}

void vga_putchar(char ch, coord cursor) {
  VGA_BUFFER[cursor.y * VGA_WIDTH + cursor.x] = vga_entry(ch, vga_color(15, 0));
}

extern "C" void _start(void) {
  static coord cursor = {40, 10};
  vga_putchar('X', cursor);
  while (1) {
  }
}
