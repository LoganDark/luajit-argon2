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

local ffi = require('ffi')
local ffi_typeof = ffi.typeof
local ffi_string = ffi.string
local ffi_buffer = ffi_typeof('uint8_t[?]')

ffi.cdef([[

typedef enum Argon2_ErrorCodes {
	ARGON2_OK = 0,
	ARGON2_OUTPUT_PTR_NULL = -1,
	ARGON2_OUTPUT_TOO_SHORT = -2,
	ARGON2_OUTPUT_TOO_LONG = -3,
	ARGON2_PWD_TOO_SHORT = -4,
	ARGON2_PWD_TOO_LONG = -5,
	ARGON2_SALT_TOO_SHORT = -6,
	ARGON2_SALT_TOO_LONG = -7,
	ARGON2_AD_TOO_SHORT = -8,
	ARGON2_AD_TOO_LONG = -9,
	ARGON2_SECRET_TOO_SHORT = -10,
	ARGON2_SECRET_TOO_LONG = -11,
	ARGON2_TIME_TOO_SMALL = -12,
	ARGON2_TIME_TOO_LARGE = -13,
	ARGON2_MEMORY_TOO_LITTLE = -14,
	ARGON2_MEMORY_TOO_MUCH = -15,
	ARGON2_LANES_TOO_FEW = -16,
	ARGON2_LANES_TOO_MANY = -17,
	ARGON2_PWD_PTR_MISMATCH = -18,
	ARGON2_SALT_PTR_MISMATCH = -19,
	ARGON2_SECRET_PTR_MISMATCH = -20,
	ARGON2_AD_PTR_MISMATCH = -21,
	ARGON2_MEMORY_ALLOCATION_ERROR = -22,
	ARGON2_FREE_MEMORY_CBK_NULL = -23,
	ARGON2_ALLOCATE_MEMORY_CBK_NULL = -24,
	ARGON2_INCORRECT_PARAMETER = -25,
	ARGON2_INCORRECT_TYPE = -26,
	ARGON2_OUT_PTR_MISMATCH = -27,
	ARGON2_THREADS_TOO_FEW = -28,
	ARGON2_THREADS_TOO_MANY = -29,
	ARGON2_MISSING_ARGS = -30,
	ARGON2_ENCODING_FAIL = -31,
	ARGON2_DECODING_FAIL = -32,
	ARGON2_THREAD_FAIL = -33,
	ARGON2_DECODING_LENGTH_FAIL = -34,
	ARGON2_VERIFY_MISMATCH = -35
} argon2_error_codes;

typedef enum Argon2_type {
	Argon2_d = 0,
	Argon2_i = 1,
	Argon2_id = 2
} argon2_type;

typedef enum Argon2_version {
	ARGON2_VERSION_10 = 0x10,
	ARGON2_VERSION_13 = 0x13,
	ARGON2_VERSION_NUMBER = ARGON2_VERSION_13
} argon2_version;

const char *argon2_type2string(argon2_type type, bool uppercase);

argon2_error_codes argon2_hash(
	uint32_t t_cost, uint32_t m_cost, uint32_t parallelism,
	const char *pwd, size_t pwdlen,
	const char *salt, size_t saltlen,
	char *hash, size_t hashlen,
	char *encoded, size_t encodedlen,
	argon2_type type, argon2_version version
);

argon2_error_codes argon2_verify(
	const char *encoded,
	const char *pwd, size_t pwdlen,
	argon2_type type
);

const char *argon2_error_message(argon2_error_codes error_code);

size_t argon2_encodedlen(
	uint32_t t_cost, uint32_t m_cost, uint32_t parallelism,
	uint32_t saltlen, uint32_t hashlen, argon2_type type
);

]])

local argon2 = ffi.load('libargon2.so.1')

local argon2_error_codes = ffi_typeof('argon2_error_codes')
local argon2_type = ffi_typeof('argon2_type')
local argon2_version = ffi_typeof('argon2_version')

local argon2_type2string = argon2.argon2_type2string
local argon2_hash = argon2.argon2_hash
local argon2_verify = argon2.argon2_verify
local argon2_error_message = argon2.argon2_error_message
local argon2_encodedlen = argon2.argon2_encodedlen

local ARGON2_OK = argon2.ARGON2_OK
local ARGON2_ENCODING_FAIL = argon2.ARGON2_ENCODING_FAIL

