local input_stream = require("input-stream")

local function test_input_stream_pass(self, istream, expected)
	local line = 1
	local column = 1
	local position = 0
	local charactersRead = {}
	self:is_equal(istream:line(), line)
	self:is_equal(istream:column(), column)
	self:is_equal(istream:position(), position)

	for char in expected:gmatch(".") do
		table.insert(charactersRead, istream:get())

		if char == "\n" then
			line = line + 1
			column = 1
		else
			column = column + 1
		end

		position = position + 1
	end

	self:is_equal(table.concat(charactersRead), expected)
	self:is_equal(istream:line(), line)
	self:is_equal(istream:column(), column)
	self:is_equal(istream:position(), position)
	self:is_equal(istream:peek(), nil)
	self:is_equal(istream:get(), nil)
	self:is_equal(istream:next(), nil)
	self:did_invoke_fail(istream.error, istream, "some error message")
	istream:close()
end

local function test_input_stream_pass_binary(self, istream, expected)
	local charactersRead = {}
	local position = 0
	self:is_equal(istream:line(), 0)
	self:is_equal(istream:column(), 0)
	self:is_equal(istream:position(), position)

	for _ in expected:gmatch(".") do
		table.insert(charactersRead, istream:get())
		position = position + 1
	end

	self:is_equal(table.concat(charactersRead), expected)
	self:is_equal(istream:line(), 0)
	self:is_equal(istream:column(), 0)
	self:is_equal(istream:position(), position)
	self:is_equal(istream:peek(), nil)
	self:is_equal(istream:get(), nil)
	self:is_equal(istream:next(), nil)
	self:did_invoke_fail(istream.error, istream, "some error message")
	istream:close()
end

--- Test suite executor. The return value of this function dictates how testing progresses:
---  - a return value of `"continue"` continues test suite execution,
---  - a return value of `"abort"` aborts testing if there is any failed tests,
---  - and a return value of `"todo"` ignores the results of this test suite.
--- @param self test_suite
--- @return string
return function(self)
	test_input_stream_pass(self, input_stream.fromFile("resources/input-stream/pass.txt"), "\n\t !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\n")
	test_input_stream_pass(self, input_stream.fromBuffer("\n\t !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\n"), "\n\t !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\n")
	test_input_stream_pass_binary(self, input_stream.fromFile("resources/input-stream/pass-binary.txt", true), "\n\t123456\n\t\n")
	test_input_stream_pass_binary(self, input_stream.fromBuffer("\n\t123456\n\t\n", true), "\n\t123456\n\t\n")
	self:did_invoke_fail(input_stream.fromFile, "bad_file")
	self:did_invoke_fail(input_stream.fromBuffer, 123)

	local istream = input_stream.fromFile("resources/input-stream/fail.txt")
	self:did_invoke_fail(istream.peek, istream)
	istream:close()

	return "abort"
end
