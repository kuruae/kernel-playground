# Zig 

Zig felt much closer to C than Rust for kernel, at least for simple low level work:
- direct memory manipulation
- explicit pointers
- simple ABI interop

but with a more modern syntax and compile-time checks

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

---

basically Zig exposes low-level behavior very directly while still trying to make dangerous operations explicit so it can be nice for this kind of stuff
