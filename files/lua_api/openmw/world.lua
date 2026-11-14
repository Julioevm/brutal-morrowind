---
-- Provides an interface to the game world for global scripts.
-- @context global
-- @module world
-- @usage local world = require('openmw.world')

---
-- Brutal engine extension. Queues an immediate enhanced NPC ragdoll launch.
-- Sends BrutalSuperKickResolved {kickId, accepted} to the player after the native
-- action. Only a player contact within190 units in the same active cell is
-- accepted. Living humanoid NPCs and fresh intact corpses are supported. Exact
-- body sweeps can knock down other NPCs during flight; secondary victims do not
-- become projectiles. Teleport, removal, recovery and scene unload cancel it.
-- @function [parent=#world] applyNpcSuperKick
-- @param openmw.core#GameObject actor
-- @param openmw.util#Vector3 velocity Finite launch, length1..1000, horizontal speed>=100.
-- @param openmw.core#GameObject attacker The player.
-- @param #number kickId Unique positive integer<=9007199254740991; repeats are rejected.

---
-- Brutal engine extension. Returns transient super-kick flight/contact numeric
-- diagnostics for an existing NPC ragdoll, or nil. active=1 only for the primary
-- in flight; secondary=1, receivedHits=1 identifies a witnessed knockdown.
-- @function [parent=#world] getNpcSuperKickState
-- @param openmw.core#GameObject actor
-- @return #table, #nil

---
-- Brutal engine extension. Returns the active NPC ragdoll controller's numeric
-- diagnostics, or nil. Includes effective flags, simulatedAge, activeBodies,
-- activeJoints, impact/duplicate/invalid/cap counts, last J/H, maximum calculated
-- soft/tone torques, collision penetration and per-joint rotations/limits.
-- Calculated controller moments are not measurements of native solver forces.
-- @function [parent=#world] getNpcRagdollEnhancementState
-- @param openmw.core#GameObject actor
-- @return #table, #nil

---
-- Brutal engine extension. Queues one world-space point impulse on an existing
-- native NPC ragdoll with enhancement enabled. Bullet applies the primary J and
-- its r-cross-J once; a small compensated procedural angular response is optional.
-- Repeated event IDs are ignored within the controller's bounded 64-event cache.
-- Queueing does not return an application receipt; inspect diagnostics later.
-- @function [parent=#world] applyNpcRagdollImpact
-- @param openmw.core#GameObject actor
-- @param #number part Physical body index, 1..11.
-- @param openmw.util#Vector3 point Finite world contact point.
-- @param openmw.util#Vector3 impulse Finite mass*game-units/s, magnitude <=200000.
-- @param #number eventId Exact positive integer <=9007199254740991.

---
-- Brutal engine extension. Queue a procedural head-only cut on a dead, enabled
-- non-player NPC. Prepares per-instance neck geometry and two closed textured
-- caps before releasing the existing ragdoll head joint in the same update.
-- World poses are retained. A nonzero cutDirection replaces all body-part linear
-- velocities with 250 Source units/s scaled by1.84265547703229, and adds the
-- Source-style head angular impulse capped at3600 degrees/s. A zero/missing
-- direction restores a saved cut without a new launch. The helmet remains with the head
-- and the original NPC continues to own all inventory. Unsupported geometry
-- leaves the actor intact. Repeated requests are idempotent; this function does
-- not implement random chance or damage. Inspect getNpcRagdollState.headDetached
-- on a later update to confirm success; queueing is not a success receipt.
-- @function [parent=#world] startNpcDecapitation
-- @param openmw.core#GameObject actor Dead NPC in an active cell.
-- @param openmw.util#Vector3 velocity Initial corpse velocity if no ragdoll exists,
-- finite and length <=1000 game units/s. Ignored for an existing ragdoll.
-- @param openmw.util#Vector3 cutDirection Optional force direction; normalized by
-- the engine. Zero/missing means restore without launch or random spin.



---
-- List of currently active actors.
-- @field [parent=#world] openmw.core#ObjectList activeActors

---
-- List of players. Currently (since multiplayer is not yet implemented) always has one element.
-- @field [parent=#world] openmw.core#ObjectList players

---
-- Functions related to MWScript (see @{#MWScriptFunctions}).
-- @field [parent=#world] #MWScriptFunctions mwscript

---
-- Functions related to MWScript.
-- Calls that change MWScript state take effect after the current Lua update.
-- @type MWScriptFunctions

---
-- Variable names are case-insensitive.
-- @type MWScriptVariables
-- @map <#string, #number>

---
-- Returns the local MWScript on `object`, including when paused, or `nil` if it has not been initialized.
-- @function [parent=#MWScriptFunctions] getLocalScript
-- @param openmw.core#GameObject object
-- @param openmw.core#GameObject player (optional) Will be used in multiplayer mode to get the script if there is a separate instance for each player. Currently has no effect.
-- @return #MWScript, #nil

---
-- Runs the MWScript attached to `object` once, even if automatic execution is paused.
-- Uses the object's local variables and implicit reference without changing its paused state.
-- Works even if `getLocalScript` returns `nil`; the variables are initialized before the run.
-- @function [parent=#MWScriptFunctions] runLocalScript
-- @param openmw.core#GameObject object
-- @param openmw.core#GameObject player (optional) Will be used in multiplayer mode to select the player's instance of the script. Currently has no effect.
-- @return #boolean `false` if no attached script record exists; `true` if execution was queued.

---
-- Pauses automatic execution of the MWScript attached to `object` without clearing its variables.
-- The paused state persists across saves. Existing activation interception is unaffected.
-- @function [parent=#MWScriptFunctions] pauseLocalScript
-- @param openmw.core#GameObject object
-- @param openmw.core#GameObject player (optional) Will be used in multiplayer mode to select the player's instance of the script. Currently has no effect.
-- @return #boolean `false` if no attached script record exists; `true` if the change was queued.

---
-- Resumes automatic execution of the MWScript attached to `object` without resetting its variables.
-- The script runs only when the engine processes the object.
-- @function [parent=#MWScriptFunctions] resumeLocalScript
-- @param openmw.core#GameObject object
-- @param openmw.core#GameObject player (optional) Will be used in multiplayer mode to select the player's instance of the script. Currently has no effect.
-- @return #boolean `false` if no attached script record exists; `true` if the change was queued.

---
-- Returns mutable global variables. In multiplayer, these may be specific to the provided player.
-- @function [parent=#MWScriptFunctions] getGlobalVariables
-- @param openmw.core#GameObject player (optional) Will be used in multiplayer mode to get the globals if there is a separate instance for each player. Currently has no effect.
-- @return #MWScriptVariables

---
-- Returns the global MWScript with the given recordId, including when stopped, or `nil` if no instance exists.
-- Currently there can be only one instance of each mwscript, but in multiplayer it will be possible to have a separate instance per player.
-- @function [parent=#MWScriptFunctions] getGlobalScript
-- @param #string recordId
-- @param openmw.core#GameObject player (optional) Will be used in multiplayer mode to get the script if there is a separate instance for each player. Currently has no effect.
-- @return #MWScript, #nil

---
-- Starts a global MWScript with `target` as its implicit reference, if provided.
-- An already running script is not restarted or retargeted.
-- Works even if `getGlobalScript` returns `nil`; the instance is created when the start takes effect.
-- @function [parent=#MWScriptFunctions] startGlobalScript
-- @param #string recordId
-- @param openmw.core#GameObject target (optional) The script's implicit reference.
-- @param openmw.core#GameObject player (optional) Will be used in multiplayer mode to select the player's instance of the script. Currently has no effect.
-- @return #boolean `false` if the script record does not exist; `true` if the start was queued.

---
-- Stops a global MWScript without clearing its variables.
-- The stopped instance remains accessible through `getGlobalScript`.
-- @function [parent=#MWScriptFunctions] stopGlobalScript
-- @param #string recordId
-- @param openmw.core#GameObject player (optional) Will be used in multiplayer mode to select the player's instance of the script. Currently has no effect.
-- @return #boolean `false` if the script record does not exist; `true` if the stop was queued.

---
-- Runs a dialogue response's result script with `actor` as its implicit reference, without selecting the response.
-- Initializes the actor's attached MWScript variables, if any. Dialogue-dependent commands require the matching conversation and topic.
-- @function [parent=#MWScriptFunctions] runResultScript
-- @param openmw.core#DialogueRecordInfo info The response whose result script should run.
-- @param openmw.core#GameObject actor
-- @return #boolean `false` if the response has no result script; `true` if execution was queued.

---
-- @type MWScript
-- @field #string recordId Id of the script
-- @field openmw.core#GameObject object The script's implicit reference, or nil.
-- @field openmw.core#GameObject player The player the script refers to.
-- @field #boolean isRunning For local scripts, whether the object is scheduled for automatic execution and is not paused. For global scripts, whether the script is running.
-- @field #MWScriptVariables variables Local variables of the script (mutable)
-- @usage
-- local script = world.mwscript.getLocalScript(object)
-- if script then
--   print(script.recordId, script.isRunning)
-- end

---
-- Loads a named cell
-- @function [parent=#world] getCellByName
-- @param #string cellName
-- @return openmw.core#Cell

---
-- Loads a cell by ID provided
-- @function [parent=#world] getCellById
-- @param #string cellId
-- @return openmw.core#Cell

---
-- Loads an exterior cell by grid indices
-- @function [parent=#world] getExteriorCell
-- @param #number gridX
-- @param #number gridY
-- @param #any cellOrName (optional) other cell or cell name in the same exterior world space
-- @return openmw.core#Cell

---
-- List of all cells
-- @field [parent=#world] #list<openmw.core#Cell> cells
-- @usage for i, cell in ipairs(world.cells) do print(cell) end

---
-- Simulation time in seconds.
-- The number of simulation seconds passed in the game world since starting a new game.
-- @function [parent=#world] getSimulationTime
-- @return #number

---
-- The scale of simulation time relative to real time.
-- @function [parent=#world] getSimulationTimeScale
-- @return #number

---
-- Set the simulation time scale.
-- @function [parent=#world] setSimulationTimeScale
-- @param #number scale

---
-- Game time in seconds.
-- @function [parent=#world] getGameTime
-- @return #number

---
-- The scale of game time relative to simulation time.
-- @function [parent=#world] getGameTimeScale
-- @return #number

---
-- Set the ratio of game time speed to simulation time speed.
-- @function [parent=#world] setGameTimeScale
-- @param #number ratio

---
-- Whether the world is paused.
-- @function [parent=#world] isWorldPaused
-- @return #boolean

---
-- Pause the game starting from the next frame.
-- @function [parent=#world] pause
-- @param #string tag (optional, empty string by default) The game will be paused until `unpause` is called with the same tag.

---
-- Remove the given tag from the list of pause tags. Resume the game starting from the next frame if the list became empty.
-- @function [parent=#world] unpause
-- @param #string tag (optional, empty string by default) Needed to undo `pause` called with this tag.

---
-- The tags that are currently pausing the game.
-- @function [parent=#world] getPausedTags
-- @return #table

---
-- Find all objects within a given range of a world position
-- @function [parent=#world] getObjectsInRange
-- @param openmw.util#Vector3 position The world position
-- @param #number range The range
-- @return #list<openmw.core#GameObject>

---
-- Return an object by RefNum/FormId.
-- Note: the function always returns @{openmw.core#GameObject} and doesn't validate that
-- the object exists in the game world. If it doesn't exist or not yet loaded to memory),
-- then `obj:isValid()` will be `false`.
-- @function [parent=#world] getObjectByFormId
-- @param #string formId String returned by `core.getFormId`
-- @return openmw.core#GameObject
-- @usage local obj = world.getObjectByFormId(core.getFormId('Morrowind.esm', 128964))

---
-- Returns all objects with the given record ID.
-- Note: Searching all world spaces or a large world space can impact performance.
-- @function [parent=#world] getObjectsByRecordId
-- @param #string recordId Record ID
-- @param #string worldSpaceId (Optional) ID of the world space to search. (Note that an interior cell's world space ID is its ID and that the ESM3 exterior world space's ID is `sys::default`.)
-- @param #bool loadedOnly (Optional) When true, only cells that have previously been loaded are searched.
-- @return list<openmw.core#GameObject>
-- @usage for _, object in pairs(world.getObjectsByRecordId('TempleMarker', world.players[1].cell.worldSpaceId)) do
--   print(object.cell.name)
-- end

---
-- Create a new instance of the given record.
-- After creation the object is in the disabled state. Use :teleport to place to the world or :moveInto to put it into a container or an inventory.
-- Note that dynamically created creatures, NPCs, and container inventories will not respawn.
-- @function [parent=#world] createObject
-- @param #string recordId Record ID. String ids that came from ESM3 content files are lower-cased. If another ID is provided, it must be provided exactly as it is, case sensitive.
-- @param #number count (optional, 1 by default) The number of objects in stack
-- @return openmw.core#GameObject
-- @usage  -- put 100 gold on the ground at the position of `actor`
-- money = world.createObject('gold_001', 100)
-- money:teleport(actor.cell.name, actor.position)
-- @usage -- put 50 gold into the actor's inventory
-- money = world.createObject('gold_001', 50)
-- money:moveInto(types.Actor.inventory(actor))
-- @usage -- create the an object for the first generated item
-- potion = world.createObject('Generated:0x0', 1)

---
-- Creates a custom record in the world database; string IDs that came from ESM3 content files are lower-cased.
-- Eventually meant to support all records, but the current
-- set of supported types is limited to:
--
-- * @{openmw.types#ActivatorRecord},
-- * @{openmw.types#ArmorRecord},
-- * @{openmw.types#BookRecord},
-- * @{openmw.types#ClothingRecord},
-- * @{openmw.types#ContainerRecord},
-- * @{openmw.types#CreatureLevelledListRecord},
-- * @{openmw.types#CreatureRecord},
-- * @{openmw.types#DoorRecord},
-- * @{openmw.core#Enchantment},
-- * @{openmw.types#IngredientRecord},
-- * @{openmw.types#ItemLevelledListRecord},
-- * @{openmw.types#LightRecord},
-- * @{openmw.types#MiscellaneousRecord},
-- * @{openmw.types#NpcRecord},
-- * @{openmw.types#PotionRecord},
-- * @{openmw.types#ProbeRecord},
-- * @{openmw.core#Spell},
-- * @{openmw.types#StaticRecord},
-- * @{openmw.types#WeaponRecord}
-- @function [parent=#world] createRecord
-- @param #any record A record to be registered in the database. Must be one of the supported types. The id field is not used, one will be generated for you.
-- @return #any A new record added to the database. The type is the same as the input's.

--- @{#VFX}: Visual effects
-- @field [parent=#world] #VFX vfx

---
-- Spawn a VFX at the given location in the world. Best invoked through the SpawnVfx global event
-- @function [parent=#VFX] spawn
-- @param #string model string model path (normally taken from a record such as @{openmw.types#StaticRecord.model} or similar)
-- @param openmw.util#Vector3 position
-- @param #table options optional table of parameters. Can contain:
--
--   * `mwMagicVfx` - Boolean that if true causes the textureOverride parameter to only affect nodes with the Nif::RC_NiTexturingProperty property set. (default: true).
--   * `particleTextureOverride` - Name of a particle texture that should override this effect's default texture. (default: "")
--   * `scale` - A number that scales the size of the vfx (Default: 1)
--   * `useAmbientLight` - boolean, vfx get a white ambient light attached in Morrowind. If false don't attach this. (default: true)
--   * `loop` - boolean, if true the effect will loop until removed (default: false).
--   * `vfxId` - a string ID that can be used to remove the effect later, using @{#VFX.remove}. (Default: "").
--
-- @usage -- Spawn a sanctuary effect near the player
-- local effect = core.magic.effects.records[core.magic.EFFECT_TYPE.Sanctuary]
-- local pos = self.position + util.vector3(0, 100, 0)
-- local model = types.Static.records[effect.castStatic].model
-- core.sendGlobalEvent('SpawnVfx', {model = model, position = pos, options = { useAmbientLight = false, vfxId = "myVfx" }})
--

---
-- Remove all VFX with the given vfxId. Best invoked through the RemoveVfx global event
-- @function [parent=#VFX] remove
-- @param #string vfxId the vfxId of the VFX to remove. Passing an empty string removes all VFX that don't have a vfxId (this includes non-scripted VFX!)
--
-- @usage -- Remove all VFX with vfxId "myvfx"
-- core.sendGlobalEvent('RemoveVfx', "myvfx")
--

---
-- Advance the world time by a certain number of hours. This advances time, weather, and AI, but does not perform other functions associated with the passage of time, e.g., regeneration.
-- @function [parent=#world] advanceTime
-- @param #number hours Number of hours to advance time

return nil
