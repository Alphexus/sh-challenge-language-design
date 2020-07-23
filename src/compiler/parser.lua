--- Given a source file, yields an undecorated AST after syntax analysis.
--- @class parser
local parser = {}
parser.__index = parser

--- Creates a parser.
--- @param istream input_stream
--- @return parser
function parser.new(istream)
	return setmetatable({
		_istream = istream,
		-- implementation defined
	}, parser)
end

--- Constructs an undecorated AST from the input stream.
--- @return program
function parser:parse()
	error("parser::parse(): not yet implemented!")
end

return parser
