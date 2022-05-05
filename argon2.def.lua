-- MIT License
--
-- luajit-argon2
-- Copyright (c) 2022 LoganDark
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

--[[
	Luanalysis typings for luajit-argon2 (relies on @module annotation)

	Usage:
		--- @type argon2
		local argon2 = require('argon2')

	This .def.lua file can be placed anywhere in your project, but it must be
	inside a source root so that the argon2 type will be picked up.
]]

--- @module argon2

--- The native argon2 library as loaded by `ffi.load`. Currently, only
--- `argon2_error_codes` (and its associated constants), `argon2_type`,
--- `argon2_version`, `argon2_type2string`, `argon2_hash`, `argon2_verify`,
--- `argon2_error_message`, and `argon2_encodedlen` are defined. You can use
--- `ffi.cdef` to define more if you need.
argon2 = --[[---@type any ]] nil

--- @shape argon2_error_codes

OK = --[[---@type argon2_error_codes ]] nil
OUTPUT_PTR_NULL = --[[---@type argon2_error_codes ]] nil
OUTPUT_TOO_SHORT = --[[---@type argon2_error_codes ]] nil
OUTPUT_TOO_LONG = --[[---@type argon2_error_codes ]] nil
PWD_TOO_SHORT = --[[---@type argon2_error_codes ]] nil
PWD_TOO_LONG = --[[---@type argon2_error_codes ]] nil
SALT_TOO_SHORT = --[[---@type argon2_error_codes ]] nil
SALT_TOO_LONG = --[[---@type argon2_error_codes ]] nil
AD_TOO_SHORT = --[[---@type argon2_error_codes ]] nil
AD_TOO_LONG = --[[---@type argon2_error_codes ]] nil
SECRET_TOO_SHORT = --[[---@type argon2_error_codes ]] nil
SECRET_TOO_LONG = --[[---@type argon2_error_codes ]] nil
TIME_TOO_SMALL = --[[---@type argon2_error_codes ]] nil
TIME_TOO_LARGE = --[[---@type argon2_error_codes ]] nil
MEMORY_TOO_LITTLE = --[[---@type argon2_error_codes ]] nil
MEMORY_TOO_MUCH = --[[---@type argon2_error_codes ]] nil
LANES_TOO_FEW = --[[---@type argon2_error_codes ]] nil
LANES_TOO_MANY = --[[---@type argon2_error_codes ]] nil
PWD_PTR_MISMATCH = --[[---@type argon2_error_codes ]] nil
SALT_PTR_MISMATCH = --[[---@type argon2_error_codes ]] nil
SECRET_PTR_MISMATCH = --[[---@type argon2_error_codes ]] nil
AD_PTR_MISMATCH = --[[---@type argon2_error_codes ]] nil
MEMORY_ALLOCATION_ERROR = --[[---@type argon2_error_codes ]] nil
FREE_MEMORY_CBK_NULL = --[[---@type argon2_error_codes ]] nil
ALLOCATE_MEMORY_CBK_NULL = --[[---@type argon2_error_codes ]] nil
INCORRECT_PARAMETER = --[[---@type argon2_error_codes ]] nil
INCORRECT_TYPE = --[[---@type argon2_error_codes ]] nil
OUT_PTR_MISMATCH = --[[---@type argon2_error_codes ]] nil
THREADS_TOO_FEW = --[[---@type argon2_error_codes ]] nil
THREADS_TOO_MANY = --[[---@type argon2_error_codes ]] nil
MISSING_ARGS = --[[---@type argon2_error_codes ]] nil
ENCODING_FAIL = --[[---@type argon2_error_codes ]] nil
DECODING_FAIL = --[[---@type argon2_error_codes ]] nil
THREAD_FAIL = --[[---@type argon2_error_codes ]] nil
DECODING_LENGTH_FAIL = --[[---@type argon2_error_codes ]] nil
VERIFY_MISMATCH = --[[---@type argon2_error_codes ]] nil

--- Returns a string for the given code. Returns the raw enum constant minus
--- `ARGON2_` - for example, `OK` or `OUTPUT_PTR_NULL`. For a human-readable
--- error message, use `error_message`.
---
--- @param code argon2_error_codes
--- @return string
function error_to_string(code) end

--- Returns an error message for the given code. Returns what
--- `argon2_error_message` returns for each error constant.
---
--- @param code argon2_error_codes
--- @return string
function error_message(code) end

--- @shape argon2_type

argon2d = --[[---@type argon2_type ]] nil
argon2i = --[[---@type argon2_type ]] nil
argon2id = --[[---@type argon2_type ]] nil

--- @shape argon2_version

--- Appears as `v=16` in encoded hashes.
VERSION_10 = --[[---@type argon2_version ]] nil

--- Appears as `v=19` in encoded hashes.
VERSION_13 = --[[---@type argon2_version ]] nil

--- The latest version, currently `VERSION_13`.
VERSION_NUMBER = --[[---@type argon2_version ]] nil

--- Returns a string for the given type. This is done by calling
--- `argon2_type2string`.
---
--- @param type argon2_type
--- @param uppercase boolean | nil
--- @return string
--- @overload fun(type: argon2_type): string
function type_to_string(type, uppercase) end

