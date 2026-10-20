/* nhvhooks.h - NetHack Voxel hooks into the core.
 *
 * In free-movement mode monsters and the hero have continuous positions
 * owned by the host (the 3D engine). NetHack still makes every decision
 * (attacks, spells, item use, fleeing...) and rolls all the dice, but:
 *  - monsters don't step around the grid on their own (the host moves
 *    them and reports square changes with nhv_mon_step());
 *  - "is the monster next to you" comes from the host's real distance;
 *  - the hero moves between squares without using time; time passes
 *    through explicit ticks (#nhvtick) and actions.
 * The hooks are implemented in nhcore (nhv_free.c).
 */
#ifndef NHVHOOKS_H
#define NHVHOOKS_H

#ifdef NHV_FREEMOVE
extern boolean nhv_freemove;
/* 1 = host says mtmp can reach the hero in melee, 0 = no, -1 = unknown */
extern int nhv_mon_in_reach(struct monst *);
/* monster the host wants mtmp (a pet, or a confused/conflicted monster)
   to fight this turn, if it is within reach */
extern struct monst *nhv_mon_melee_target(struct monst *);
/* monsters that keep NetHack's own grid movement (shopkeepers, ...) */
extern boolean nhv_grid_mover(struct monst *);
/* monmove.c: move mtmp one square as its own movement would */
extern int nhv_mon_step(struct monst *, coordxy, coordxy);
extern boolean nhv_mon_keeps_distance(struct monst *);
/* combat feedback for the host: kind "attack", attacker, target (0 =
   hero), melee (attacker can reach the target) */
extern void nhv_combat_event(const char *, unsigned, unsigned, int);
/* quest message about to be shown (nhv_sound.c) */
extern void nhv_quest_event(const char *, const char *);
/* extended commands used by the host */
extern int donhvmove(void);
extern int donhvpass(void);
/* the hero's body is down in the pit on its square (#nhvpit 1/0): it can
   reach the bottom, though not trapped there */
extern boolean nhv_in_pit;
extern int donhvpit(void);
/* wizard mode's invulnerability (VoxHack's noclip): no damage, no death */
extern boolean nhv_godmode;
extern int donhvgod(void);
/* the hero's body is walking from square to square (#nhvmove, #nhvpass):
   entering a trap's square doesn't set it off - the host says when the
   body touches the trap (#nhvtrap); a pit, a real hole, still does */
extern boolean nhv_walking;
extern int donhvtrap(void);
extern int donhvtick(void);
/* a seeded game (rnd.c; set by the host before the game starts) */
extern unsigned long nhv_fixed_seed;
/* #nhvgoto dnum dlevel: go to that level (debug mode; the level atlas) */
extern int donhvgoto(void);
/* the hero is helpless this turn: wait for the host's clock (nhv_win.c) */
extern void nhv_helpless_turn(void);
extern int donhvattack(void);
/* #nhvpole id: apply the wielded polearm / lance at that monster (apply.c's
   use_pole, aimed at nhv_pole_x, nhv_pole_y instead of asking) */
extern int donhvpole(void);
extern coordxy nhv_pole_x, nhv_pole_y;
extern int donhvmhit(void);
extern int donhvmhitm(void);
extern int donhvmland(void);
/* missiles (mthrowu.c / nhv_free.c) */
extern void nhv_missile_launch(struct monst *, struct obj *, coordxy, coordxy,
                               int);
extern boolean nhv_missile_lined_up(struct monst *);
extern int nhv_missile_hits_hero(struct monst *, struct obj *, coordxy,
                                 coordxy);
extern boolean nhv_missile_hits_mon(struct monst *, struct obj *, int);
extern void nhv_missile_lands(struct obj *, coordxy, coordxy);
/* rays (zap.c / nhv_free.c) */
extern void nhv_ray_launch(int, int, coordxy, coordxy, int, int, int, boolean,
                           boolean, boolean, unsigned);
extern int nhv_ray_hits_mon(int, int, struct monst *, boolean, boolean,
                            boolean);
