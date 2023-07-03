function tableSize( tab )
	if type( tab ) ~= "table" then
		return 0
	end

	local size = 0
	for key, val in pairs( tab ) do
		size = size + 1
	end
	return size
end

function CloneTable( t )
	if type( t ) ~= "table" then return t end
	local c = {}
	for i, v in pairs( t ) do c[ i ] = CloneTable( v ) end
	return c
end
