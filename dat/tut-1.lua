
local tut_ctrl_key = nil;
local tut_alt_key = nil;

function tut_key(command)
   local s = nh.eckey(command);
   local m = s:match("^^([A-Z])$"); -- ^X is Ctrl-X
   if (m ~= nil) then
      tut_ctrl_key = m;
      return "Ctrl-" .. m;
   end

   m = s:match("^M%-([A-Z])$"); -- M-X is Alt-X
   if (m ~= nil) then
      tut_alt_key = m;
      return "Alt-" .. m;
   end

   return s;
end

function tut_key_help(x, y)
   if (tut_ctrl_key ~= nil) then
      des.engraving({ coord = { x,y }, type = "engrave", text = "Note: Outside the tutorial, Ctrl-key combinations are shown prefixed with a caret, like '^" .. tut_ctrl_key .. "'", degrade = false });
      tut_ctrl_key = nil;
   end
end

des.level_init({ style = "solidfill", fg = " " });
des.level_flags("mazelevel", "noflip",
                "nomongen", "nodeathdrops", "noautosearch");

des.map([[
---------------------------------------------------------------------------
|-.--|.......|......|..S....|.F.......|.............|.......|.............|
|.-..........|......|--|....|.F.....|.|S-------.....|.....................|
||.--|.......|..T......|....|.F.....|.|.......|.....|.......|.............|
||.|.|.......|......|-.|....|.F.....|.|.......|.....|--------.............|
||.|.|.......|......||.|-.-----------.-.......|-S----.....................|
|-+-S---------..---.||........................|...|.......................|
|......|          |.-------------------.......|...|....--S----............|
|......|  ######  |.........|      |..S.......|...|....|.....|............|
|----.-| -+-   #  |.....---.|######+..|.......S...|....|.....|............|
|----+----.----+---.|.--|.|.|#     ------------...|....|.....F............|
|........|.|......|.|...F...|#  ........|.....+...|....|.....|............|
|.P......-S|......|------.---# .........|.....|...|....-------........----|
|..........|......+.|...|.|.S# ..--S-----.....|LLL|..................|..| |
|.W......---......|.|.|.|.|.|# ..|......|.....|LLL|..................|..--|
|....Z.L.S.F......|.|.|.|.---#   |......+.....|...|..................|..|.|
|........|--......|...|.....|####+......|.....|...+..................||...|
---------------------------------------------------------------------------
]]);


des.region(selection.area(01,01, 73, 16), "lit");

des.non_diggable();

des.teleport_region({ region = { 9,3, 9,3 } });

-- TODO:
--  - save (more of) hero state when entering
--  - quit-command should maybe exit the tutorial?

-- turn on some newbie-friendly options
nh.parse_config("OPTIONS=mention_walls");
nh.parse_config("OPTIONS=mention_decor");
nh.parse_config("OPTIONS=lit_corridor");

-- VoxHack: the engravings teach the 3D game's controls (mouse, WASD,
-- the right click and its wheels, the hotbar keys 1-5...), not NetHack's
-- keyboard commands

des.engraving({ coord = { 9,3 }, type = "engrave", text = "Walk with W A S D and look around with the mouse. Esc > Help lists every key", degrade = false });
des.engraving({ coord = { 5,2 }, type = "engrave", text = "You can walk any way you like, diagonals too: just look where you want to go", degrade = false });

if (u.role == "Knight") then
   des.engraving({ coord = { 12,1 }, type = "engrave", text = "Knights can jump: hold Shift + right click and choose Jump", degrade = false });
end

--

des.engraving({ coord = { 2,4 }, type = "engrave", text = "Some actions may require multiple tries before succeeding", degrade = false });
des.engraving({ coord = { 2,5 }, type = "engrave", text = "Open the door: right click it (a quick tap), or walk into it", degrade = false });
des.door({ coord = { 2,6 }, state = "closed" });

des.engraving({ coord = { 2,7 }, type = "engrave", text = "Close a door: right click it", degrade = false });


