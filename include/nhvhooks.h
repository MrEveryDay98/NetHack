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
extern int donhvtick(void);
extern int donhvattack(void);
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
#endif

/* sound hook: an event the sound configuration can attach a sound to */
#ifdef NHV_FREEMOVE
extern void nhv_sound_hook(const char *);
extern void nhv_trap_hook(int);
#define NHV_HOOK(id) nhv_sound_hook(id)
#else
#define NHV_HOOK(id) ((void) 0)
#endif

#endif /* NHVHOOKS_H */
