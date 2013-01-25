--
-- Copyright (C) 2005-2013 MaNGOS <http://getmangos.com/>
-- Copyright (C) 2009-2013 MaNGOSZero <https://github.com/mangoszero>
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--

-- Fix Issues #15 NPC have missing gossip_menu_id and he is Vendor and Questgiver
UPDATE `creature_template` SET gossip_menu_id=1781, npcflag=7 WHERE entry=233;

-- Fix Onyxia hitbox
UPDATE `creature_model_info` SET bounding_radius=8.8, combat_reach=8.8 WHERE modelid=8570;

-- Cleanup
UPDATE creature SET
curhealth = (SELECT FLOOR(RAND(1)*(maxhealth - minhealth) + minhealth) FROM creature_template WHERE creature.id = creature_template.entry)
WHERE curhealth < (SELECT minhealth FROM creature_template WHERE creature.id = creature_template.entry);

UPDATE creature SET
curmana = (SELECT FLOOR(RAND(1)*(maxmana - minmana) + minmana) FROM creature_template WHERE creature.id = creature_template.entry)
WHERE curmana < (SELECT minmana FROM creature_template WHERE creature.id = creature_template.entry);

UPDATE creature SET MovementType = 1 WHERE spawndist != 0 AND MovementType = 0;
UPDATE creature SET MovementType = 0 WHERE spawndist = 0 AND MovementType != 2;
UPDATE creature SET MovementType = 2 WHERE guid IN (SELECT DISTINCT id FROM creature_movement);
DELETE FROM creature_movement WHERE id NOT IN (SELECT guid FROM creature);

DELETE FROM creature_addon WHERE guid NOT IN (SELECT guid FROM creature);

-- Update Database Version
UPDATE db_version set version = 'ZeroDatabase 2.0.1 for MaNGOSZero zXXXX+ and ScriptDevZero zXXXX+';