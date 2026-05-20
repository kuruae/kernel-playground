# Zig 
[source](../zig/src/main.zig)

Zig felt much closer to C than Rust for kernel, at least for simple low level work:
- direct memory manipulation
- explicit pointers
- simple ABI interop

but with a more modern (rust-like)syntax and compile-time checks

---

## integer / pointer conversions

Zig separates:
- integer values
- pointers
- enums

pretty strictly, So instead of implicit casts like C, we use explicit builtins:

```zig
@as(u16, value)
@ptrFromInt(0xB8000)
```

## pointer syntax / VGA buffer

Zig got several pointers and arrays types afaik:
```zig
[n]T // fixed sized array
[]T // slice (ptr + len)
[*]T // many items pointer so basically a ptr[] in c
*T // single item ptr
```

Volatile is similar to C/C++ and not like rust, so it works as a type qualifier.

combined with how conversions work, our vga buffer is simply described as this:
```zig
const VGA_BUFFER: volatile [*]u16 = @ptrFromInt(0xB8000);
```

## Misc
We can make some other observations such as 'noreturn' as a return type in our main function which is like it was in rust('!'), or the lack of a char type (just use u8), or anything const is guaranteed to be evaluated at compile time. 

---

basically Zig exposes low-level behavior very directly while still trying to make dangerous operations explicit so it can be nice for this kind of stuff.

The language also seems to have a lot of quirks regarding memory allocation, that will only serve once we get memory paging working in kernels, and it also uses a very unique build system
