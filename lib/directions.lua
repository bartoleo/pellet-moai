DIRECTIONS={
	n={id=1, dx=0,  dy=-1, baseframe=10},
	e={id=2, dx=1,  dy=0,  baseframe=0},
	s={id=3, dx=0,  dy=1,  baseframe=5},
	w={id=4, dx=-1, dy=0,  baseframe=15}
}
function DIRECTIONS.dir(pid)
	for k,v in pairs(DIRECTIONS) do
		if type(v)=="table" then
		  if v.id==pid then
			  return k
		  end
		end
	end
	return nil
end