local module = {
	_NAME = 'argon2',
	_AUTHOR = 'LoganDark',
	_LICENSE = 'MIT',
	_DESCRIPTION = 'LuaJIT bindings to the 20171227 version of Argon2, also known as the Ubuntu `argon2` package or `libargon2.so.1`.',
	_VERSION = '1.0.0',

	argon2 = argon2,

	OK = argon2_error_codes(argon2.ARGON2_OK),
	OUTPUT_PTR_NULL = argon2_error_codes(argon2.ARGON2_OUTPUT_PTR_NULL),
	OUTPUT_TOO_SHORT = argon2_error_codes(argon2.ARGON2_OUTPUT_TOO_SHORT),
	OUTPUT_TOO_LONG = argon2_error_codes(argon2.ARGON2_OUTPUT_TOO_LONG),
	PWD_TOO_SHORT = argon2_error_codes(argon2.ARGON2_PWD_TOO_SHORT),
	PWD_TOO_LONG = argon2_error_codes(argon2.ARGON2_PWD_TOO_LONG),
	SALT_TOO_SHORT = argon2_error_codes(argon2.ARGON2_SALT_TOO_SHORT),
	SALT_TOO_LONG = argon2_error_codes(argon2.ARGON2_SALT_TOO_LONG),
	AD_TOO_SHORT = argon2_error_codes(argon2.ARGON2_AD_TOO_SHORT),
	AD_TOO_LONG = argon2_error_codes(argon2.ARGON2_AD_TOO_LONG),
	SECRET_TOO_SHORT = argon2_error_codes(argon2.ARGON2_SECRET_TOO_SHORT),
	SECRET_TOO_LONG = argon2_error_codes(argon2.ARGON2_SECRET_TOO_LONG),
	TIME_TOO_SMALL = argon2_error_codes(argon2.ARGON2_TIME_TOO_SMALL),
	TIME_TOO_LARGE = argon2_error_codes(argon2.ARGON2_TIME_TOO_LARGE),
	MEMORY_TOO_LITTLE = argon2_error_codes(argon2.ARGON2_MEMORY_TOO_LITTLE),
	MEMORY_TOO_MUCH = argon2_error_codes(argon2.ARGON2_MEMORY_TOO_MUCH),
	LANES_TOO_FEW = argon2_error_codes(argon2.ARGON2_LANES_TOO_FEW),
	LANES_TOO_MANY = argon2_error_codes(argon2.ARGON2_LANES_TOO_MANY),
	PWD_PTR_MISMATCH = argon2_error_codes(argon2.ARGON2_PWD_PTR_MISMATCH),
	SALT_PTR_MISMATCH = argon2_error_codes(argon2.ARGON2_SALT_PTR_MISMATCH),
	SECRET_PTR_MISMATCH = argon2_error_codes(argon2.ARGON2_SECRET_PTR_MISMATCH),
	AD_PTR_MISMATCH = argon2_error_codes(argon2.ARGON2_AD_PTR_MISMATCH),
	MEMORY_ALLOCATION_ERROR = argon2_error_codes(argon2.ARGON2_MEMORY_ALLOCATION_ERROR),
	FREE_MEMORY_CBK_NULL = argon2_error_codes(argon2.ARGON2_FREE_MEMORY_CBK_NULL),
	ALLOCATE_MEMORY_CBK_NULL = argon2_error_codes(argon2.ARGON2_ALLOCATE_MEMORY_CBK_NULL),
	INCORRECT_PARAMETER = argon2_error_codes(argon2.ARGON2_INCORRECT_PARAMETER),
	INCORRECT_TYPE = argon2_error_codes(argon2.ARGON2_INCORRECT_TYPE),
	OUT_PTR_MISMATCH = argon2_error_codes(argon2.ARGON2_OUT_PTR_MISMATCH),
	THREADS_TOO_FEW = argon2_error_codes(argon2.ARGON2_THREADS_TOO_FEW),
	THREADS_TOO_MANY = argon2_error_codes(argon2.ARGON2_THREADS_TOO_MANY),
	MISSING_ARGS = argon2_error_codes(argon2.ARGON2_MISSING_ARGS),
	ENCODING_FAIL = argon2_error_codes(argon2.ARGON2_ENCODING_FAIL),
	DECODING_FAIL = argon2_error_codes(argon2.ARGON2_DECODING_FAIL),
	THREAD_FAIL = argon2_error_codes(argon2.ARGON2_THREAD_FAIL),
	DECODING_LENGTH_FAIL = argon2_error_codes(argon2.ARGON2_DECODING_LENGTH_FAIL),
	VERIFY_MISMATCH = argon2_error_codes(argon2.ARGON2_VERIFY_MISMATCH),

	argon2d = argon2_type(argon2.Argon2_d),
	argon2i = argon2_type(argon2.Argon2_i),
	argon2id = argon2_type(argon2.Argon2_id),

	VERSION_10 = argon2_version(argon2.ARGON2_VERSION_10),
	VERSION_13 = argon2_version(argon2.ARGON2_VERSION_13),
	VERSION_NUMBER = argon2_version(argon2.ARGON2_VERSION_NUMBER)
}

