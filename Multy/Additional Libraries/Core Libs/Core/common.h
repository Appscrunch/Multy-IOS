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

/** Binary data, just a pointer and a size in bytes. */
struct BinaryData
{
    const unsigned char* data;
    size_t len;
};

struct Version
{
    size_t major;
    size_t minor;
    size_t build;
    const char* note;  /// can be null
    const char* commit; /// can be null
};

MULTY_CORE_API struct Error* get_version(struct Version* version);

/** Generates a version string from version object.
 * @param version_string - out, version string, must be freed with free_string().
 * @return Error on error, nullptr otherwise.
 */
MULTY_CORE_API struct Error* make_version_string(const char** out_version_string);

/** Frees BinaryData, can take null. **/
MULTY_CORE_API void free_binarydata(struct BinaryData*);

/** Create new BinaryData with data of given size, data is zeroed. **/
MULTY_CORE_API struct Error* make_binary_data(
        size_t size, struct BinaryData** new_binary_data);

MULTY_CORE_API struct Error* make_binary_data_from_bytes(
        const unsigned char* data, size_t size,
        struct BinaryData** new_binary_data);

MULTY_CORE_API struct Error* make_binary_data_from_hex(
        const char* hex_str, struct BinaryData** new_binary_data);

/** Copies BinaryData. **/
MULTY_CORE_API struct Error* make_binary_data(
        size_t size, struct BinaryData** new_binary_data);

MULTY_CORE_API struct Error* make_binary_data_from_bytes(
        const unsigned char* data, size_t size,
        struct BinaryData** new_binary_data);

MULTY_CORE_API struct Error* make_binary_data_from_hex(
        const char* hex_str, struct BinaryData** new_binary_data);

/** Copies BinaryData. **/
MULTY_CORE_API struct Error* binary_data_clone(
        const struct BinaryData* source, struct BinaryData** new_binary_data);

/** Frees a string, can take null. **/
MULTY_CORE_API void free_string(const char* str);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* MULTY_CORE_COMMON_H */
