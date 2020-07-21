local region = require("compiler.region")
local identifier = require("compiler.ast.identifier")
local number_literal = require("compiler.ast.number-literal")
local binary_expression = require("compiler.ast.binary-expression")
local variable_definition = require("compiler.ast.variable-definition")

--- @param self test_suite
return function(self)
	-- let x = 10 + y
	local node = variable_definition.new(
		--     x = 10 + y
		identifier.new("x", region.from_lexeme("x", 1, 5, 4)),

		--         10 + y
		binary_expression.new(
			-- 10
			number_literal.new("10", region.from_lexeme("10", 1, 9, 8)),
			-- y
			identifier.new("y", region.from_lexeme("y", 1, 14, 13)),
			"+"
		),

		-- let
		region.from_lexeme("let")
	)

	self:is_equal(node:kind(), variable_definition)
	self:is_truthy(node:is_statement())
	self:is_falsy(node:is_expression())

	self:is_equal(node.region, {
		first_line = 1,
		last_line = 1,
		first_column = 1,
		last_column = 14,
		first_position = 0,
		last_position = 13
	})

	self:did_invoke_pass(node.accept, node, {
		visit_variable_definition = function(_, node2)
			self:is_equal(node2, node)
		end
	})
end
