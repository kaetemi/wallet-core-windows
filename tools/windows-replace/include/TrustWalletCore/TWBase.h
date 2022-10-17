// Copyright © 2017-2020 Trust Wallet.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#if !defined(TW_EXTERN_C_BEGIN)
#if defined(__cplusplus)
#define TW_EXTERN_C_BEGIN extern "C" {
#define TW_EXTERN_C_END   }
#else
#define TW_EXTERN_C_BEGIN
#define TW_EXTERN_C_END
#endif
#endif

#ifdef _WIN32
#ifdef TW_STATIC_LIBRARY
#define TW_EXTERN
#else
#ifdef TW_EXPORT_LIBRARY
#define TW_EXTERN __declspec(dllexport)
#else
#define TW_EXTERN __declspec(dllimport)
#endif
#endif
#else
#define TW_EXTERN extern
#endif

// Marker for default visibility
#ifdef _MSC_VER
	#define TW_VISIBILITY_DEFAULT
#else
	#define TW_VISIBILITY_DEFAULT __attribute__((visibility("default")))
#endif

// Marker for exported classes
#define TW_EXPORT_CLASS

// Marker for exported structs
#define TW_EXPORT_STRUCT

// Marker for exported enums
#define TW_EXPORT_ENUM(...)

// Marker for exported functions
#define TW_EXPORT_FUNC TW_EXTERN

// Marker for exported methods
#define TW_EXPORT_METHOD TW_EXTERN

// Marker for exported properties
#define TW_EXPORT_PROPERTY TW_EXTERN

// Marker for exported static methods
#define TW_EXPORT_STATIC_METHOD TW_EXTERN

// Marker for exported static properties
#define TW_EXPORT_STATIC_PROPERTY TW_EXTERN

// Marker for discardable result (static) method
#define TW_METHOD_DISCARDABLE_RESULT

// Marker for Protobuf types to be serialized across the interface
#define PROTO(x) TWData *

#ifdef _MSC_VER
#define TW_HAS_FEATURE(feature) 0
#else
#define TW_HAS_FEATURE(feature) __has_feature(feature)
#endif

#if TW_HAS_FEATURE(assume_nonnull)
#define TW_ASSUME_NONNULL_BEGIN _Pragma("clang assume_nonnull begin")
#define TW_ASSUME_NONNULL_END   _Pragma("clang assume_nonnull end")
#else
#define TW_ASSUME_NONNULL_BEGIN
#define TW_ASSUME_NONNULL_END
#endif


#if !TW_HAS_FEATURE(nullability)
#ifndef _Nullable
#define _Nullable
#endif
#ifndef _Nonnull
#define _Nonnull
#endif
#ifndef _Null_unspecified
#define _Null_unspecified
#endif
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