--

des.engraving({ coord = { 4,5 }, type = "engrave", text = "You can leave the tutorial via the magic portal.", degrade = false });
des.trap({ type = "magic portal", coord = { 4,4 }, seen = true });

--

des.engraving({ coord = { 5,9 }, type = "engrave", text = "This door is locked. Look at it and press 2 to kick it", degrade = false });
des.door({ coord = { 5,10 }, state = "locked" });



des.engraving({ coord = { 5,12 }, type = "engrave", text = "Middle click to look at anything, Z for the map of the whole level, and F2 to read about it on NetHackWiki", degrade = false });

--

des.engraving({ coord = { 10,13 }, type = "engrave", text = "Press X to search for secret doors (hold it to keep searching)", degrade = false });

des.engraving({ coord = { 10,15 }, type = "engrave", text = "Wrong secret", degrade = false });

--

des.engraving({ coord = { 10,10 }, type = "engrave", text = "Behind this door is a dark corridor", degrade = false });
des.door({ coord = { 10,9 }, state = percent(50) and "locked" or "closed" });
des.region(selection.match("#"), "unlit");
des.region(selection.match(" "), "unlit");
des.door({ coord = { 15,10 }, state = percent(50) and "locked" or "closed" });

--

des.engraving({ coord = { 15,11 }, type = "engrave", text = "There are four traps next to you! Search for them with X", degrade = false });
local locs = { {14,11}, {14,12}, {15,12}, {16,12}, {16,11} };
shuffle(locs);
for i = 1, 4 do
   des.trap({ type = percent(50) and "sleep gas" or "board",
              coord = locs[i], victim = false });
end

des.engraving({ coord = { 15,15 }, type = "engrave", text = "Some traps can be disabled: look at one next to you, hold right click and choose Untrap", degrade = false });
des.trap({ coord = { 15,16 }, type = "web", spider_on_web = false });

--

des.door({ coord = { 18,13 }, state = "closed" });

des.engraving({ coord = { 19,13 }, type = "engrave", text = "Pick up items with F (or a quick right click when nothing else is here)", degrade = false });

local armor = (u.role == "Monk") and "leather gloves" or "leather armor";

des.object({ id = armor, spe = 0, buc = "cursed", coord = { 19,14} });

des.engraving({ coord = { 19,15 }, type = "engrave", text = "Wear armor: I opens your inventory; click the armor, then Wear", degrade = false });

des.object({ id = "dagger", spe = 0, buc = "not-cursed", coord = { 21,15} });

des.engraving({ coord = { 21,14 }, type = "engrave", text = "Wield weapons: I, click the weapon, then Wield", degrade = false });


des.engraving({ coord = { 22,13 }, type = "engrave", text = "Fight with the left mouse button: aim at a monster in reach and click", degrade = false });

des.monster({ id = "lichen", coord = { 23,15 }, waiting = true, countbirth = false });

--

des.engraving({ coord = { 24,16 }, type = "engrave", text = "Now you know the very basics. You can leave the tutorial via the magic portal.", degrade = false });

des.engraving({ coord = { 26,16 }, type = "engrave", text = "Step into this portal to leave the tutorial", degrade = false });
des.trap({ type = "magic portal", coord = { 27,16 }, seen = true });

--

des.engraving({ coord = { 25,13 }, type = "engrave", text = "Push boulders by walking straight into them", degrade = false });
des.object({ id = "boulder", coord = {25,12} });

--

des.engraving({ coord = { 27,9 }, type = "engrave", text = "Take off armor: I, click it, then Take off", degrade = false });

--

des.object({ class = "?", id = "remove curse", buc = "blessed", coord = {23,11} })
des.engraving({ coord = { 22,11 }, type = "engrave", text = "Some items have shuffled descriptions, different each game", degrade = false });
des.engraving({ coord = { 23,11 }, type = "engrave", text = "Pick up this scroll (F), read it (I, click it, Read), and try to take off the armor again", degrade = false });

