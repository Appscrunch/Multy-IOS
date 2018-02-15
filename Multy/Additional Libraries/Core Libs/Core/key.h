/* Copyright 2018 by Multy.io
 * Licensed under Multy.io license.
 *
 * See LICENSE for details
 */

#ifndef MULTY_CORE_KEYS_H
#define MULTY_CORE_KEYS_H

#include "api.h"

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

struct Key;
struct ExtendedKey;
struct PrivateKey;
struct PublicKey;

struct Error;
struct BinaryData;

MULTY_CORE_API struct Error* make_master_key(
        const struct BinaryData* seed, struct ExtendedKey** new_master_key);

MULTY_CORE_API struct Error* make_key_id(
        const struct ExtendedKey* key,
        const char** out_key_id);

/** Make child key from parent key, see BIP32 for key derivation and HD
 * accounts.
 * @param parent_key - parent key.
 * @param chain_code - 0 to 0x80000000
 * @param new_child_key - resulting child key, must be freed by caller with
 * free_key().
 */
MULTY_CORE_API struct Error* make_child_key(
        const struct ExtendedKey* parent_key,
        uint32_t chain_code,
        struct ExtendedKey** new_child_key);

/** Serialize the key to string.
 * @param key - key to serialize;
 * @param new_str - serialized key string, must be freed by caller with
 * free_string().
 */
MULTY_CORE_API struct Error* extended_key_to_string(
        const struct ExtendedKey* extended_key, const char** new_str);

/** Here and below, a Key* is either PrivateKey* or PublicKey*
 *  but NOT ExtendedKey*.
 */

/** Serialize the key to string.
 * @param key - key to serialize;
 * @param new_str - serialized key string, must be freed by caller with
 * free_string().
 */
MULTY_CORE_API struct Error* key_to_string(
        const struct Key* key, const char** new_str);

/*
MULTY_CORE_API struct Error* sign_with_key(
    const struct Key** key, const struct BinaryData* data, struct
    BinaryData** new_signature);

MULTY_CORE_API struct Error* encrypt_with_key(
    const struct Key** key,
    const struct BinaryData* data,
    struct BinaryData** new_encrypted_data);

MULTY_CORE_API struct Error* decrypt_with_key(
    const struct Key** key,
    const struct BinaryData* data,
    struct BinaryData** new_decrypted_data);
*/

/** Frees ExtendedKey instance, can take nullptr. **/
MULTY_CORE_API void free_extended_key(struct ExtendedKey* root);

/** Frees struct Key* instance, can take nullptr. **/
MULTY_CORE_API void free_key(struct Key* root);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* MULTY_CORE_KEYS_H */
