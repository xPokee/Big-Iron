// PARTS //
/obj/item/weaponcrafting
	icon = 'icons/obj/improvised.dmi'

/obj/item/weaponcrafting/stock
	name = "rifle stock"
	desc = "A classic rifle stock that doubles as a grip, roughly carved out of wood."
	custom_materials = list(/datum/material/wood = MINERAL_MATERIAL_AMOUNT * 6)
	icon_state = "riflestock"

/obj/item/weaponcrafting/string
	name = "string"
	desc = "A long piece of thread with some resemblance to cable coil."
	icon_state = "durastring"

////////////////////////////////
// IMPROVISED WEAPON PARTS//
////////////////////////////////

/obj/item/weaponcrafting/improvised_parts
	name = "Debug Improvised Gun Part"
	desc = "A badly coded gun part. You should report coders if you see this."
	icon = 'icons/obj/guns/gun_parts.dmi'
	icon_state = "palette"

// RECEIVERS

/obj/item/weaponcrafting/improvised_parts/rifle_receiver
	name = "rifle receiver"
	desc = "A crudely constructed receiver to create an improvised bolt-action breechloaded rifle."  // removed some text implying that the item had more uses than it does
	icon_state = "receiver_rifle"
	w_class = WEIGHT_CLASS_SMALL


/obj/item/weaponcrafting/improvised_parts/shotgun_receiver
	name = "shotgun reciever"
	desc = "An improvised receiver to create a break-action breechloaded shotgun."  // removed some text implying that the item had more uses than it does
	icon_state = "receiver_shotgun"
	w_class = WEIGHT_CLASS_SMALL

// MISC

/obj/item/weaponcrafting/improvised_parts/trigger_assembly
	name = "firearm trigger assembly"
	desc = "A modular trigger assembly with a firing pin, this can be used to make a whole bunch of improvised firearms."
	icon_state = "trigger_assembly"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/weaponcrafting/improvised_parts/wooden_body
	name = "wooden firearm body"
	desc = "A crudely fashioned wooden body to help keep higher calibre improvised weapons from blowing themselves apart."
	icon_state = "wooden_body"

/obj/machinery/workbench
	name = "workbench"
	icon = 'modular_BD2/general/icons/workbench.dmi'
	icon_state = "standard_bench"
	desc = "A basic workbench with a full set of tools for simple to intermediate projects."
	resistance_flags = INDESTRUCTIBLE
	density = TRUE
	pass_flags = LETPASSTHROW
	pass_flags_self = PASSTABLE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	machine_tool_behaviour = list(TOOL_WORKBENCH, TOOL_CROWBAR, TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WRENCH)
	drag_delay = 0.4 SECONDS // Heavy, slow to drag
	var/wrenchable = 1

/obj/machinery/workbench/CanPass(atom/movable/mover, border_dir)
	if(src.density == 0)
		return 1
	if(istype(mover) && (mover.pass_flags & pass_flags_self))
		return 1
	else
		return 0

/obj/machinery/workbench/can_be_unfasten_wrench(mob/user, silent)
	if (!wrenchable)  // case also covered by NODECONSTRUCT checks in default_unfasten_wrench
		return CANT_UNFASTEN

	return ..()

/obj/machinery/workbench/wrench_act(mob/living/user, obj/item/I)
	default_unfasten_wrench(user, I, 10)
	return TRUE