--

des.engraving({ coord = { 19,10 }, type = "engrave", text = "Another magic portal, a way to leave this tutorial", degrade = false });
des.trap({ type = "magic portal", coord = { 19,11 }, seen = true });

--

-- rock fall
des.object({ coord = {14, 5}, id = "rock", quantity = math.random(50,99) });
des.object({ coord = {15, 5}, id = "rock", quantity = math.random(10,30) });
des.object({ coord = {14, 4}, id = "rock", quantity = math.random(10,30) });
des.object({ coord = {15, 6}, id = "rock", quantity = math.random(30,60) });
des.object({ coord = {14, 6}, id = "rock", quantity = math.random(30,60) });
des.object({ coord = {14, 6}, id = "boulder" });

des.door({ coord = { 20,3 }, state = percent(50) and "open" or "closed" });

des.engraving({ coord = { 21,3 }, type = "engrave", text = "Avoid being burdened, it slows you down", degrade = false });
des.engraving({ coord = { 22,3 }, type = "engrave", text = "Drop items: I, click the item, then Drop", degrade = false });
des.engraving({ coord = { 22,4 }, type = "engrave", text = "To drop part of a stack, use NetHack's command line: T, then d, then a number and the item's letter", degrade = false });

--

des.monster({ id = "yellow mold", coord = { 26,2 }, waiting = true, countbirth = false });

des.engraving({ coord = { 25,5 }, type = "engrave", text = "Throw items: I, click the item, Throw - it flies where your crosshair points", degrade = false });

des.trap({ type = "magic portal", coord = { 21,1 }, seen = true });

--

des.monster({ id = "wolf", coord = { 29,2 }, peaceful = 0, waiting = true, countbirth = false });

des.engraving({ coord = { 37,4 }, type = "engrave", text = "Missiles, such as rocks, work better when fired from appropriate launcher", degrade = false });

des.object({ coord = { 37,3 }, id = "sling", buc = "not-cursed", spe = 9 });
des.engraving({ coord = { 37,3 }, type = "engrave", text = "Wield the sling (I, click it, Wield)", degrade = false });
des.engraving({ coord = { 36,1 }, type = "engrave", text = "Fire missiles from the wielded launcher with 1, or Shift + left click: they go where you aim", degrade = false });

des.engraving({ coord = { 35,4 }, type = "engrave", text = "Firing launches what's in your quiver: I, click the ammo, then Quiver", degrade = false });

des.engraving({ coord = { 33,4 }, type = "engrave", text = "Press Space to wait a turn. Time crawls while you stand still", degrade = false });


--

des.door({ coord = { 38,6 }, state = "closed" });

des.engraving({ coord = { 39,6 }, type = "engrave", text = "Open boxes and chests: right click them", degrade = false });

des.object({ coord = { 41,6 }, id = "large box", broken = true, trapped = false,
             contents = function(obj)
                des.object({ id = "secret door detection", class = "/", spe = 30 }); end
});
des.engraving({ coord = { 42,6 }, type = "engrave", text = "To empty a container onto the floor, use the command line: T, then #tip", degrade = false });

des.engraving({ coord = { 45,6 }, type = "engrave", text = "Zap wands with 3: they fire where you aim (look straight down or up to zap down or up)", degrade = false });

--

des.door({ coord = { 35,9 }, state = "nodoor" });
des.engraving({ coord = { 34,9 }, type = "engrave", text = "No need to run: just keep walking. Time passes as you move", degrade = false });

--

des.door({ coord = { 33,16 }, state = "nodoor" });
des.engraving({ coord = { 35,15 }, type = "engrave", text = "Z shows the whole level's map; Z again closes it", degrade = false });

--

des.trap({ type = "magic portal", coord = { 27,14 }, seen = true });

--

des.engraving({ coord = { 48,1 }, type = "burn", text = "Eat with 5 (it asks what to eat)", degrade = false });

