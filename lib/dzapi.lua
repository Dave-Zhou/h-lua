hdzapi = {}
hdzapi.hdz_map_lv = 10001
hdzapi.mapLv = function(whichPlayer)
	return japi.DzAPI_Map_GetMapLevel(whichPlayer)
end
