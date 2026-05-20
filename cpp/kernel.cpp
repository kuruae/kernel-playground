#include "types.hpp"

constexpr u16 VGA_WIDTH = 80;
constexpr u16 VGA_HEIGHT = 25;
volatile u16 *const VGA_BUFFER = reinterpret_cast<volatile u16 *>(0xB8000);

enum struct Color : u8 {
  black = 0,
  white = 15,
};

struct Point {
  u16 x;
  u16 y;
};

constexpr u8 vga_color(Color fg, Color bg) {
  return (static_cast<u8>(bg) << 4) | static_cast<u8>(fg);
}

constexpr u16 vga_entry(char ch, u8 color) {
  return static_cast<u16>(ch) | (static_cast<u16>(color) << 8);
}

void vga_putchar(char ch, Point cursor) {
  VGA_BUFFER[cursor.y * VGA_WIDTH + cursor.x] =
      vga_entry(ch, vga_color(Color::white, Color::black));
}

extern "C" void kmain(void) {
  static Point cursor = {40, 10};
  vga_putchar('X', cursor);
  while (1) {
  }
}
