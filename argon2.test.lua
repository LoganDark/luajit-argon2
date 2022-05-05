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

local hash, err1 = argon2.hash(10000, 64, 1, 'hi', 'thisisasalt', 16, argon2.argon2id, argon2.VERSION_NUMBER)
if hash and ngx and ngx.encode_base64 then hash = ngx.encode_base64(hash) end

print(hash, err1)

local encoded, err2 = argon2.hash_encoded(10000, 64, 1, 'hi', 'thisisasalt', 16, argon2.argon2id, argon2.VERSION_NUMBER)
print(encoded, err2)

local ok, err3 = argon2.verify_encoded(encoded, 'hi', argon2.argon2id)
print(ok, err3)

print(argon2.error_to_message(argon2.VERIFY_MISMATCH))