/obj/machinery/workbench/attackby(obj/item/W, mob/user, params)
	if (istype(W, /obj/item/wrench) && !(flags_1&NODECONSTRUCT_1))
		W.play_tool_sound(src)
		deconstruct(TRUE)
		return
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(istype(W,/obj/item/salvage))
		var/obj/item/salvage/S = W
		if(do_after(user,1,target = src))
			if(HAS_TRAIT(user, TRAIT_TECHNOPHREAK))
				var/obj/I = pick(S.Loot)
				new I (src.loc)
			var/obj/I = pick(S.Loot)
			new I (src.loc)
			if(prob(50))
				var/obj/J = pick(S.Loot)
				new J (src.loc)
				if(prob(30))
					var/obj/K = pick(S.Loot)
					new K (src.loc)
			stoplag(1)
			qdel(W)

	if(istype(W,/obj/item/storage))
		var/obj/item/storage/baggy = W
		var/obj/item/salvage/checkitem
		if(!baggy.in_use)
			baggy.in_use = TRUE
			for(var/thingy in baggy.contents)
				if(!istype(thingy, /obj/item/salvage))//how did we get here
					baggy.in_use = FALSE
					break
				checkitem = thingy
				if(!user.transferItemToLoc(checkitem, drop_location()))
					break
				if(do_after(user,5,target = src))
					if(HAS_TRAIT(user, TRAIT_TECHNOPHREAK))
						var/obj/I = pick(checkitem.Loot)
						new I (src.loc)
					var/obj/I = pick(checkitem.Loot)
					new I (src.loc)
					if(prob(50))
						var/obj/J = pick(checkitem.Loot)
						new J (src.loc)
					if(prob(25))
						var/obj/K = pick(checkitem.Loot)
						new K (src.loc)
					stoplag(1)
					qdel(checkitem)
			baggy.in_use = FALSE
			return
	if(user.transferItemToLoc(W, drop_location()))
		return 1

/obj/machinery/workbench/advanced
	name = "advanced workbench"
	desc = "A large and advanced pre-war workbench to tackle any project! Comes with a full set of basic tools and a digital multitool."
	icon = 'modular_BD2/general/icons/workbench.dmi'
	icon_state = "advanced_bench"
	machine_tool_behaviour = list(TOOL_AWORKBENCH, TOOL_WORKBENCH, TOOL_CROWBAR, TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WRENCH, TOOL_MULTITOOL)

/obj/machinery/workbench/mbench
	name = "machine workbench"
	//icon_state = "advanced_bench"
	desc = "A machining bench, useful for producing complex machined parts."
	machine_tool_behaviour = list(TOOL_MWORKBENCH)

/obj/machinery/workbench/assbench
	name = "assembly workbench"
	//icon_state = "advanced_bench"
	desc = "An assembly bench, useful for assembling complex parts into semi-finished products."
	machine_tool_behaviour = list(TOOL_ASSWORKBENCH)

/obj/machinery/workbench/fbench
	var/obj/item/prefabs/mould
	name = "moulding workbench"
	icon_state = "moulding"
	desc = "A moulding bench, used for superheating metal into its molten form and moulding it."
	machine_tool_behaviour = list(TOOL_FWORKBENCH)
	wrenchable = FALSE

/obj/machinery/workbench/bottler
	name = "bottle press"
	desc = "A self-crafted all-in-one bottle making and pressing machine."
	icon = 'modular_BD2/general/icons/workbench.dmi'
	icon_state = "bottler"
	machine_tool_behaviour = list(TOOL_BOTTLER)

/obj/machinery/workbench/forge
	name = "metalworking bench"
	desc = "A workbench with a drill press, a makeshift blowtorch setup, and various tools for making crude weapons and tools."
	icon = 'modular_BD2/general/icons/workbench64x32.dmi'
	icon_state = "bench_metal"
	bound_width = 64
	machine_tool_behaviour = list(TOOL_FORGE, TOOL_WELDER)

/obj/item/weaponcrafting/receiver
	name = "modular receiver"
	desc = "A prototype modular receiver and trigger assembly for a firearm."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "receiver"

/obj/item/weaponcrafting/stock
	name = "rifle stock"
	desc = "A classic rifle stock that doubles as a grip, roughly carved out of wood."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "riflestock"

/obj/machinery/ammobench
	name = "pre-war reloading press"
	desc = "A high quality reloading press from before the war. Capable of cheap, mass production of ammunition."
	icon = 'icons/obj/machines/pre-war_press.dmi'
	icon_state = "pre-war_press"
	resistance_flags = INDESTRUCTIBLE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	machine_tool_behaviour = TOOL_RELOADER

/obj/machinery/ammobench/makeshift
	name = "makeshift reloading bench"
	desc = "A makeshift reloading bench capable of producing ammunition rather inefficiently."
	icon = 'icons/obj/machines/reloadingbench.dmi'
	icon_state = "reloading_bench"
	resistance_flags = INDESTRUCTIBLE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	machine_tool_behaviour = TOOL_MSRELOADER

/obj/machinery/ammobench/makeshift/wrench_act(mob/living/user, obj/item/I)
	default_unfasten_wrench(user, I, 10)
	return TRUE