des.object({ coord = { 50,3 }, id = "apple", buc = "not-cursed"  });
des.object({ coord = { 50,3 }, id = "candy bar", buc = "not-cursed"  });

des.object({ coord = { 50,3 }, id = "corpse", montype = "lichen", buc = "not-cursed" });

--

des.door({ coord = { 46,11 }, state = "closed" });

des.engraving({ coord = { 43,11 }, type = "burn", text = "Fight with two weapons: hold Alt + right click and choose Dual wield", degrade = false });
des.object({ coord = { 43,13 }, id = "knife", buc = "uncursed" });
des.object({ coord = { 43,14 }, id = "dagger", buc = "blessed" });

des.engraving({ coord = { 43,16 }, type = "burn", text = "Swap weapons quickly: hold Alt + right click and choose Swap weapons", degrade = false });

des.door({ coord = { 40,15 }, state = "random" });

--

des.object({ coord = { 48,7 }, id = "ring of levitation", buc = "not-cursed" });

des.engraving({ coord = { 48,10 }, type = "burn", text = "Put on rings and amulets: I, click it, then Put on", degrade = false });

des.engraving({ coord = { 48,16 }, type = "burn", text = "Take off rings and amulets: I, click it, then Remove", degrade = false });

des.door({ coord = { 50,16 }, state = "closed" });


--

des.engraving({ coord = { 58,9 }, type = "burn", text = "Walk into the stairs to go down (or right click them)", degrade = false });
des.stair({ dir = "down", coord = { 58,10 } });

--


des.engraving({ coord = { 65,3 }, type = "burn", text = "UNDER CONSTRUCTION", degrade = false });

des.trap({ type = "magic portal", coord = { 66,2 }, seen = true });

--

-- squeezing through small gaps

des.engraving({ coord = { 69,12 }, type = "burn", text = "Can't get through?  You're carrying too much.", degrade = false });

-- try to squeeze over boulders, find a trap door

des.object({ id = "boulder", coord = {71,16} });
des.object({ id = "boulder", coord = {72,16} });
des.object({ id = "boulder", coord = {73,16} });
des.trap({ type = "trap door", coord = { 73,15 } });

--

des.engraving({ coord = { 60,2 }, type = "engrave", text = "Spellcasting", degrade = false });
if (u.uenmax < 5) then
   -- TODO: make sure hero has enough Pw to cast the spell (5 pw) instead?
   -- TODO: ensure the first cast of this spell succeeds?
   des.engraving({ coord = { 59,2 }, type = "engrave", text = "Unfortunately you don't have enough energy to cast spells.", degrade = false });
end
des.engraving({ coord = { 57,2 }, type = "engrave", text = "Pick up the spellbook with F", degrade = false });
des.object({ coord = { 57,2 }, id = "spellbook of light", buc = "blessed" });
des.engraving({ coord = { 55,2 }, type = "engrave", text = "Read the spellbook: I, click it, then Read", degrade = false });
des.engraving({ coord = { 53,2 }, type = "engrave", text = "Cast spells with 4: Cast, Self, or Target (then left click where it goes)", degrade = false });
des.region(selection.area(53,01, 59, 3), "unlit");

--

des.engraving({ coord = { 72,2 }, type = "engrave", text = "Drink (\"quaff\") potions: I, click it, then Quaff", degrade = false });
des.object({ coord = { 72,2 }, id = "potion of object detection", buc = "blessed" });


----------------

-- entering and leaving tutorial _branch_ now handled by core
-- // nh.callback("cmd_before", "tutorial_cmd_before");
-- // nh.callback("level_enter", "tutorial_enter");
-- // nh.callback("level_leave", "tutorial_leave");
-- // nh.callback("end_turn", "tutorial_turn");

----------------

-- temporary stuff here
-- des.trap({ type = "magic portal", coord = { 9,5 }, seen = true });
-- des.trap({ type = "magic portal", coord = { 9,1 }, seen = true });
-- des.object({ id = "leather armor", spe = 0, coord = { 9,2} });

