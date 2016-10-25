nlnoise = {}

local function to_np_table(seeddiff,octaves,persistance,scale)
	return {
		seed = seeddiff,
		octaves = octaves,
		persistance = persistance,
		scale = scale,
	}
end

local function get_range(octaves,persistance)
	-- Get the real range of noise before scaling
	local range = 0
	local octave_scale = 1
	for octave=1,octaves do
		range = range + 1*octave_scale
		octave_scale = octave_scale * persistance
	end
	
	return range
end

-- Returns the table if normalisation was sucessful
nlnoise.normalise = function(np)
	if not np.persistance or not np.octaves or not np.scale then
		return nil
	end

	np.scale = np.scale/get_range(np.octaves,np.persistance)

	return np
end

nlnoise.get_perlin = function(noiseparams)
	local np = table.copy(noiseparams)

	if not nlnoise.normalise(np) then
		return nil
	end

	return minetest.get_perlin(np)
end

nlnoise.get_perlin_map = function(noiseparams,size)
	local np = table.copy(noiseparams)

	if not nlnoise.normalise(np) then
		return nil
	end

	return minetest.get_perlin_map(np,size)
end