local error_strings = {
	'OK', 'OUTPUT_PTR_NULL', 'OUTPUT_TOO_SHORT', 'OUTPUT_TOO_LONG',
	'PWD_TOO_SHORT', 'PWD_TOO_LONG', 'SALT_TOO_SHORT', 'SALT_TOO_LONG',
	'AD_TOO_SHORT', 'AD_TOO_LONG', 'SECRET_TOO_SHORT', 'SECRET_TOO_LONG',
	'TIME_TOO_SMALL', 'TIME_TOO_LARGE', 'MEMORY_TOO_LITTLE', 'MEMORY_TOO_MUCH',
	'LANES_TOO_FEW', 'LANES_TOO_MANY', 'PWD_PTR_MISMATCH', 'SALT_PTR_MISMATCH',
	'SECRET_PTR_MISMATCH', 'AD_PTR_MISMATCH', 'MEMORY_ALLOCATION_ERROR',
	'FREE_MEMORY_CBK_NULL', 'ALLOCATE_MEMORY_CBK_NULL', 'INCORRECT_PARAMETER',
	'INCORRECT_TYPE', 'OUT_PTR_MISMATCH', 'THREADS_TOO_FEW', 'THREADS_TOO_MANY',
	'MISSING_ARGS', 'ENCODING_FAIL', 'DECODING_FAIL', 'THREAD_FAIL',
	'DECODING_LENGTH_FAIL', 'VERIFY_MISMATCH'
}

function module.error_to_string(code)
	return error_strings[1 + -code]
end

function module.error_message(code)
	return ffi_string(argon2_error_message(code))
end

function module.type_to_string(type, uppercase)
	return ffi_string(argon2_type2string(type, uppercase and 1 or 0))
end

function module.encoded_len(
	iterations, memory_kb, parallelism,
	salt_len, hash_len, type
)
	return argon2_encodedlen(
		iterations, memory_kb, parallelism,
		salt_len, hash_len, type
	) - 1
end

-- internal hash function that module.hash and module.hash_encoded both use
local function hash(
	iterations, memory_kb, parallelism,
	password, salt, hash, hash_len, encoded,
	type, version
)
	assert(hash or encoded)

	local hash_buf
	local encoded_buf, encoded_len

	if hash then hash_buf = ffi_buffer(hash_len) end

	if encoded then
		encoded_len = argon2_encodedlen(
			iterations, memory_kb, parallelism,
			#salt, hash_len, type
		)

		encoded_buf = ffi_buffer(encoded_len)
	end

	local code = argon2_hash(
		iterations, memory_kb, parallelism,
		password, #password,
		salt, #salt,
		hash_buf, hash_len,
		encoded_buf, encoded_len or 0,
		type, version
	)

	if code == ARGON2_OK then
		if hash_buf and encoded_buf then
			return ffi_string(hash_buf, hash_len), ffi_string(encoded_buf, encoded_len - 1)
		elseif hash_buf then
			return ffi_string(hash_buf, hash_len)
		elseif encoded_buf then
			return ffi_string(encoded_buf, encoded_len - 1)
		end
	elseif code == ARGON2_ENCODING_FAIL and hash_buf then
		return nil, code, ffi_string(hash_buf, hash_len)
	else
		return nil, code
	end
end

function module.hash(
	iterations, memory_kb, parallelism,
	password, salt, hash_len,
	type, version
)
	return hash(
		iterations, memory_kb, parallelism,
		password, salt, true, hash_len, false,
		type, version
	)
end

function module.hash_encoded(
	iterations, memory_kb, parallelism,
	password, salt, hash_len,
	type, version
)
	return hash(
		iterations, memory_kb, parallelism,
		password, salt, false, hash_len, true,
		type, version
	)
end

function module.verify_encoded(encoded, password, type)
	local code = argon2_verify(encoded, password, #password, type)

	if code == ARGON2_OK then
		return true
	else
		return false, code
	end
end

return module
