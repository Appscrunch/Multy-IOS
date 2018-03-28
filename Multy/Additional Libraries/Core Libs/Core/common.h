/* Copyright 2018 by Multy.io
 * Licensed under Multy.io license.
 *
 * See LICENSE for details
 */

#ifndef MULTY_CORE_COMMON_H
#define MULTY_CORE_COMMON_H

#include "api.h"

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

struct Error;

/** Entropy generator interface.
 * Fill `dest` with `size` random bytes.
 * Caller ensures that `dest` has enough space.
 * Implementation should return 0 on error, or size of generated entropy.
 */
struct EntropySource
{
    void* data; /** Opaque caller-supplied pointer, passed as first argument to
                 fill_entropy(). **/
    size_t (*fill_entropy)(void* data, size_t size, void* dest);
};

struct Version
{
    size_t major;
    size_t minor;
    size_t build;
    const char* note;  /// can be null, MUST NOT be freed by caller.
    const char* commit; /// can be null, MUST NOT be freed by caller.
};

MULTY_CORE_API struct Error* get_version(struct Version* version);

/** Generates a version string from version object.
 * @param version_string - out, version string, must be freed with free_string().
 * @return Error on error, nullptr otherwise.
 */
MULTY_CORE_API struct Error* make_version_string(const char** out_version_string);

/** Frees a string, can take null. **/
MULTY_CORE_API void free_string(const char* str);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* MULTY_CORE_COMMON_H */
