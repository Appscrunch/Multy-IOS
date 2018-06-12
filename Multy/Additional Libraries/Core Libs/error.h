/* Copyright 2018 by Multy.io
 * Licensed under Multy.io license.
 *
 * See LICENSE for details
 */

#ifndef MULTY_CORE_ERROR_H
#define MULTY_CORE_ERROR_H

#include "api.h"

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

enum ErrorCode
{
    ERROR_INTERNAL,
    ERROR_INVALID_ARGUMENT,
    ERROR_OUT_OF_MEMORY,
    ERROR_GENERAL_ERROR,
    ERROR_BAD_ENTROPY,
    ERROR_FEATURE_NOT_SUPPORTED,
    ERROR_FEATURE_NOT_IMPLEMENTED_YET
};

struct CodeLocation
{
    const char* file;
    int line;
};

/** Error
 * Holds information about error occured inside library.
 */
struct MultyError
{
    enum ErrorCode code;
    const char* message;
    bool owns_message;

    // Points to the location in code where error occured.
    struct CodeLocation location;

    const char* backtrace;
};

/** Allocates Error object, assumes that message is satic and shouldn't be copied. **/
MULTY_CORE_API struct Error* make_error(enum ErrorCode code, const char* message, struct CodeLocation location);
MULTY_CORE_API struct Error* make_error_with_backtrace(enum ErrorCode code, const char* message, struct CodeLocation location, const char* backtrace);

/** Frees Error object, can take nullptr. **/
MULTY_CORE_API void free_error(struct Error* error);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* MULTY_CORE_ERROR_H */
