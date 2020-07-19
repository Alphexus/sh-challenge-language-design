local position = require("compiler.position")

--- Test suite executor. The return value of this function dictates how testing progresses:
---  - a return value of `"continue"` continues test suite execution,
---  - a return value of `"abort"` aborts testing if there is any failed tests,
---  - and a return value of `"todo"` ignores the results of this test suite.
--- @param self test_suite
--- @return string
return function(self)
	local posid = position.identity()

	self:is_equal(posid, {
		first_line = 1,
		last_line = 1,
		first_column = 1,
		last_column = 1,
		first_position = 0,
		last_position = 0
	})

	local pos = position.fromLexeme("123", 5, 10, 20)

	self:is_equal(pos, {
		first_line = 5,
		last_line = 5,
		first_column = 10,
		last_column = 13,
		first_position = 20,
		last_position = 23
	})

	pos = position.fromLexeme("   123\n456   ", 1, 1, 0)

	self:is_equal(pos, {
		first_line = 1,
		last_line = 2,
		first_column = 1,
		last_column = 6,
		first_position = 0,
		last_position = 13
	})

	self:did_invoke_fail(position.fromLexeme, "", 1, 1, 0)
	self:did_invoke_fail(position.fromLexeme, "\n", 1, 1, 0)
	self:did_invoke_fail(position.fromLexeme, "\nasd", 1, 1, 0)

	return "continue"
end
