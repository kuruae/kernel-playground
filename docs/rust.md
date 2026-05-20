# rust
[source](../rust/src/main.rs)

This one is going to be a bit more documented as i am learning the language itself

## no std, no main
unlike cpp we declare those straight into the code, and not in a build command or something:
```rust
// at the top of the kernel.rs file
#![no_std]
#![no_main]
```

## unwinding
For several reasons we don't want it, at least for now.
so instead of unwinding on panic let's abort, it's less hassle for us and gives smaller binaries too
so in cargo.toml:
```toml
[profile.dev]
panic = "abort"

[profile.release]
panic = "abort"
```

## unmangling and C interop
now we must prevent mangling for our entry function, otherwise instead of being named something like ``_start`` it will be named ``_asdDFhjKeybaOrdmaSH6767``, and the boostraper won't find it
We also need to make it readable by the C ABI:

```rust
#[unsafe(no_mangle)]
pub extern "C" fn _start() -> ! {
    loop{}
}
```

the last trick was the return value: ``-> !``
that's a divergin function, basically the return type is "never" and it shouldn't return

## Raw pointers in rust
that was my first mystery, but turns out it's not that bad basically
Rust has two types of pointer:
- ``*const T`` for reading
- ``*mut T`` for read-write

so our vga buffer looks like this:
```rust
const VGA_BUFFER: *mut u16 = 0x0b8000 as *mut u16;
```

since they are a weirder/unique type, they don't really make use of Rust's trait system from what i could find, and instead they get compiler-defined inherent methods, and that's how we can do pointer arithmetic:
``ptr.add(n)`` advances the pointer by ``n * size_of::<T>()`` bytes, so it's exactly like C's ``ptr + n``.

also we can notice that the pointer was not marked as volatile despite manipulating volatime memory, that's because in rust it's the operations that are volatile
So ``ptr.write_volatile(val)`` will prevent the write from being reordered or being optimized by the compiler

use of ``unsafe {}``:
Dereferencing a raw pointer in rust is inherently unsafe because the compiler cannot prove if the address is valid or aligned, so we need to wrap it inside unsafe blocks everytime.

## Casts, enums, traits
for enums, ``#[repr(u8)]`` is used to indicate we consistently want the members to be a ``u8``, so it's easy to cast an enum to an integer

In rust, a byte is not really the same thing as a unicode character, so we express bye literals wiht ``b'C'``, so we get its ascii value

``#[derive(Clone, Copy)]``:
this is to indicate the type can be copied just by copyings bits so we don't move/transfer ownership, like a pass by value

``as type``:
this one is just the way to cast primitives in rust
