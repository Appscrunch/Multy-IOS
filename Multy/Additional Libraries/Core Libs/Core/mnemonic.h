/* Copyright 2017 by Multy.io
 * Licensed under Multy.io license.
 *
 * See LICENSE for details
 */

#ifndef MULTY_CORE_MNEMONIC_H
#define MULTY_CORE_MNEMONIC_H

#include "api.h"
#include "common.h"

#include <stddef.h>
#include <stdint.h>

/** Exposing bare C interface to the users.
 * That greatly simplifies integration with any language/paltform.
 */
#ifdef __cplusplus
extern "C" {
#endif

struct Error;
struct BinayData;

/** Generator interface.
 * Each function returns a pointer to a GeneratorError, which is null on no
 * error.
 * User must free returned value with `free_error`.
 *
 * Incoming pointers are not freed under no circumstances, with exception of
 * free_X(X*) functions, which do de-allocate given objects.
 * Please do not use those functions to free any object not created
 * by the Generator.
  */

/** Generate a mnemonic for given amount of entropy using default dictionary
 *(english).
 *
 * @param entropy_source - bytes of entropy.
 * @param [out]mnemonic - resulting mnemonic, a null-terminated, space-separated
 *	list of words from dictionary.
 */
MULTY_CORE_API struct Error* make_mnemonic(
        struct EntropySource entropy_source, const char** mnemonic);

/** Generates a pseudo-random seed from given mnemonic and password.
 * @param mnemonic - space-separated list of mnemonic words.
 * @param password - password, optional, can be null if not set.
 * @param [out]seed - resulting pseudo-random seed.
 */
MULTY_CORE_API struct Error* make_seed(
        const char* mnemonic, const char* password, struct BinaryData** seed);
MULTY_CORE_API struct Error* seed_to_string(const struct BinaryData* seed, const char** str);

/** Frees mnemonic, can take null */
MULTY_CORE_API void free_mnemonic(const char* mnemonic);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // MULTY_CORE_MNEMONIC_H
