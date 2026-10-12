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
/* extended commands used by the host */
extern int donhvmove(void);
extern int donhvtick(void);
extern int donhvattack(void);
#endif

#endif /* NHVHOOKS_H */
