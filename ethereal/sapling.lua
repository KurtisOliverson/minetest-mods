
-- Function to Register Saplings

ethereal.register_sapling = function( sapling_node_name, sapling_descr, sapling_texture )

	-- if the sapling does not exist yet, create a node for it
	if( not( minetest.registered_nodes[ sapling_node_name ] )) then
		minetest.register_node( sapling_node_name, {
			description = sapling_descr,
			drawtype = "plantlike",
			visual_scale = 1.0,
			tiles = { sapling_texture},
			inventory_image = sapling_texture,
			wield_image = sapling_texture,
			paramtype = "light",
			walkable = false,
			groups = {snappy=2,dig_immediate=3,flammable=2,ethereal_sapling=1},
			sounds = default.node_sound_defaults(),
		})
	end

end

-- Register Saplings

ethereal.register_sapling( 'ethereal:willow_sapling', 'Willow Sapling', 'willow_sapling.png' );
ethereal.register_sapling( 'ethereal:yellow_tree_sapling', 'Yellow Tree Sapling', 'yellow_tree_sapling.png' );
ethereal.register_sapling( 'ethereal:tree_sapling', 'Tree Sapling', 'ethereal_tree_sapling.png' );
ethereal.register_sapling( 'ethereal:jungle_tree_sapling','Jungletree Sapling', 'ethereal_jungle_tree_sapling.png' );
ethereal.register_sapling( 'ethereal:pine_tree_sapling', 'Pine Sapling', 'ethereal_pine_tree_sapling.png' );
ethereal.register_sapling( 'ethereal:big_tree_sapling', 'Big Tree Sapling', 'ethereal_big_tree_sapling.png' );
ethereal.register_sapling( 'ethereal:banana_tree_sapling', 'Banana Tree Sapling', 'banana_tree_sapling.png' );
ethereal.register_sapling( 'ethereal:frost_tree_sapling', 'Frost Sapling', 'ethereal_frost_tree_sapling.png' );
ethereal.register_sapling( 'ethereal:gray_tree_sapling', 'Gray Sapling', 'ethereal_gray_tree_sapling.png' );
ethereal.register_sapling( 'ethereal:mushroom_sapling', 'Mushroom Sapling', 'ethereal_mushroom_sapling.png' );
ethereal.register_sapling( 'ethereal:palm_sapling', 'Palm Sapling', 'moretrees_palm_sapling.png' );
ethereal.register_sapling( 'ethereal:redwood_sapling', 'Redwood Sapling', 'redwood_sapling.png' );

-- Find centre position for Tree to grow

ethereal.centre_place = function(pos, center_offset, schematic_size, schem_name)

	-- Calculate Tree's centre position (to grow where sapling was)
	-- an offset depending on rotation; rotation thus can't be "random"

	local rotation = tostring( (math.random( 4 )-1) * 90);
	local p = {x=pos.x, y=pos.y, z=pos.z};
	if(     rotation=="0" ) then
		p.x = pos.x - center_offset.x;
		p.z = pos.z - center_offset.z;
	elseif( rotation=="90" ) then
		p.x = pos.x - center_offset.z;
		p.z = pos.z - ( schematic_size.x - center_offset.x - 1);
	elseif( rotation=="180" ) then
		p.x = pos.x - ( schematic_size.x - center_offset.x - 1);
		p.z = pos.z - ( schematic_size.z - center_offset.z - 1);
	elseif( rotation=="270" ) then
		p.x = pos.x - ( schematic_size.z - center_offset.z - 1);
		p.z = pos.z - center_offset.x;
	end

	-- Remove Sapling and Place Tree Schematic

	minetest.env:set_node(pos, {name="air"}) -- quicker than remove_node

	minetest.place_schematic(p, minetest.get_modpath("ethereal").."/schematics/"..schem_name..".mts", rotation, {}, false );

end

-- Grow saplings

minetest.register_abm({
	nodenames = { "group:ethereal_sapling" },
	interval = 20,
	chance = 25,
	action = function(pos, node)

		local node_under =  minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name;

		-- Check if Sapling is growing on correct substrate

		if (node.name == "ethereal:yellow_tree_sapling" and node_under == "default:dirt_with_snow") then
			ethereal.centre_place ( pos, {x=4,y=0,z=4}, {x=9,y=19,z=9}, "yellowtree"); return
		elseif (node.name == "ethereal:tree_sapling" and node_under == "ethereal:green_dirt_top") then
			ethereal.centre_place ( pos, {x=2,y=0,z=2}, {x=5,y=7,z=5}, "tree"); return
		elseif (node.name == "ethereal:jungle_tree_sapling" and node_under == "ethereal:jungle_dirt") then
			ethereal.centre_place ( pos, {x=6,y=0,z=3}, {x=13,y=19,z=7}, "jungletree"); return
		elseif (node.name == "ethereal:pine_tree_sapling" and node_under == "ethereal:cold_dirt") then
			ethereal.centre_place ( pos, {x=3,y=1,z=3}, {x=7,y=8,z=7}, "pinetree"); return
		elseif (node.name == "ethereal:big_tree_sapling" and node_under == "ethereal:green_dirt_top") then
			ethereal.centre_place ( pos, {x=4,y=0,z=3}, {x=9,y=8,z=9}, "bigtree"); return
		elseif (node.name == "ethereal:banana_tree_sapling" and node_under == "ethereal:grove_dirt") then
			ethereal.centre_place ( pos, {x=2,y=0,z=2}, {x=7,y=8,z=7}, "bananatree"); return
		elseif (node.name == "ethereal:frost_tree_sapling" and node_under == "ethereal:crystal_topped_dirt") then
			ethereal.centre_place ( pos, {x=3,y=0,z=3}, {x=8,y=20,z=8}, "frosttrees"); return
		elseif (node.name == "ethereal:gray_tree_sapling" and node_under == "ethereal:gray_dirt_top") then
			ethereal.centre_place ( pos, {x=2,y=0,z=2}, {x=5,y=8,z=5}, "graytrees"); return
		elseif (node.name == "ethereal:mushroom_sapling" and node_under == "ethereal:mushroom_dirt") then
			ethereal.centre_place ( pos, {x=3,y=0,z=3}, {x=8,y=12,z=9}, "mushroomone"); return
		elseif (node.name == "ethereal:palm_sapling" and node_under == "default:sand") then
			ethereal.centre_place ( pos, {x=3,y=0,z=4}, {x=7,y=10,z=7}, "palmtree"); return
		elseif (node.name == "ethereal:willow_sapling" and node_under == "ethereal:gray_dirt_top") then
			ethereal.centre_place ( pos, {x=5,y=0,z=5}, {x=11,y=14,z=11}, "willow"); return
		elseif (node.name == "ethereal:redwood_sapling" and node_under == "bakedclay:red") then
			ethereal.centre_place ( pos, {x=9,y=0,z=9}, {x=18,y=43,z=18}, "redwood"); return
		end

	end,
})