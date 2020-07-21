local region = require("compiler.region")
local abstract_node = require("compiler.ast.abstract-node")

--- The call expression AST node.
--- @class call_expression : abstract_node
local call_expression = setmetatable({}, { __index = abstract_node })
call_expression.__index = call_expression

--- Creates a new call_expression AST node.
--- @param target identifier
--- @param arguments expression[]
--- @param closeParenRegion region
--- @return call_expression
function call_expression.new(target, arguments, closeParenRegion)
	return setmetatable({
		target = target,
		arguments = arguments,
		region = region.extend(target.region, closeParenRegion)
	}, call_expression)
end

--- Returns whether or not the node is a statement.
--- @return boolean
function call_expression:is_statement()
	return true
end

--- Returns whether or not the node is an expression.
--- @return boolean
function call_expression:is_expression()
	return true
end

--- Accepts a visitor.
--- @param visitor abstract_visitor
function call_expression:accept(visitor)
	visitor:visit_call_expression(self)
end

return call_expression