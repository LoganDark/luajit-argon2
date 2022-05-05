# luajit-argon2

LuaJIT bindings to the [20171227 version of Argon2](
https://github.com/P-H-C/phc-winner-argon2/blob/670229c849b9fe882583688b74eb7dfdc846f9f6/include/argon2.h),
also known as the [Ubuntu `argon2` package](
https://packages.ubuntu.com/source/focal/argon2) or `libargon2.so.1`.

## Features

- binary-safe (embedded nulls allowed) hashing with Argon2i, Argon2d, or
  Argon2id
- configuration of all "simple" parameters like iterations, memory usage,
  parallelism, and salt
- encoded hashes (includes parameters for easy verification later) as provided
  by Argon2
- verification against encoded hashes

## Compatibility

This module only works on **Linux**, with the library **`libargon2.so.1`**. If
you are using the Ubuntu `argon2` package, then you are good. If not, run this
command to verify if your system contains a compatible package (root not
required):

```
$ ldconfig -p | grep libargon2.so.1
```

If you get any output, then `argon2.lua` should be able to find and load Argon2.
For example, this means you have the right library installed:

```
libargon2.so.1 (libc6,x86-64) => /lib/x86_64-linux-gnu/libargon2.so.1
```

If you don't, then you will have to find a way to install the library on your
system. This varies by distro, so you will have to look it up online.

## Usage

Put the `argon2.lua` file somewhere in your package path (for example,
`/usr/local/openresty/lualib/argon2.lua` for OpenResty) and then simply
`require` it like so:

```lua
local argon2 = require('argon2')
```

To use the Luanalysis typings (`argon2.def.lua`), place the file somewhere in
your project, and then include a type annotation on the variable holding the
`argon2` module:

```lua
--- @type argon2
local argon2 = require('argon2')
```

## Constants

### `argon2_error_codes`

This module re-exports all of Argon2's error codes without the `ARGON2_` prefix.
Assuming the module is stored in a variable named `argon2`:

```
argon2.OK
argon2.OUTPUT_PTR_NULL
argon2.OUTPUT_TOO_SHORT
argon2.OUTPUT_TOO_LONG
argon2.PWD_TOO_SHORT
argon2.PWD_TOO_LONG
argon2.SALT_TOO_SHORT
argon2.SALT_TOO_LONG
argon2.AD_TOO_SHORT
argon2.AD_TOO_LONG
argon2.SECRET_TOO_SHORT
argon2.SECRET_TOO_LONG
argon2.TIME_TOO_SMALL
argon2.TIME_TOO_LARGE
argon2.MEMORY_TOO_LITTLE
argon2.MEMORY_TOO_MUCH
argon2.LANES_TOO_FEW
argon2.LANES_TOO_MANY
argon2.PWD_PTR_MISMATCH
argon2.SALT_PTR_MISMATCH
argon2.SECRET_PTR_MISMATCH
argon2.AD_PTR_MISMATCH
argon2.MEMORY_ALLOCATION_ERROR
argon2.FREE_MEMORY_CBK_NULL
argon2.ALLOCATE_MEMORY_CBK_NULL
argon2.INCORRECT_PARAMETER
argon2.INCORRECT_TYPE
argon2.OUT_PTR_MISMATCH
argon2.THREADS_TOO_FEW
argon2.THREADS_TOO_MANY
argon2.MISSING_ARGS
argon2.ENCODING_FAIL
argon2.DECODING_FAIL
argon2.THREAD_FAIL
argon2.DECODING_LENGTH_FAIL
argon2.VERIFY_MISMATCH
```

### `argon2_type`

This module re-exports all Argon2 types. Assuming the module is stored in a
variable named `argon2`:

```
argon2.argon2d
argon2.argon2i
argon2.argon2id
```

### `argon2_version`

This module re-exports all Argon2 versions. Assuming the module is stored in a
variable named `argon2`:

```
argon2.VERSION_10
argon2.VERSION_13
argon2.VERSION_NUMBER
```

## Functions

### `argon2.error_to_string`

*Syntax:* `str = argon2.error_to_string(code)`

Returns a string for the given code. Returns the raw enum constant minus
`ARGON2_` - for example, `OK` or `OUTPUT_PTR_NULL`. For a human-readable error
message, use `error_message`.

#### Parameters

1. `code`: `argon2_error_codes`

*Returns:* `string`

### `argon2.error_message`

*Syntax:* `str = argon2.error_message(code)`

Returns an error message for the given code. Returns what `argon2_error_message`
returns for each error constant.

#### Parameters

1. `code`: `argon2_error_codes`

*Returns:* `string`

### `argon2.type_to_string`

*Syntax:* `str = argon2.type_to_string(type, uppercase)`

Returns a string for the given type. This is done by calling
`argon2_type2string`.

#### Parameters

1. `type`: `argon2_type`
2. `uppercase`: `boolean | nil`

*Returns:* `string`

### `argon2.hash`

*Syntax:* `hash, err = argon2.hash(iterations, memory_kb, parallelism, password, salt, hash_len, type, version)`

Hashes the given password with the provided salt and produces `hash_len` bytes
of output. If the hash fails, then `nil` and an error code will be returned.

#### Parameters

1. `iterations`: `number`

   The number of iterations to perform. A higher iteration count increases the
   time/computational cost of the algorithm. This should be tuned so that brute
   force becomes infeasible without hashing becoming so expensive that it brings
   down your application.

2. `memory_kb`: `number`

   The amount of memory (in kilobytes) to use for the algorithm.

3. `parallelism`: `number`

   The amount of parallelism (threads and compute lanes) to use for the algorithm. This changes the output.

4. `password`: `string`

   The password to hash. Embedded zeroes and binary data are allowed.

5. `salt`: `string`

   The salt to use. This must be at least 8 bytes and should be random.

6. `hash_len`: `number`

   The desired hash length in bytes. Longer hashes reduce the chance of
   collisions but require more storage.

7. `type`: `argon2_type`

   The argon2 algorithm to use. Argon2d is potentially vulnerable to
   side-channel attacks, Argon2i is not. Argon2id combines both and should be
   used if you're unsure.

8. `version`: `argon2_version`

   The version of argon2 to use. Generally, you should use `VERSION_NUMBER` for
   the latest version only if you are using encoded hashes. Otherwise, to
   prevent silent breakages, choose a stable version to use for your hashes, or
   make sure to keep track of it separately.

*Returns:* `string` | `nil, argon2_error_codes`

### `argon2.encoded_len`

*Syntax:* `encoded_len = argon2.encoded_len(iterations, memory_kb, parallelism, salt_len, hash_len, type)`

Returns the number of bytes that an encoded hash with the given parameters, salt
and hash length, and type would require. Does not include a null terminator.

This is typically unnecessary, as Lua strings are variable-length, but there may
be scenarios in which you would need to know the size of an encoded hash before
actually performing the work. For example, `hash_encoded` uses this function
internally to allocate a perfectly-sized buffer.

In such cases, however, you would likely want to use the `argon2` C functions
directly.

#### Parameters

1. `iterations`: `number`
2. `memory_kb`: `number`
3. `parallelism`: `number`
4. `salt_len`: `number`
5. `hash_len`: `number`
6. `type`: `argon2_type`

*Returns:* `number`

### `argon2.hash_encoded`

*Syntax:* `encoded, err = argon2.hash_encoded(iterations, memory_kb, parallelism, password, salt, hash_len, type, version)`

Hashes the given password with the given parameters and salt and produces an
*encoded hash* encapsulating `hash_len` bytes of output plus all the parameters
used for the hash. If the hash fails, then `nil` and an error code will be
returned.

The produced output is variable-length because it includes the parameters as
plain text.

Encoded hashes look like this:

```
> argon2.hash_encoded(10000, 64, 1, 'hi', 'thisisasalt', 16, argon2.argon2id, argon2.VERSION_NUMBER)
$argon2id$v=19$m=64,t=10000,p=1$dGhpc2lzYXNhbHQ$TwT+k2qa1WWoQFc4ccF9yw
```

Since encoded hashes include all information required to reproduce the hash
parameters, `verify_encoded` only needs the password (and type) to check if the
given password matches the encoded hash. Additionally, high-risk accounts (i.e.
administrators) can be given more expensive hashes (more iterations, memory or
parallelism) to make them even more difficult to crack.

#### Parameters

The full descriptions of all parameters are under `argon2.hash`.

1. `iterations`: `number`
2. `memory_kb`: `number`
3. `parallelism`: `number`
4. `password`: `string`
5. `salt`: `string`
6. `hash_len`: `number`
7. `type`: `argon2_type`
8. `version`: `argon2_version`

*Returns:* `string` | `nil, argon2_error_codes`

### `argon2.verify_encoded`

*Syntax:* `matches, err = argon2.verify_encoded(encoded, password, type)`

Verifies the given password against an encoded hash of the specified type. This
function returns `true` if the password matches the hash, or `false` and an
error code otherwise.

Typically the error code will be `VERIFY_MISMATCH` if the password simply does
not match.

#### Parameters

1. `encoded`: `string`
2. `password`: `string`
3. `type`: `argon2_type`

*Returns:* `true` | `false, argon2_error_codes`

## License

MIT License

Copyright (c) 2022 LoganDark

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