--- Hashes the given password with the provided salt and produces `hash_len`
--- bytes of output. If the hash fails, then `nil` and an error code will be
--- returned.
---
--- @param iterations number @The number of iterations to perform. A higher iteration count increases the time/computational cost of the algorithm. This should be tuned so that brute force becomes infeasible without hashing becoming so expensive that it brings down your application.
--- @param memory_kb number @The amount of memory (in kilobytes) to use for the algorithm.
--- @param parallelism number @The amount of parallelism (threads and compute lanes) to use for the algorithm. This changes the output.
--- @param password string @The password to hash. Embedded zeroes and binary data are allowed.
--- @param salt string @The salt to use. This must be at least 8 bytes and should be random.
--- @param hash_len number @The desired hash length in bytes. Longer hashes reduce the chance of collisions but require more storage.
--- @param type argon2_type @The argon2 algorithm to use. Argon2d is potentially vulnerable to side-channel attacks, argon2i is not. Argon2id combines both and should be used if you're unsure.
--- @param version argon2_version @The version of argon2 to use. Generally, you should use `VERSION_NUMBER` for the latest version only if you are using encoded hashes. Otherwise, to prevent silent breakages, choose a stable version to use for your hashes, or make sure to keep track of it separately.
--- @return string | (nil, argon2_error_codes) @The binary hash that was produced (not encoded as base64 or hex). This will always be exactly `hash_len` bytes long, or be `nil`, in which case the second return value is an error code.
function hash(iterations, memory_kb, parallelism, password, salt, hash_len, type, version) end

--- Returns the number of bytes that an encoded hash with the given parameters,
--- salt and hash length, and type would require. Does not include a null
--- terminator.
---
--- This is typically unnecessary, as Lua strings are variable-length, but there
--- may be scenarios in which you would need to know the size of an encoded hash
--- before actually performing the work. For example, `hash_encoded` uses this
--- function internally to allocate a perfectly-sized buffer.
---
--- In such cases, however, you would likely want to use the `argon2` C
--- functions directly.
---
--- @param iterations number
--- @param memory_kb number
--- @param parallelism number
--- @param salt_len number
--- @param hash_len number
--- @param type argon2_type
--- @return number
function encoded_len(iterations, memory_kb, parallelism, salt_len, hash_len, type) end

--- Hashes the given password with the given parameters and salt and produces an
--- *encoded hash* encapsulating `hash_len` bytes of output plus all the
--- parameters used for the hash. If the hash fails, then `nil` and an error
--- code will be returned.
---
--- The produced output is variable-length because it includes the parameters as
--- plain text.
---
--- Encoded hashes look like this:
--- ```
--- > argon2.hash_encoded(10000, 64, 1, 'hi', 'thisisasalt', 16, argon2.argon2id, argon2.VERSION_NUMBER)
--- $argon2id$v=19$m=64,t=10000,p=1$dGhpc2lzYXNhbHQ$TwT+k2qa1WWoQFc4ccF9yw
--- ```
---
--- Since encoded hashes include all information required to reproduce the hash
--- parameters, `verify_encoded` only needs the password (and type) to check if
--- the given password matches the encoded hash. Additionally, high-risk
--- accounts (i.e. administrators) can be given more expensive hashes (more
--- iterations, memory or parallelism) to make them even more difficult to
--- crack.
---
--- @param iterations number @The number of iterations to perform. A higher iteration count increases the time/computational cost of the algorithm. This should be tuned so that brute force becomes infeasible without hashing becoming so expensive that it brings down your application.
--- @param memory_kb number @The amount of memory (in kilobytes) to use for the algorithm.
--- @param parallelism number @The amount of parallelism (threads and compute lanes) to use for the algorithm. This changes the output.
--- @param password string @The password to hash. Embedded zeroes and binary data are allowed.
--- @param salt string @The salt to use. This must be at least 8 bytes and should be random.
--- @param hash_len number @The desired hash length in bytes. Longer hashes reduce the chance of collisions but require more storage.
--- @param type argon2_type @The argon2 type to use. Argon2d is potentially vulnerable to side-channel attacks, argon2i is not. Argon2id combines both and should be used if you're unsure.
--- @param version argon2_version @The version of argon2 to use. Generally, you should use `VERSION_NUMBER` for the latest version only if you are using encoded hashes. Otherwise, to prevent silent breakages, choose a stable version to use for your hashes, or make sure to keep track of it separately.
--- @return string | (nil, argon2_error_codes) @The binary hash that was produced (not encoded as base64 or hex). This will always be exactly `hash_len` bytes long, or be `nil`, in which case the second return value is an error code.
function hash_encoded(iterations, memory_kb, parallelism, password, salt, hash_len, type, version) end

--- Verifies the given password against an encoded hash of the specified type.
--- This function returns `true` if the password matches the hash, or `false`
--- and an error code otherwise.
---
--- Typically the error code will be `VERIFY_MISMATCH` if the password simply
--- does not match.
---
--- @param encoded string @The encoded hash to check against.
--- @param password string @The password to check against the hash.
--- @param type argon2_type @The argon2 type that was used to produce the encoded hash.
--- @return true | (false, argon2_error_codes)
function verify_encoded(encoded, password, type) end
