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

-- Only has to be performed once:
-- $ sudo ln -s /home/yourusername/luajit-argon2/argon2.lua /usr/local/openresty/lualib/argon2.lua
--
-- To run the test:
-- $ resty argon2.test.lua
--
-- Alternatively, it can be run with the vanilla LuaJIT interpreter:
-- $ luajit argon2.test.lua

local argon2 = require('argon2')

local function assert_eq(left, right)
	if left ~= right then
		error(string.format([[
assertion failed! (left == right)
  left:  %s
  right: %s]], tostring(left), tostring(right)), 2)
	end
end

assert_eq(argon2._NAME, 'argon2')
assert_eq(argon2._AUTHOR, 'LoganDark')
assert_eq(argon2._LICENSE, 'MIT')
assert_eq(argon2._VERSION, '1.0.0')

assert(argon2.argon2)

assert(argon2.argon2d)
assert(argon2.argon2i)
assert(argon2.argon2id)

assert_eq(argon2.error_to_string(argon2.OK), 'OK')
assert_eq(argon2.error_to_string(argon2.VERIFY_MISMATCH), 'VERIFY_MISMATCH')

assert_eq(argon2.error_message(argon2.OK), 'OK')
assert_eq(argon2.error_message(argon2.VERIFY_MISMATCH), 'The password does not match the supplied hash')

assert_eq(argon2.type_to_string(argon2.argon2id), 'argon2id')
assert_eq(argon2.type_to_string(argon2.argon2i, false), 'argon2i')
assert_eq(argon2.type_to_string(argon2.argon2d, true), 'Argon2d')

assert_eq(argon2.encoded_len(1, 16, 1, 8, 16, argon2.argon2id), 62)

local hash, err = argon2.hash(1, 16, 1, 'password', 'umbreons', 16, argon2.argon2id, argon2.VERSION_NUMBER)
assert(not err)
print((string.gsub(hash, '.', function(c) return string.format('%02X', string.byte(c)) end)))

local encoded, err = argon2.hash_encoded(1, 16, 1, 'password', 'umbreons', 16, argon2.argon2id, argon2.VERSION_NUMBER)
assert(not err)
print(encoded)

assert(argon2.verify_encoded(encoded, 'password', argon2.argon2id))