extern int nhv_ray_hits_hero(int, int, int, int, boolean);
extern void nhv_ray_square(int, coordxy, coordxy, boolean *);
extern void nhv_ray_end(int, coordxy, coordxy, boolean);
extern int donhvrayhit(void);
extern int donhvraysq(void);
extern int donhvrayend(void);
/* containers in the host's panel (pickup.c / nhv_free.c) */
extern int nhv_cmd_args[];
extern struct obj *nhv_find_container(unsigned);
extern void nhv_container_event(const char *, unsigned);
extern int donhvloot(void);
extern int donhvcontin(void);
extern int donhvcontout(void);
extern int donhvhurt(void);
extern int donhvspike(void);
extern int donhvopt(void);
extern int donhvkickhere(void);
extern int donhvlook(void);
/* an immediate beam (force bolt, striking, dig...) the hero zapped, from
   <x0,y0> to where it ended, for the host to draw (nhv_free.c) */
extern void nhv_beam_event(int, int, int, int, int);
extern void nhv_throw_event(int, int, int, int, int);
/* a boulder rolled (rolling boulder trap): glyph, from, to, used up */
extern void nhv_roll_event(int, int, int, int, int, int);
/* an explosion at <x,y> of a type (EXPL_FIERY...) the hero can see */
extern void nhv_explode_event(int, int, int);
extern coordxy nhv_beam_x, nhv_beam_y; /* last square zap_dig reached */
/* aiming: #nhvaim dx dy (thousandths) gives the exact line the host's
   crosshair points along; the next command's thrown objects and beams
   follow it (any angle) instead of NetHack's 8 directions; digging
   keeps NetHack's own directions */
extern int donhvaim(void);
extern void nhv_aim_tick(void);
extern int nhv_aim_path(coordxy, coordxy, int, int, coordxy *, coordxy *, int);
/* special levels: the variant built and its fixed regions (a level file's
   drawn maps, and its rooms with a fixed place and size), reported to the
   host so it can build them from hand-made area prefabs (nhv_free.c) */
extern void nhv_splev_begin(const char *);
extern void nhv_splev_region(int, int, int, int);
extern void nhv_splev_end(void);
/* ... and how it was flipped once built (flip_level: mask, level extents) */
extern void nhv_splev_flip(int, int, int, int, int);
extern int donhvsplevdump(void);
#endif

/* sound hook: an event the sound configuration can attach a sound to */
#ifdef NHV_FREEMOVE
extern void nhv_sound_hook(const char *);
extern void nhv_trap_hook(int);
#define NHV_HOOK(id) nhv_sound_hook(id)
#else
#define NHV_HOOK(id) ((void) 0)
#endif

/* where a sound happens, so the host plays it from there: at a square or
   at a monster (its m_id lets the host follow the monster's own model).
   Used by the next sound only, this turn (nhv_sound.c); a sound on the
   hero's own square stays centred on the hero. */
#ifdef NHV_FREEMOVE
extern void nhv_sound_at(coordxy, coordxy, unsigned);
#define NHV_HOOK_AT(id, x, y) (nhv_sound_at((x), (y), 0), nhv_sound_hook(id))
#define NHV_HOOK_MON(id, m) \
    (nhv_sound_at((m)->mx, (m)->my, (m)->m_id), nhv_sound_hook(id))
#define SoundeffectAt(seid, vol, x, y) \
    do {                               \
        nhv_sound_at((x), (y), 0);     \
        Soundeffect((seid), (vol));    \
    } while (0)
#define SoundeffectMon(seid, vol, m)               \
    do {                                           \
        nhv_sound_at((m)->mx, (m)->my, (m)->m_id); \
        Soundeffect((seid), (vol));                \
    } while (0)
#else
#define NHV_HOOK_AT(id, x, y) ((void) 0)
#define NHV_HOOK_MON(id, m) ((void) 0)
#define SoundeffectAt(seid, vol, x, y) Soundeffect((seid), (vol))
#define SoundeffectMon(seid, vol, m) Soundeffect((seid), (vol))
#endif

#endif /* NHVHOOKS_H */
