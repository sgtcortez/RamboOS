#ifndef __SCREEN_H__
#define __SCREEN_H__

/**
 * Source code used to print text to video(Video Graphics Array - VGA)
 * https://wiki.osdev.org/Printing_To_Screen
 */

/**
 * Clears the screen, and reset the cursor to
 * the initial position
 */
void clear_screen(void);

/**
 * Prints a string starting at the desired row and cell
 */
void print_at(char *, int, unsigned int, unsigned int);

#endif
