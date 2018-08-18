//
//  TYZImageCoder.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZImageCoder.h"
#import <CoreFoundation/CoreFoundation.h>
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>
#import <pthread.h>
#import <zlib.h>
#import "TYZImage.h"
#import "TYZKitMacro.h"


#ifndef TYZIMAGE_WEBP_ENABLED
#if __has_include(<webp/decode.h>) && __has_include(<webp/encode.h>) && \
__has_include(<webp/demux.h>)  && __has_include(<webp/mux.h>)
#define TYZIMAGE_WEBP_ENABLED 1
#import <webp/decode.h>
#import <webp/encode.h>
#import <webp/demux.h>
#import <webp/mux.h>
#elif __has_include("webp/decode.h") && __has_include("webp/encode.h") && \
__has_include("webp/demux.h")  && __has_include("webp/mux.h")
#define TYZIMAGE_WEBP_ENABLED 1
#import "webp/decode.h"
#import "webp/encode.h"
#import "webp/demux.h"
#import "webp/mux.h"
#else
#define TYZIMAGE_WEBP_ENABLED 0
#endif
#endif

#pragma mark Utility (for little endian platform) 小端字节平台
#define TYZ_FOUR_CC(c1, c2, c3, c4) ((uint32_t)(((c4) << 24) | ((c3) << 16) | ((c2) << 8) | (c1)))
#define TYZ_TWO_CC(c1, c2) ((uint16_t)(((c2) << 8) | (c1)))

static inline uint16_t tyz_swap_endian_uint16(uint16_t value)
{
    return
    (uint16_t) ((value & 0x00FF) << 8) |
    (uint16_t) ((value & 0xFF00) >> 8) ;
}

static inline uint32_t tyz_swap_endian_uint32(uint32_t value)
{
    return
    (uint32_t)((value & 0x000000FFU) << 24) |
    (uint32_t)((value & 0x0000FF00U) <<  8) |
    (uint32_t)((value & 0x00FF0000U) >>  8) |
    (uint32_t)((value & 0xFF000000U) >> 24) ;
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - APNG

/*
 PNG  spec: http://www.libpng.org/pub/png/spec/1.2/PNG-Structure.html
 APNG spec: https://wiki.mozilla.org/APNG_Specification
 
 ===============================================================================
 PNG format:
 header (8): 89 50 4e 47 0d 0a 1a 0a
 chunk, chunk, chunk, ...
 
 ===============================================================================
 chunk format:
 length (4): uint32_t big endian
 fourcc (4): chunk type code
 data   (length): data
 crc32  (4): uint32_t big endian crc32(fourcc + data)
 
 ===============================================================================
 PNG chunk define:
 
 IHDR (Image Header) required, must appear first, 13 bytes
 width              (4) pixel count, should not be zero
 height             (4) pixel count, should not be zero
 bit depth          (1) expected: 1, 2, 4, 8, 16
 color type         (1) 1<<0 (palette used), 1<<1 (color used), 1<<2 (alpha channel used)
 compression method (1) 0 (deflate/inflate)
 filter method      (1) 0 (adaptive filtering with five basic filter types)
 interlace method   (1) 0 (no interlace) or 1 (Adam7 interlace)
 
 IDAT (Image Data) required, must appear consecutively if there's multiple 'IDAT' chunk
 
 IEND (End) required, must appear last, 0 bytes
 
 ===============================================================================
 APNG chunk define:
 
 acTL (Animation Control) required, must appear before 'IDAT', 8 bytes
 num frames     (4) number of frames
 num plays      (4) number of times to loop, 0 indicates infinite looping
 
 fcTL (Frame Control) required, must appear before the 'IDAT' or 'fdAT' chunks of the frame to which it applies, 26 bytes
 sequence number   (4) sequence number of the animation chunk, starting from 0
 width             (4) width of the following frame
 height            (4) height of the following frame
 x offset          (4) x position at which to render the following frame
 y offset          (4) y position at which to render the following frame
 delay num         (2) frame delay fraction numerator
 delay den         (2) frame delay fraction denominator
 dispose op        (1) type of frame area disposal to be done after rendering this frame (0:none, 1:background 2:previous)
 blend op          (1) type of frame area rendering for this frame (0:source, 1:over)
 
 fdAT (Frame Data) required
 sequence number   (4) sequence number of the animation chunk
 frame data        (x) frame data for this frame (same as 'IDAT')
 
 ===============================================================================
 `dispose_op` specifies how the output buffer should be changed at the end of the delay
 (before rendering the next frame).
 
 * NONE: no disposal is done on this frame before rendering the next; the contents
 of the output buffer are left as is.
 * BACKGROUND: the frame's region of the output buffer is to be cleared to fully
 transparent black before rendering the next frame.
 * PREVIOUS: the frame's region of the output buffer is to be reverted to the previous
 contents before rendering the next frame.
 
 `blend_op` specifies whether the frame is to be alpha blended into the current output buffer
 content, or whether it should completely replace its region in the output buffer.
 
 * SOURCE: all color components of the frame, including alpha, overwrite the current contents
 of the frame's output buffer region.
 * OVER: the frame should be composited onto the output buffer based on its alpha,
 using a simple OVER operation as described in the "Alpha Channel Processing" section
 of the PNG specification
 */

typedef enum {
    TYZ_PNG_ALPHA_TYPE_PALEETE = 1 << 0,
    TYZ_PNG_ALPHA_TYPE_COLOR = 1 << 1,
    TYZ_PNG_ALPHA_TYPE_ALPHA = 1 << 2,
} tyz_png_alpha_type;

typedef enum {
    TYZ_PNG_DISPOSE_OP_NONE = 0,
    TYZ_PNG_DISPOSE_OP_BACKGROUND = 1,
    TYZ_PNG_DISPOSE_OP_PREVIOUS = 2,
} tyz_png_dispose_op;

typedef enum {
    TYZ_PNG_BLEND_OP_SOURCE = 0,
    TYZ_PNG_BLEND_OP_OVER = 1,
} tyz_png_blend_op;

typedef struct
{
    uint32_t width;             ///< pixel count, should not be zero
    uint32_t height;            ///< pixel count, should not be zero
    uint8_t bit_depth;          ///< expected: 1, 2, 4, 8, 16
    uint8_t color_type;         ///< see TYZ_png_alpha_type
    uint8_t compression_method; ///< 0 (deflate/inflate)
    uint8_t filter_method;      ///< 0 (adaptive filtering with five basic filter types)
    uint8_t interlace_method;   ///< 0 (no interlace) or 1 (Adam7 interlace)
} tyz_png_chunk_IHDR;

typedef struct
{
    uint32_t sequence_number;  ///< sequence number of the animation chunk, starting from 0
    uint32_t width;            ///< width of the following frame
    uint32_t height;           ///< height of the following frame
    uint32_t x_offset;         ///< x position at which to render the following frame
    uint32_t y_offset;         ///< y position at which to render the following frame
    uint16_t delay_num;        ///< frame delay fraction numerator
    uint16_t delay_den;        ///< frame delay fraction denominator
    uint8_t dispose_op;        ///< see TYZ_png_dispose_op
    uint8_t blend_op;          ///< see TYZ_png_blend_op
} tyz_png_chunk_fcTL;

typedef struct
{
    uint32_t offset; ///< chunk offset in PNG data
    uint32_t fourcc; ///< chunk fourcc
    uint32_t length; ///< chunk data length
    uint32_t crc32;  ///< chunk crc32
} tyz_png_chunk_info;

typedef struct
{
    uint32_t chunk_index; ///< the first `fdAT`/`IDAT` chunk index
    uint32_t chunk_num;   ///< the `fdAT`/`IDAT` chunk count
    uint32_t chunk_size;  ///< the `fdAT`/`IDAT` chunk bytes
    tyz_png_chunk_fcTL frame_control;
} tyz_png_frame_info;

typedef struct
{
    tyz_png_chunk_IHDR header;   ///< png header
    tyz_png_chunk_info *chunks;      ///< chunks
    uint32_t chunk_num;          ///< count of chunks
    
    tyz_png_frame_info *apng_frames; ///< frame info, NULL if not apng
    uint32_t apng_frame_num;     ///< 0 if not apng
    uint32_t apng_loop_num;      ///< 0 indicates infinite looping
    
    uint32_t *apng_shared_chunk_indexs; ///< shared chunk index
    uint32_t apng_shared_chunk_num;     ///< shared chunk count
    uint32_t apng_shared_chunk_size;    ///< shared chunk bytes
    uint32_t apng_shared_insert_index;  ///< shared chunk insert index
    bool apng_first_frame_is_cover;     ///< the first frame is same as png (cover)
} tyz_png_info;

static void tyz_png_chunk_IHDR_read(tyz_png_chunk_IHDR *IHDR, const uint8_t *data) {
    IHDR->width = tyz_swap_endian_uint32(*((uint32_t *)(data)));
    IHDR->height = tyz_swap_endian_uint32(*((uint32_t *)(data + 4)));
    IHDR->bit_depth = data[8];
    IHDR->color_type = data[9];
    IHDR->compression_method = data[10];
    IHDR->filter_method = data[11];
    IHDR->interlace_method = data[12];
}

static void tyz_png_chunk_IHDR_write(tyz_png_chunk_IHDR *IHDR, uint8_t *data)
{
    *((uint32_t *)(data)) = tyz_swap_endian_uint32(IHDR->width);
    *((uint32_t *)(data + 4)) = tyz_swap_endian_uint32(IHDR->height);
    data[8] = IHDR->bit_depth;
    data[9] = IHDR->color_type;
    data[10] = IHDR->compression_method;
    data[11] = IHDR->filter_method;
    data[12] = IHDR->interlace_method;
}

static void tyz_png_chunk_fcTL_read(tyz_png_chunk_fcTL *fcTL, const uint8_t *data)
{
    fcTL->sequence_number = tyz_swap_endian_uint32(*((uint32_t *)(data)));
    fcTL->width = tyz_swap_endian_uint32(*((uint32_t *)(data + 4)));
    fcTL->height = tyz_swap_endian_uint32(*((uint32_t *)(data + 8)));
    fcTL->x_offset = tyz_swap_endian_uint32(*((uint32_t *)(data + 12)));
    fcTL->y_offset = tyz_swap_endian_uint32(*((uint32_t *)(data + 16)));
    fcTL->delay_num = tyz_swap_endian_uint16(*((uint16_t *)(data + 20)));
    fcTL->delay_den = tyz_swap_endian_uint16(*((uint16_t *)(data + 22)));
    fcTL->dispose_op = data[24];
    fcTL->blend_op = data[25];
}

static void tyz_png_chunk_fcTL_write(tyz_png_chunk_fcTL *fcTL, uint8_t *data)
{
    *((uint32_t *)(data)) = tyz_swap_endian_uint32(fcTL->sequence_number);
    *((uint32_t *)(data + 4)) = tyz_swap_endian_uint32(fcTL->width);
    *((uint32_t *)(data + 8)) = tyz_swap_endian_uint32(fcTL->height);
    *((uint32_t *)(data + 12)) = tyz_swap_endian_uint32(fcTL->x_offset);
    *((uint32_t *)(data + 16)) = tyz_swap_endian_uint32(fcTL->y_offset);
    *((uint16_t *)(data + 20)) = tyz_swap_endian_uint16(fcTL->delay_num);
    *((uint16_t *)(data + 22)) = tyz_swap_endian_uint16(fcTL->delay_den);
    data[24] = fcTL->dispose_op;
    data[25] = fcTL->blend_op;
}

// convert double value to fraction
static void tyz_png_delay_to_fraction(double duration, uint16_t *num, uint16_t *den)
{
    if (duration >= 0xFF) {
        *num = 0xFF;
        *den = 1;
    } else if (duration <= 1.0 / (double)0xFF) {
        *num = 1;
        *den = 0xFF;
    } else {
        // Use continued fraction to calculate the num and den.
        long MAX = 10;
        double eps = (0.5 / (double)0xFF);
        long p[MAX], q[MAX], a[MAX], i, numl = 0, denl = 0;
        // The first two convergents are 0/1 and 1/0
        p[0] = 0; q[0] = 1;
        p[1] = 1; q[1] = 0;
        // The rest of the convergents (and continued fraction)
        for (i = 2; i < MAX; i++) {
            a[i] = lrint(floor(duration));
            p[i] = a[i] * p[i - 1] + p[i - 2];
            q[i] = a[i] * q[i - 1] + q[i - 2];
            if (p[i] <= 0xFF && q[i] <= 0xFF) { // uint16_t
                numl = p[i];
                denl = q[i];
            } else break;
            if (fabs(duration - a[i]) < eps) break;
            duration = 1.0 / (duration - a[i]);
        }
        
        if (numl != 0 && denl != 0) {
            *num = numl;
            *den = denl;
        } else {
            *num = 1;
            *den = 100;
        }
    }
}

// convert fraction to double value
static double tyz_png_delay_to_seconds(uint16_t num, uint16_t den) {
    if (den == 0) {
        return num / 100.0;
    } else {
        return (double)num / (double)den;
    }
}

static bool tyz_png_validate_animation_chunk_order(tyz_png_chunk_info *chunks,  /* input */
                                                  uint32_t chunk_num,         /* input */
                                                  uint32_t *first_idat_index, /* output */
                                                  bool *first_frame_is_cover  /* output */) {
    /*
     PNG at least contains 3 chunks: IHDR, IDAT, IEND.
     `IHDR` must appear first.
     `IDAT` must appear consecutively.
     `IEND` must appear end.
     
     APNG must contains one `acTL` and at least one 'fcTL' and `fdAT`.
     `fdAT` must appear consecutively.
     `fcTL` must appear before `IDAT` or `fdAT`.
     */
    if (chunk_num <= 2) return false;
    if (chunks->fourcc != TYZ_FOUR_CC('I', 'H', 'D', 'R')) return false;
    if ((chunks + chunk_num - 1)->fourcc != TYZ_FOUR_CC('I', 'E', 'N', 'D')) return false;
    
    uint32_t prev_fourcc = 0;
    uint32_t IHDR_num = 0;
    uint32_t IDAT_num = 0;
    uint32_t acTL_num = 0;
    uint32_t fcTL_num = 0;
    uint32_t first_IDAT = 0;
    bool first_frame_cover = false;
    for (uint32_t i = 0; i < chunk_num; i++) {
        tyz_png_chunk_info *chunk = chunks + i;
        switch (chunk->fourcc) {
            case TYZ_FOUR_CC('I', 'H', 'D', 'R'): {  // png header
                if (i != 0) return false;
                if (IHDR_num > 0) return false;
                IHDR_num++;
            } break;
            case TYZ_FOUR_CC('I', 'D', 'A', 'T'): {  // png data
                if (prev_fourcc != TYZ_FOUR_CC('I', 'D', 'A', 'T')) {
                    if (IDAT_num == 0)
                        first_IDAT = i;
                    else
                        return false;
                }
                IDAT_num++;
            } break;
            case TYZ_FOUR_CC('a', 'c', 'T', 'L'): {  // apng control
                if (acTL_num > 0) return false;
                acTL_num++;
            } break;
            case TYZ_FOUR_CC('f', 'c', 'T', 'L'): {  // apng frame control
                if (i + 1 == chunk_num) return false;
                if ((chunk + 1)->fourcc != TYZ_FOUR_CC('f', 'd', 'A', 'T') &&
                    (chunk + 1)->fourcc != TYZ_FOUR_CC('I', 'D', 'A', 'T')) {
                    return false;
                }
                if (fcTL_num == 0) {
                    if ((chunk + 1)->fourcc == TYZ_FOUR_CC('I', 'D', 'A', 'T')) {
                        first_frame_cover = true;
                    }
                }
                fcTL_num++;
            } break;
            case TYZ_FOUR_CC('f', 'd', 'A', 'T'): {  // apng data
                if (prev_fourcc != TYZ_FOUR_CC('f', 'd', 'A', 'T') && prev_fourcc != TYZ_FOUR_CC('f', 'c', 'T', 'L')) {
                    return false;
                }
            } break;
        }
        prev_fourcc = chunk->fourcc;
    }
    if (IHDR_num != 1) return false;
    if (IDAT_num == 0) return false;
    if (acTL_num != 1) return false;
    if (fcTL_num < acTL_num) return false;
    *first_idat_index = first_IDAT;
    *first_frame_is_cover = first_frame_cover;
    return true;
}

static void tyz_png_info_release(tyz_png_info *info)
{
    if (info)
    {
        if (info->chunks) free(info->chunks);
        if (info->apng_frames) free(info->apng_frames);
        if (info->apng_shared_chunk_indexs) free(info->apng_shared_chunk_indexs);
        free(info);
        info = NULL;
    }
}

/**
 Create a png info from a png file. See struct png_info for more information.
 
 @param data   png/apng file data.
 @param length the data's length in bytes.
 @return A png info object, you may call TYZ_png_info_release() to release it.
 Returns NULL if an error occurs.
 */
static tyz_png_info *tyz_png_info_create(const uint8_t *data, uint32_t length)
{
    if (length < 32) return NULL;
    if (*((uint32_t *)data) != TYZ_FOUR_CC(0x89, 0x50, 0x4E, 0x47)) return NULL;
    if (*((uint32_t *)(data + 4)) != TYZ_FOUR_CC(0x0D, 0x0A, 0x1A, 0x0A)) return NULL;
    
    uint32_t chunk_realloc_num = 16;
    tyz_png_chunk_info *chunks = malloc(sizeof(tyz_png_chunk_info) * chunk_realloc_num);
    if (!chunks) return NULL;
    
    
    // parse png chunks
    uint32_t offset = 8;
    uint32_t chunk_num = 0;
    uint32_t chunk_capacity = chunk_realloc_num;
    uint32_t apng_loop_num = 0;
    int32_t apng_sequence_index = -1;
    int32_t apng_frame_index = 0;
    int32_t apng_frame_number = -1;
    bool apng_chunk_error = false;
    do {
        if (chunk_num >= chunk_capacity) {
            tyz_png_chunk_info *new_chunks = realloc(chunks, sizeof(tyz_png_chunk_info) * (chunk_capacity + chunk_realloc_num));
            if (!new_chunks) {
                free(chunks);
                return NULL;
            }
            chunks = new_chunks;
            chunk_capacity += chunk_realloc_num;
        }
        tyz_png_chunk_info *chunk = chunks + chunk_num;
        const uint8_t *chunk_data = data + offset;
        chunk->offset = offset;
        chunk->length = tyz_swap_endian_uint32(*((uint32_t *)chunk_data));
        if ((uint64_t)chunk->offset + (uint64_t)chunk->length + 12 > length) {
            free(chunks);
            return NULL;
        }
        
        chunk->fourcc = *((uint32_t *)(chunk_data + 4));
        if ((uint64_t)chunk->offset + 4 + chunk->length + 4 > (uint64_t)length) break;
        chunk->crc32 = tyz_swap_endian_uint32(*((uint32_t *)(chunk_data + 8 + chunk->length)));
        chunk_num++;
        offset += 12 + chunk->length;
        
        switch (chunk->fourcc) {
            case TYZ_FOUR_CC('a', 'c', 'T', 'L') : {
                if (chunk->length == 8) {
                    apng_frame_number = tyz_swap_endian_uint32(*((uint32_t *)(chunk_data + 8)));
                    apng_loop_num = tyz_swap_endian_uint32(*((uint32_t *)(chunk_data + 12)));
                } else {
                    apng_chunk_error = true;
                }
            } break;
            case TYZ_FOUR_CC('f', 'c', 'T', 'L') :
            case TYZ_FOUR_CC('f', 'd', 'A', 'T') : {
                if (chunk->fourcc == TYZ_FOUR_CC('f', 'c', 'T', 'L')) {
                    if (chunk->length != 26) {
                        apng_chunk_error = true;
                    } else {
                        apng_frame_index++;
                    }
                }
                if (chunk->length > 4) {
                    uint32_t sequence = tyz_swap_endian_uint32(*((uint32_t *)(chunk_data + 8)));
                    if (apng_sequence_index + 1 == sequence) {
                        apng_sequence_index++;
                    } else {
                        apng_chunk_error = true;
                    }
                } else {
                    apng_chunk_error = true;
                }
            } break;
            case TYZ_FOUR_CC('I', 'E', 'N', 'D') : {
                offset = length; // end, break do-while loop
            } break;
        }
    } while (offset + 12 <= length);
    
    if (chunk_num < 3 ||
        chunks->fourcc != TYZ_FOUR_CC('I', 'H', 'D', 'R') ||
        chunks->length != 13)
    {
        
        free(chunks);
        return NULL;
    }
    
    // png info
    tyz_png_info *info = calloc(1, sizeof(tyz_png_info));
    if (!info)
    {
        
        free(chunks);
        return NULL;
    }
    info->chunks = chunks;
    info->chunk_num = chunk_num;
    tyz_png_chunk_IHDR_read(&info->header, data + chunks->offset + 8);
    
    // apng info
    if (!apng_chunk_error && apng_frame_number == apng_frame_index && apng_frame_number >= 1)
    {
        bool first_frame_is_cover = false;
        uint32_t first_IDAT_index = 0;
        if (!tyz_png_validate_animation_chunk_order(info->chunks, info->chunk_num, &first_IDAT_index, &first_frame_is_cover)) {
            return info; // ignore apng chunk
        }
        
        info->apng_loop_num = apng_loop_num;
        info->apng_frame_num = apng_frame_number;
        info->apng_first_frame_is_cover = first_frame_is_cover;
        info->apng_shared_insert_index = first_IDAT_index;
        info->apng_frames = calloc(apng_frame_number, sizeof(tyz_png_frame_info));
        if (!info->apng_frames) {
            tyz_png_info_release(info);
            return NULL;
        }
        info->apng_shared_chunk_indexs = calloc(info->chunk_num, sizeof(uint32_t));
        if (!info->apng_shared_chunk_indexs) {
            tyz_png_info_release(info);
            return NULL;
        }
        
        int32_t frame_index = -1;
        uint32_t *shared_chunk_index = info->apng_shared_chunk_indexs;
        for (int32_t i = 0; i < info->chunk_num; i++) {
            tyz_png_chunk_info *chunk = info->chunks + i;
            switch (chunk->fourcc) {
                case TYZ_FOUR_CC('I', 'D', 'A', 'T'): {
                    if (info->apng_shared_insert_index == 0) {
                        info->apng_shared_insert_index = i;
                    }
                    if (first_frame_is_cover) {
                        tyz_png_frame_info *frame = info->apng_frames + frame_index;
                        frame->chunk_num++;
                        frame->chunk_size += chunk->length + 12;
                    }
                } break;
                case TYZ_FOUR_CC('a', 'c', 'T', 'L'): {
                } break;
                case TYZ_FOUR_CC('f', 'c', 'T', 'L'): {
                    frame_index++;
                    tyz_png_frame_info *frame = info->apng_frames + frame_index;
                    frame->chunk_index = i + 1;
                    tyz_png_chunk_fcTL_read(&frame->frame_control, data + chunk->offset + 8);
                } break;
                case TYZ_FOUR_CC('f', 'd', 'A', 'T'): {
                    tyz_png_frame_info *frame = info->apng_frames + frame_index;
                    frame->chunk_num++;
                    frame->chunk_size += chunk->length + 12;
                } break;
                default: {
                    *shared_chunk_index = i;
                    shared_chunk_index++;
                    info->apng_shared_chunk_size += chunk->length + 12;
                    info->apng_shared_chunk_num++;
                } break;
            }
        }
    }
    return info;
}

/**
 Copy a png frame data from an apng file.
 
 @param data  apng file data
 @param info  png info
 @param index frame index (zero-based)
 @param size  output, the size of the frame data
 @return A frame data (single-frame png file), call free() to release the data.
 Returns NULL if an error occurs.
 */
static uint8_t *tyz_png_copy_frame_data_at_index(const uint8_t *data,
                                                const tyz_png_info *info,
                                                const uint32_t index,
                                                uint32_t *size) {
    if (index >= info->apng_frame_num) return NULL;
    
    tyz_png_frame_info *frame_info = info->apng_frames + index;
    uint32_t frame_remux_size = 8 /* PNG Header */ + info->apng_shared_chunk_size + frame_info->chunk_size;
    if (!(info->apng_first_frame_is_cover && index == 0)) {
        frame_remux_size -= frame_info->chunk_num * 4; // remove fdAT sequence number
    }
    uint8_t *frame_data = malloc(frame_remux_size);
    if (!frame_data) return NULL;
    *size = frame_remux_size;
    
    uint32_t data_offset = 0;
    bool inserted = false;
    memcpy(frame_data, data, 8); // PNG File Header
    data_offset += 8;
    for (uint32_t i = 0; i < info->apng_shared_chunk_num; i++) {
        uint32_t shared_chunk_index = info->apng_shared_chunk_indexs[i];
        tyz_png_chunk_info *shared_chunk_info = info->chunks + shared_chunk_index;
        
        if (shared_chunk_index >= info->apng_shared_insert_index && !inserted) { // replace IDAT with fdAT
            inserted = true;
            for (uint32_t c = 0; c < frame_info->chunk_num; c++) {
                tyz_png_chunk_info *insert_chunk_info = info->chunks + frame_info->chunk_index + c;
                if (insert_chunk_info->fourcc == TYZ_FOUR_CC('f', 'd', 'A', 'T')) {
                    *((uint32_t *)(frame_data + data_offset)) = tyz_swap_endian_uint32(insert_chunk_info->length - 4);
                    *((uint32_t *)(frame_data + data_offset + 4)) = TYZ_FOUR_CC('I', 'D', 'A', 'T');
                    memcpy(frame_data + data_offset + 8, data + insert_chunk_info->offset + 12, insert_chunk_info->length - 4);
                    uint32_t crc = (uint32_t)crc32(0, frame_data + data_offset + 4, insert_chunk_info->length);
                    *((uint32_t *)(frame_data + data_offset + insert_chunk_info->length + 4)) = tyz_swap_endian_uint32(crc);
                    data_offset += insert_chunk_info->length + 8;
                } else { // IDAT
                    memcpy(frame_data + data_offset, data + insert_chunk_info->offset, insert_chunk_info->length + 12);
                    data_offset += insert_chunk_info->length + 12;
                }
            }
        }
        
        if (shared_chunk_info->fourcc == TYZ_FOUR_CC('I', 'H', 'D', 'R')) {
            uint8_t tmp[25] = {0};
            memcpy(tmp, data + shared_chunk_info->offset, 25);
            tyz_png_chunk_IHDR IHDR = info->header;
            IHDR.width = frame_info->frame_control.width;
            IHDR.height = frame_info->frame_control.height;
            tyz_png_chunk_IHDR_write(&IHDR, tmp + 8);
            *((uint32_t *)(tmp + 21)) = tyz_swap_endian_uint32((uint32_t)crc32(0, tmp + 4, 17));
            memcpy(frame_data + data_offset, tmp, 25);
            data_offset += 25;
        } else {
            memcpy(frame_data + data_offset, data + shared_chunk_info->offset, shared_chunk_info->length + 12);
            data_offset += shared_chunk_info->length + 12;
        }
    }
    return frame_data;
}



////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helper

/// Returns byte-aligned size.
static inline size_t TYZImageByteAlign(size_t size, size_t alignment) {
    return ((size + (alignment - 1)) / alignment) * alignment;
}

/// Convert degree to radians
static inline CGFloat TYZImageDegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

CGColorSpaceRef TYZCGColorSpaceGetDeviceRGB() {
    static CGColorSpaceRef space;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        space = CGColorSpaceCreateDeviceRGB();
    });
    return space;
}

CGColorSpaceRef TYZCGColorSpaceGetDeviceGray() {
    static CGColorSpaceRef space;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        space = CGColorSpaceCreateDeviceGray();
    });
    return space;
}

BOOL TYZCGColorSpaceIsDeviceRGB(CGColorSpaceRef space) {
    return space && CFEqual(space, TYZCGColorSpaceGetDeviceRGB());
}

BOOL TYZCGColorSpaceIsDeviceGray(CGColorSpaceRef space) {
    return space && CFEqual(space, TYZCGColorSpaceGetDeviceGray());
}

/**
 A callback used in CGDataProviderCreateWithData() to release data.
 
 Example:
 
 void *data = malloc(size);
 CGDataProviderRef provider = CGDataProviderCreateWithData(data, data, size, TYZCGDataProviderReleaseDataCallback);
 */
static void TYZCGDataProviderReleaseDataCallback(void *info, const void *data, size_t size) {
    if (info) free(info);
}

/**
 Decode an image to bitmap buffer with the specified format.
 
 @param srcImage   Source image.
 @param dest       Destination buffer. It should be zero before call this method.
 If decode succeed, you should release the dest->data using free().
 @param destFormat Destination bitmap format.
 
 @return Whether succeed.
 
 @warning This method support iOS7.0 and later. If call it on iOS6, it just returns NO.
 CG_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0)
 */
static BOOL TYZCGImageDecodeToBitmapBufferWithAnyFormat(CGImageRef srcImage, vImage_Buffer *dest, vImage_CGImageFormat *destFormat) {
    if (!srcImage || (((long)vImageConvert_AnyToAny) + 1 == 1) || !destFormat || !dest) return NO;
    size_t width = CGImageGetWidth(srcImage);
    size_t height = CGImageGetHeight(srcImage);
    if (width == 0 || height == 0) return NO;
    dest->data = NULL;
    
    vImage_Error error = kvImageNoError;
    CFDataRef srcData = NULL;
    vImageConverterRef convertor = NULL;
    vImage_CGImageFormat srcFormat = {0};
    srcFormat.bitsPerComponent = (uint32_t)CGImageGetBitsPerComponent(srcImage);
    srcFormat.bitsPerPixel = (uint32_t)CGImageGetBitsPerPixel(srcImage);
    srcFormat.colorSpace = CGImageGetColorSpace(srcImage);
    srcFormat.bitmapInfo = CGImageGetBitmapInfo(srcImage) | CGImageGetAlphaInfo(srcImage);
    
    convertor = vImageConverter_CreateWithCGImageFormat(&srcFormat, destFormat, NULL, kvImageNoFlags, NULL);
    if (!convertor) goto fail;
    
    CGDataProviderRef srcProvider = CGImageGetDataProvider(srcImage);
    srcData = srcProvider ? CGDataProviderCopyData(srcProvider) : NULL; // decode
    size_t srcLength = srcData ? CFDataGetLength(srcData) : 0;
    const void *srcBytes = srcData ? CFDataGetBytePtr(srcData) : NULL;
    if (srcLength == 0 || !srcBytes) goto fail;
    
    vImage_Buffer src = {0};
    src.data = (void *)srcBytes;
    src.width = width;
    src.height = height;
    src.rowBytes = CGImageGetBytesPerRow(srcImage);
    
    error = vImageBuffer_Init(dest, height, width, 32, kvImageNoFlags);
    if (error != kvImageNoError) goto fail;
    
    error = vImageConvert_AnyToAny(convertor, &src, dest, NULL, kvImageNoFlags); // convert
    if (error != kvImageNoError) goto fail;
    
    CFRelease(convertor);
    CFRelease(srcData);
    return YES;
    
fail:
    if (convertor) CFRelease(convertor);
    if (srcData) CFRelease(srcData);
    if (dest->data) free(dest->data);
    dest->data = NULL;
    return NO;
}

/**
 Decode an image to bitmap buffer with the 32bit format (such as ARGB8888).
 
 @param srcImage   Source image.
 @param dest       Destination buffer. It should be zero before call this method.
 If decode succeed, you should release the dest->data using free().
 @param bitmapInfo Destination bitmap format.
 
 @return Whether succeed.
 */
static BOOL TYZCGImageDecodeToBitmapBufferWith32BitFormat(CGImageRef srcImage, vImage_Buffer *dest, CGBitmapInfo bitmapInfo) {
    if (!srcImage || !dest) return NO;
    size_t width = CGImageGetWidth(srcImage);
    size_t height = CGImageGetHeight(srcImage);
    if (width == 0 || height == 0) return NO;
    
    BOOL hasAlpha = NO;
    BOOL alphaFirst = NO;
    BOOL alphaPremultiplied = NO;
    BOOL byteOrderNormal = NO;
    
    switch (bitmapInfo & kCGBitmapAlphaInfoMask) {
        case kCGImageAlphaPremultipliedLast: {
            hasAlpha = YES;
            alphaPremultiplied = YES;
        } break;
        case kCGImageAlphaPremultipliedFirst: {
            hasAlpha = YES;
            alphaPremultiplied = YES;
            alphaFirst = YES;
        } break;
        case kCGImageAlphaLast: {
            hasAlpha = YES;
        } break;
        case kCGImageAlphaFirst: {
            hasAlpha = YES;
            alphaFirst = YES;
        } break;
        case kCGImageAlphaNoneSkipLast: {
        } break;
        case kCGImageAlphaNoneSkipFirst: {
            alphaFirst = YES;
        } break;
        default: {
            return NO;
        } break;
    }
    
    switch (bitmapInfo & kCGBitmapByteOrderMask) {
        case kCGBitmapByteOrderDefault: {
            byteOrderNormal = YES;
        } break;
        case kCGBitmapByteOrder32Little: {
        } break;
        case kCGBitmapByteOrder32Big: {
            byteOrderNormal = YES;
        } break;
        default: {
            return NO;
        } break;
    }
    
    /*
     Try convert with vImageConvert_AnyToAny() (avaliable since iOS 7.0).
     If fail, try decode with CGContextDrawImage().
     CGBitmapContext use a premultiplied alpha format, unpremultiply may lose precision.
     */
    vImage_CGImageFormat destFormat = {0};
    destFormat.bitsPerComponent = 8;
    destFormat.bitsPerPixel = 32;
    destFormat.colorSpace = TYZCGColorSpaceGetDeviceRGB();
    destFormat.bitmapInfo = bitmapInfo;
    dest->data = NULL;
    if (TYZCGImageDecodeToBitmapBufferWithAnyFormat(srcImage, dest, &destFormat)) return YES;
    
    CGBitmapInfo contextBitmapInfo = bitmapInfo & kCGBitmapByteOrderMask;
    if (!hasAlpha || alphaPremultiplied) {
        contextBitmapInfo |= (bitmapInfo & kCGBitmapAlphaInfoMask);
    } else {
        contextBitmapInfo |= alphaFirst ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaPremultipliedLast;
    }
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 32, TYZCGColorSpaceGetDeviceRGB(), contextBitmapInfo);
    if (!context) goto fail;
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), srcImage); // decode and convert
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    size_t length = height * bytesPerRow;
    void *data = CGBitmapContextGetData(context);
    if (length == 0 || !data) goto fail;
    
    dest->data = malloc(length);
    dest->width = width;
    dest->height = height;
    dest->rowBytes = bytesPerRow;
    if (!dest->data) goto fail;
    
    if (hasAlpha && !alphaPremultiplied) {
        vImage_Buffer tmpSrc = {0};
        tmpSrc.data = data;
        tmpSrc.width = width;
        tmpSrc.height = height;
        tmpSrc.rowBytes = bytesPerRow;
        vImage_Error error;
        if (alphaFirst && byteOrderNormal) {
            error = vImageUnpremultiplyData_ARGB8888(&tmpSrc, dest, kvImageNoFlags);
        } else {
            error = vImageUnpremultiplyData_RGBA8888(&tmpSrc, dest, kvImageNoFlags);
        }
        if (error != kvImageNoError) goto fail;
    } else {
        memcpy(dest->data, data, length);
    }
    
    CFRelease(context);
    return YES;
    
fail:
    if (context) CFRelease(context);
    if (dest->data) free(dest->data);
    dest->data = NULL;
    return NO;
    return NO;
}

CGImageRef TYZCGImageCreateDecodedCopy(CGImageRef imageRef, BOOL decodeForDisplay) {
    if (!imageRef) return NULL;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    if (width == 0 || height == 0) return NULL;
    
    if (decodeForDisplay) { //decode with redraw (may lose some precision)
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, TYZCGColorSpaceGetDeviceRGB(), bitmapInfo);
        if (!context) return NULL;
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef newImage = CGBitmapContextCreateImage(context);
        CFRelease(context);
        return newImage;
        
    } else {
        CGColorSpaceRef space = CGImageGetColorSpace(imageRef);
        size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
        size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        if (bytesPerRow == 0 || width == 0 || height == 0) return NULL;
        
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        if (!dataProvider) return NULL;
        CFDataRef data = CGDataProviderCopyData(dataProvider); // decode
        if (!data) return NULL;
        
        CGDataProviderRef newProvider = CGDataProviderCreateWithCFData(data);
        CFRelease(data);
        if (!newProvider) return NULL;
        
        CGImageRef newImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, space, bitmapInfo, newProvider, NULL, false, kCGRenderingIntentDefault);
        CFRelease(newProvider);
        return newImage;
    }
}

CGImageRef TYZCGImageCreateAffineTransformCopy(CGImageRef imageRef, CGAffineTransform transform, CGSize destSize, CGBitmapInfo destBitmapInfo) {
    if (!imageRef) return NULL;
    size_t srcWidth = CGImageGetWidth(imageRef);
    size_t srcHeight = CGImageGetHeight(imageRef);
    size_t destWidth = round(destSize.width);
    size_t destHeight = round(destSize.height);
    if (srcWidth == 0 || srcHeight == 0 || destWidth == 0 || destHeight == 0) return NULL;
    
    CGDataProviderRef tmpProvider = NULL, destProvider = NULL;
    CGImageRef tmpImage = NULL, destImage = NULL;
    vImage_Buffer src = {0}, tmp = {0}, dest = {0};
    if(!TYZCGImageDecodeToBitmapBufferWith32BitFormat(imageRef, &src, kCGImageAlphaFirst | kCGBitmapByteOrderDefault)) return NULL;
    
    size_t destBytesPerRow = TYZImageByteAlign(destWidth * 4, 32);
    tmp.data = malloc(destHeight * destBytesPerRow);
    if (!tmp.data) goto fail;
    
    tmp.width = destWidth;
    tmp.height = destHeight;
    tmp.rowBytes = destBytesPerRow;
    vImage_CGAffineTransform vTransform = *((vImage_CGAffineTransform *)&transform);
    uint8_t backColor[4] = {0};
    vImage_Error error = vImageAffineWarpCG_ARGB8888(&src, &tmp, NULL, &vTransform, backColor, kvImageBackgroundColorFill);
    if (error != kvImageNoError) goto fail;
    free(src.data);
    src.data = NULL;
    
    tmpProvider = CGDataProviderCreateWithData(tmp.data, tmp.data, destHeight * destBytesPerRow, TYZCGDataProviderReleaseDataCallback);
    if (!tmpProvider) goto fail;
    tmp.data = NULL; // hold by provider
    tmpImage = CGImageCreate(destWidth, destHeight, 8, 32, destBytesPerRow, TYZCGColorSpaceGetDeviceRGB(), kCGImageAlphaFirst | kCGBitmapByteOrderDefault, tmpProvider, NULL, false, kCGRenderingIntentDefault);
    if (!tmpImage) goto fail;
    CFRelease(tmpProvider);
    tmpProvider = NULL;
    
    if ((destBitmapInfo & kCGBitmapAlphaInfoMask) == kCGImageAlphaFirst &&
        (destBitmapInfo & kCGBitmapByteOrderMask) != kCGBitmapByteOrder32Little) {
        return tmpImage;
    }
    
    if (!TYZCGImageDecodeToBitmapBufferWith32BitFormat(tmpImage, &dest, destBitmapInfo)) goto fail;
    CFRelease(tmpImage);
    tmpImage = NULL;
    
    destProvider = CGDataProviderCreateWithData(dest.data, dest.data, destHeight * destBytesPerRow, TYZCGDataProviderReleaseDataCallback);
    if (!destProvider) goto fail;
    dest.data = NULL; // hold by provider
    destImage = CGImageCreate(destWidth, destHeight, 8, 32, destBytesPerRow, TYZCGColorSpaceGetDeviceRGB(), destBitmapInfo, destProvider, NULL, false, kCGRenderingIntentDefault);
    if (!destImage) goto fail;
    CFRelease(destProvider);
    destProvider = NULL;
    
    return destImage;
    
fail:
    if (src.data) free(src.data);
    if (tmp.data) free(tmp.data);
    if (dest.data) free(dest.data);
    if (tmpProvider) CFRelease(tmpProvider);
    if (tmpImage) CFRelease(tmpImage);
    if (destProvider) CFRelease(destProvider);
    return NULL;
}

UIImageOrientation TYZUIImageOrientationFromEXIFValue(NSInteger value) {
    switch (value) {
        case kCGImagePropertyOrientationUp: return UIImageOrientationUp;
        case kCGImagePropertyOrientationDown: return UIImageOrientationDown;
        case kCGImagePropertyOrientationLeft: return UIImageOrientationLeft;
        case kCGImagePropertyOrientationRight: return UIImageOrientationRight;
        case kCGImagePropertyOrientationUpMirrored: return UIImageOrientationUpMirrored;
        case kCGImagePropertyOrientationDownMirrored: return UIImageOrientationDownMirrored;
        case kCGImagePropertyOrientationLeftMirrored: return UIImageOrientationLeftMirrored;
        case kCGImagePropertyOrientationRightMirrored: return UIImageOrientationRightMirrored;
        default: return UIImageOrientationUp;
    }
}

NSInteger TYZUIImageOrientationToEXIFValue(UIImageOrientation orientation) {
    switch (orientation) {
        case UIImageOrientationUp: return kCGImagePropertyOrientationUp;
        case UIImageOrientationDown: return kCGImagePropertyOrientationDown;
        case UIImageOrientationLeft: return kCGImagePropertyOrientationLeft;
        case UIImageOrientationRight: return kCGImagePropertyOrientationRight;
        case UIImageOrientationUpMirrored: return kCGImagePropertyOrientationUpMirrored;
        case UIImageOrientationDownMirrored: return kCGImagePropertyOrientationDownMirrored;
        case UIImageOrientationLeftMirrored: return kCGImagePropertyOrientationLeftMirrored;
        case UIImageOrientationRightMirrored: return kCGImagePropertyOrientationRightMirrored;
        default: return kCGImagePropertyOrientationUp;
    }
}

CGImageRef TYZCGImageCreateCopyWithOrientation(CGImageRef imageRef, UIImageOrientation orientation, CGBitmapInfo destBitmapInfo) {
    if (!imageRef) return NULL;
    if (orientation == UIImageOrientationUp) return (CGImageRef)CFRetain(imageRef);
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    BOOL swapWidthAndHeight = NO;
    switch (orientation) {
        case UIImageOrientationDown: {
            transform = CGAffineTransformMakeRotation(TYZImageDegreesToRadians(180));
            transform = CGAffineTransformTranslate(transform, -(CGFloat)width, -(CGFloat)height);
        } break;
        case UIImageOrientationLeft: {
            transform = CGAffineTransformMakeRotation(TYZImageDegreesToRadians(90));
            transform = CGAffineTransformTranslate(transform, -(CGFloat)0, -(CGFloat)height);
            swapWidthAndHeight = YES;
        } break;
        case UIImageOrientationRight: {
            transform = CGAffineTransformMakeRotation(TYZImageDegreesToRadians(-90));
            transform = CGAffineTransformTranslate(transform, -(CGFloat)width, (CGFloat)0);
            swapWidthAndHeight = YES;
        } break;
        case UIImageOrientationUpMirrored: {
            transform = CGAffineTransformTranslate(transform, (CGFloat)width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        } break;
        case UIImageOrientationDownMirrored: {
            transform = CGAffineTransformTranslate(transform, 0, (CGFloat)height);
            transform = CGAffineTransformScale(transform, 1, -1);
        } break;
        case UIImageOrientationLeftMirrored: {
            transform = CGAffineTransformMakeRotation(TYZImageDegreesToRadians(-90));
            transform = CGAffineTransformScale(transform, 1, -1);
            transform = CGAffineTransformTranslate(transform, -(CGFloat)width, -(CGFloat)height);
            swapWidthAndHeight = YES;
        } break;
        case UIImageOrientationRightMirrored: {
            transform = CGAffineTransformMakeRotation(TYZImageDegreesToRadians(90));
            transform = CGAffineTransformScale(transform, 1, -1);
            swapWidthAndHeight = YES;
        } break;
        default: break;
    }
    if (CGAffineTransformIsIdentity(transform)) return (CGImageRef)CFRetain(imageRef);
    
    CGSize destSize = {width, height};
    if (swapWidthAndHeight) {
        destSize.width = height;
        destSize.height = width;
    }
    
    return TYZCGImageCreateAffineTransformCopy(imageRef, transform, destSize, destBitmapInfo);
}

TYZImageType TYZImageDetectType(CFDataRef data)
{
    if (!data) return TYZImageTypeUnknown;
    uint64_t length = CFDataGetLength(data);
    if (length < 16) return TYZImageTypeUnknown;
    
    const char *bytes = (char *)CFDataGetBytePtr(data);
    
    uint32_t magic4 = *((uint32_t *)bytes);
    switch (magic4) {
        case TYZ_FOUR_CC(0x4D, 0x4D, 0x00, 0x2A): { // big endian TIFF
            return TYZImageTypeTIFF;
        } break;
            
        case TYZ_FOUR_CC(0x49, 0x49, 0x2A, 0x00): { // little endian TIFF
            return TYZImageTypeTIFF;
        } break;
            
        case TYZ_FOUR_CC(0x00, 0x00, 0x01, 0x00): { // ICO
            return TYZImageTypeICO;
        } break;
            
        case TYZ_FOUR_CC(0x00, 0x00, 0x02, 0x00): { // CUR
            return TYZImageTypeICO;
        } break;
            
        case TYZ_FOUR_CC('i', 'c', 'n', 's'): { // ICNS
            return TYZImageTypeICNS;
        } break;
            
        case TYZ_FOUR_CC('G', 'I', 'F', '8'): { // GIF
            return TYZImageTypeGIF;
        } break;
            
        case TYZ_FOUR_CC(0x89, 'P', 'N', 'G'): {  // PNG
            uint32_t tmp = *((uint32_t *)(bytes + 4));
            if (tmp == TYZ_FOUR_CC('\r', '\n', 0x1A, '\n')) {
                return TYZImageTypePNG;
            }
        } break;
            
        case TYZ_FOUR_CC('R', 'I', 'F', 'F'): { // WebP
            uint32_t tmp = *((uint32_t *)(bytes + 8));
            if (tmp == TYZ_FOUR_CC('W', 'E', 'B', 'P')) {
                return TYZImageTypeWebP;
            }
        } break;
            /*
             case TYZ_FOUR_CC('B', 'P', 'G', 0xFB): { // BPG
             return TYZImageTypeBPG;
             } break;
             */
    }
    
    uint16_t magic2 = *((uint16_t *)bytes);
    switch (magic2) {
        case TYZ_TWO_CC('B', 'A'):
        case TYZ_TWO_CC('B', 'M'):
        case TYZ_TWO_CC('I', 'C'):
        case TYZ_TWO_CC('P', 'I'):
        case TYZ_TWO_CC('C', 'I'):
        case TYZ_TWO_CC('C', 'P'): { // BMP
            return TYZImageTypeBMP;
        }
        case TYZ_TWO_CC(0xFF, 0x4F): { // JPEG2000
            return TYZImageTypeJPEG2000;
        }
    }
    
    // JPG             FF D8 FF
    if (memcmp(bytes,"\377\330\377",3) == 0) return TYZImageTypeJPEG;
    
    // JP2
    if (memcmp(bytes + 4, "\152\120\040\040\015", 5) == 0) return TYZImageTypeJPEG2000;
    
    return TYZImageTypeUnknown;
}

CFStringRef TYZImageTypeToUTType(TYZImageType type) {
    switch (type) {
        case TYZImageTypeJPEG: return kUTTypeJPEG;
        case TYZImageTypeJPEG2000: return kUTTypeJPEG2000;
        case TYZImageTypeTIFF: return kUTTypeTIFF;
        case TYZImageTypeBMP: return kUTTypeBMP;
        case TYZImageTypeICO: return kUTTypeICO;
        case TYZImageTypeICNS: return kUTTypeAppleICNS;
        case TYZImageTypeGIF: return kUTTypeGIF;
        case TYZImageTypePNG: return kUTTypePNG;
        default: return NULL;
    }
}

TYZImageType TYZImageTypeFromUTType(CFStringRef uti) {
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{(id)kUTTypeJPEG : @(TYZImageTypeJPEG),
                (id)kUTTypeJPEG2000 : @(TYZImageTypeJPEG2000),
                (id)kUTTypeTIFF : @(TYZImageTypeTIFF),
                (id)kUTTypeBMP : @(TYZImageTypeBMP),
                (id)kUTTypeICO : @(TYZImageTypeICO),
                (id)kUTTypeAppleICNS : @(TYZImageTypeICNS),
                (id)kUTTypeGIF : @(TYZImageTypeGIF),
                (id)kUTTypePNG : @(TYZImageTypePNG)};
    });
    if (!uti) return TYZImageTypeUnknown;
    NSNumber *num = dic[(__bridge __strong id)(uti)];
    return num.unsignedIntegerValue;
}

NSString *TYZImageTypeGetExtension(TYZImageType type) {
    switch (type) {
        case TYZImageTypeJPEG: return @"jpg";
        case TYZImageTypeJPEG2000: return @"jp2";
        case TYZImageTypeTIFF: return @"tiff";
        case TYZImageTypeBMP: return @"bmp";
        case TYZImageTypeICO: return @"ico";
        case TYZImageTypeICNS: return @"icns";
        case TYZImageTypeGIF: return @"gif";
        case TYZImageTypePNG: return @"png";
        case TYZImageTypeWebP: return @"webp";
        default: return nil;
    }
}

CFDataRef TYZCGImageCreateEncodedData(CGImageRef imageRef, TYZImageType type, CGFloat quality) {
    if (!imageRef) return nil;
    quality = quality < 0 ? 0 : quality > 1 ? 1 : quality;
    
    if (type == TYZImageTypeWebP) {
#if TYZIMAGE_WEBP_ENABLED
        if (quality == 1) {
            return TYZCGImageCreateEncodedWebPData(imageRef, YES, quality, 4, TYZImagePresetDefault);
        } else {
            return TYZCGImageCreateEncodedWebPData(imageRef, NO, quality, 4, TYZImagePresetDefault);
        }
#else
        return NULL;
#endif
    }
    
    CFStringRef uti = TYZImageTypeToUTType(type);
    if (!uti) return nil;
    
    CFMutableDataRef data = CFDataCreateMutable(CFAllocatorGetDefault(), 0);
    if (!data) return NULL;
    CGImageDestinationRef dest = CGImageDestinationCreateWithData(data, uti, 1, NULL);
    if (!dest) {
        CFRelease(data);
        return NULL;
    }
    NSDictionary *options = @{(id)kCGImageDestinationLossyCompressionQuality : @(quality) };
    CGImageDestinationAddImage(dest, imageRef, (CFDictionaryRef)options);
    if (!CGImageDestinationFinalize(dest)) {
        CFRelease(data);
        CFRelease(dest);
        return nil;
    }
    CFRelease(dest);
    
    if (CFDataGetLength(data) == 0) {
        CFRelease(data);
        return NULL;
    }
    return data;
}

#if TYZIMAGE_WEBP_ENABLED

BOOL TYZImageWebPAvailable() {
    return YES;
}

CFDataRef TYZCGImageCreateEncodedWebPData(CGImageRef imageRef, BOOL lossless, CGFloat quality, int compressLevel, TYZImagePreset preset) {
    if (!imageRef) return nil;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    if (width == 0 || width > WEBP_MAX_DIMENSION) return nil;
    if (height == 0 || height > WEBP_MAX_DIMENSION) return nil;
    
    vImage_Buffer buffer = {0};
    if(!TYZCGImageDecodeToBitmapBufferWith32BitFormat(imageRef, &buffer, kCGImageAlphaLast | kCGBitmapByteOrderDefault)) return nil;
    
    WebPConfig config = {0};
    WebPPicture picture = {0};
    WebPMemoryWriter writer = {0};
    CFDataRef webpData = NULL;
    BOOL pictureNeedFree = NO;
    
    quality = quality < 0 ? 0 : quality > 1 ? 1 : quality;
    preset = preset > TYZImagePresetText ? TYZImagePresetDefault : preset;
    compressLevel = compressLevel < 0 ? 0 : compressLevel > 6 ? 6 : compressLevel;
    if (!WebPConfigPreset(&config, (WebPPreset)preset, quality)) goto fail;
    
    config.quality = round(quality * 100.0);
    config.lossless = lossless;
    config.method = compressLevel;
    switch ((WebPPreset)preset) {
        case WEBP_PRESET_DEFAULT: {
            config.image_hint = WEBP_HINT_DEFAULT;
        } break;
        case WEBP_PRESET_PICTURE: {
            config.image_hint = WEBP_HINT_PICTURE;
        } break;
        case WEBP_PRESET_PHOTO: {
            config.image_hint = WEBP_HINT_PHOTO;
        } break;
        case WEBP_PRESET_DRAWING:
        case WEBP_PRESET_ICON:
        case WEBP_PRESET_TEXT: {
            config.image_hint = WEBP_HINT_GRAPH;
        } break;
    }
    if (!WebPValidateConfig(&config)) goto fail;
    
    if (!WebPPictureInit(&picture)) goto fail;
    pictureNeedFree = YES;
    picture.width = (int)buffer.width;
    picture.height = (int)buffer.height;
    picture.use_argb = lossless;
    if(!WebPPictureImportRGBA(&picture, buffer.data, (int)buffer.rowBytes)) goto fail;
    
    WebPMemoryWriterInit(&writer);
    picture.writer = WebPMemoryWrite;
    picture.custom_ptr = &writer;
    if(!WebPEncode(&config, &picture)) goto fail;
    
    webpData = CFDataCreate(CFAllocatorGetDefault(), writer.mem, writer.size);
    free(writer.mem);
    WebPPictureFree(&picture);
    free(buffer.data);
    return webpData;
    
fail:
    if (buffer.data) free(buffer.data);
    if (pictureNeedFree) WebPPictureFree(&picture);
    return nil;
}

NSUInteger TYZImageGetWebPFrameCount(CFDataRef webpData) {
    if (!webpData || CFDataGetLength(webpData) == 0) return 0;
    
    WebPData data = {CFDataGetBytePtr(webpData), CFDataGetLength(webpData)};
    WebPDemuxer *demuxer = WebPDemux(&data);
    if (!demuxer) return 0;
    NSUInteger webpFrameCount = WebPDemuxGetI(demuxer, WEBP_FF_FRAME_COUNT);
    WebPDemuxDelete(demuxer);
    return webpFrameCount;
}

CGImageRef TYZCGImageCreateWithWebPData(CFDataRef webpData,
                                       BOOL decodeForDisplay,
                                       BOOL useThreads,
                                       BOOL bypassFiltering,
                                       BOOL noFancyUpsampling) {
    /*
     Call WebPDecode() on a multi-frame webp data will get an error (VP8_STATUS_UNSUPPORTED_FEATURE).
     Use WebPDemuxer to unpack it first.
     */
    WebPData data = {0};
    WebPDemuxer *demuxer = NULL;
    
    int frameCount = 0, canvasWidth = 0, canvasHeight = 0;
    WebPIterator iter = {0};
    BOOL iterInited = NO;
    const uint8_t *payload = NULL;
    size_t payloadSize = 0;
    WebPDecoderConfig config = {0};
    
    BOOL hasAlpha = NO;
    size_t bitsPerComponent = 0, bitsPerPixel = 0, bytesPerRow = 0, destLength = 0;
    CGBitmapInfo bitmapInfo = 0;
    WEBP_CSP_MODE colorspace = 0;
    void *destBytes = NULL;
    CGDataProviderRef provider = NULL;
    CGImageRef imageRef = NULL;
    
    if (!webpData || CFDataGetLength(webpData) == 0) return NULL;
    data.bytes = CFDataGetBytePtr(webpData);
    data.size = CFDataGetLength(webpData);
    demuxer = WebPDemux(&data);
    if (!demuxer) goto fail;
    
    frameCount = WebPDemuxGetI(demuxer, WEBP_FF_FRAME_COUNT);
    if (frameCount == 0) {
        goto fail;
        
    } else if (frameCount == 1) { // single-frame
        payload = data.bytes;
        payloadSize = data.size;
        if (!WebPInitDecoderConfig(&config)) goto fail;
        if (WebPGetFeatures(payload , payloadSize, &config.input) != VP8_STATUS_OK) goto fail;
        canvasWidth = config.input.width;
        canvasHeight = config.input.height;
        
    } else { // multi-frame
        canvasWidth = WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_WIDTH);
        canvasHeight = WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_HEIGHT);
        if (canvasWidth < 1 || canvasHeight < 1) goto fail;
        
        if (!WebPDemuxGetFrame(demuxer, 1, &iter)) goto fail;
        iterInited = YES;
        
        if (iter.width > canvasWidth || iter.height > canvasHeight) goto fail;
        payload = iter.fragment.bytes;
        payloadSize = iter.fragment.size;
        
        if (!WebPInitDecoderConfig(&config)) goto fail;
        if (WebPGetFeatures(payload , payloadSize, &config.input) != VP8_STATUS_OK) goto fail;
    }
    if (payload == NULL || payloadSize == 0) goto fail;
    
    hasAlpha = config.input.has_alpha;
    bitsPerComponent = 8;
    bitsPerPixel = 32;
    bytesPerRow = TYZImageByteAlign(bitsPerPixel / 8 * canvasWidth, 32);
    destLength = bytesPerRow * canvasHeight;
    if (decodeForDisplay) {
        bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        colorspace = MODE_bgrA; // small endian
    } else {
        bitmapInfo = kCGBitmapByteOrderDefault;
        bitmapInfo |= hasAlpha ? kCGImageAlphaLast : kCGImageAlphaNoneSkipLast;
        colorspace = MODE_RGBA;
    }
    destBytes = calloc(1, destLength);
    if (!destBytes) goto fail;
    
    config.options.use_threads = useThreads; //speed up 23%
    config.options.bypass_filtering = bypassFiltering; //speed up 11%, cause some banding
    config.options.no_fancy_upsampling = noFancyUpsampling; //speed down 16%, lose some details
    config.output.colorspace = colorspace;
    config.output.is_external_memory = 1;
    config.output.u.RGBA.rgba = destBytes;
    config.output.u.RGBA.stride = (int)bytesPerRow;
    config.output.u.RGBA.size = destLength;
    
    VP8StatusCode result = WebPDecode(payload, payloadSize, &config);
    if ((result != VP8_STATUS_OK) && (result != VP8_STATUS_NOT_ENOUGH_DATA)) goto fail;
    
    if (iter.x_offset != 0 || iter.y_offset != 0) {
        void *tmp = calloc(1, destLength);
        if (tmp) {
            vImage_Buffer src = {destBytes, canvasHeight, canvasWidth, bytesPerRow};
            vImage_Buffer dest = {destBytes, canvasHeight, canvasWidth, bytesPerRow};
            vImage_CGAffineTransform transform = {1, 0, 0, 1, iter.x_offset, -iter.y_offset};
            uint8_t backColor[4] = {0};
            vImageAffineWarpCG_ARGB8888(&src, &dest, NULL, &transform, backColor, kvImageBackgroundColorFill);
            memcpy(destBytes, tmp, destLength);
            free(tmp);
        }
    }
    
    provider = CGDataProviderCreateWithData(destBytes, destBytes, destLength, TYZCGDataProviderReleaseDataCallback);
    if (!provider) goto fail;
    destBytes = NULL; // hold by provider
    
    imageRef = CGImageCreate(canvasWidth, canvasHeight, bitsPerComponent, bitsPerPixel, bytesPerRow, TYZCGColorSpaceGetDeviceRGB(), bitmapInfo, provider, NULL, false, kCGRenderingIntentDefault);
    
    CFRelease(provider);
    if (iterInited) WebPDemuxReleaseIterator(&iter);
    WebPDemuxDelete(demuxer);
    
    return imageRef;
    
fail:
    if (destBytes) free(destBytes);
    if (provider) CFRelease(provider);
    if (iterInited) WebPDemuxReleaseIterator(&iter);
    if (demuxer) WebPDemuxDelete(demuxer);
    return NULL;
}

#else

BOOL TYZImageWebPAvailable()
{
    return NO;
}

CFDataRef TYZCGImageCreateEncodedWebPData(CGImageRef imageRef, BOOL lossless, CGFloat quality, int compressLevel, TYZImagePreset preset)
{
    NSLog(@"WebP decoder is disabled");
    return NULL;
}

NSUInteger TYZImageGetWebPFrameCount(CFDataRef webpData)
{
    NSLog(@"WebP decoder is disabled");
    return 0;
}

CGImageRef TYZCGImageCreateWithWebPData(CFDataRef webpData,
                                       BOOL decodeForDisplay,
                                       BOOL useThreads,
                                       BOOL bypassFiltering,
                                       BOOL noFancyUpsampling)
{
    NSLog(@"WebP decoder is disabled");
    return NULL;
}

#endif


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Decoder


@implementation TYZImageFrame

#pragma mark - public methods
+ (instancetype)frameWithImage:(UIImage *)image
{
    TYZImageFrame *frame = [self new];
    frame.image = image;
    return frame;
}

- (id)copyWithZone:(NSZone *)zone
{
    TYZImageFrame *frame = [[self class] new];
    frame.index = _index;
    frame.width = _width;
    frame.height = _height;
    frame.offsetX = _offsetX;
    frame.offsetY = _offsetY;
    frame.duration = _duration;
    frame.dispose = _dispose;
    frame.blend = _blend;
    frame.image = _image.copy;

    return  frame;
}
@end

/**
 *  Internal frame object.(内部贴对象。)
 */
@interface _TYZImageDecoderFrame : TYZImageFrame

@property (nonatomic, assign) BOOL hasAlpha; ///< whether frame has alpha.

@property (nonatomic, assign) BOOL isFullSize; ///< whether frame fill the canvas.

@property (nonatomic, assign) NSUInteger blendFromIndex; ///< Blend from frame index ot current frame.

@end

@implementation _TYZImageDecoderFrame

- (id)copyWithZone:(NSZone *)zone
{
    _TYZImageDecoderFrame *frame = [super copyWithZone:zone];
    frame.hasAlpha = _hasAlpha;
    frame.isFullSize = _isFullSize;
    frame.blendFromIndex = _blendFromIndex;
    return frame;
}

@end

/**
 *  一个图像解码器解码图像数据。
 */
@implementation TYZImageDecoder
{
    pthread_mutex_t _lock; // recursive lock
    
    /**
     *  是否需要源类型检测
     */
    BOOL _sourceTypeDetected;
    
    CGImageSourceRef _source;
    tyz_png_info *_apngSource;
#if TYZIMAGE_WEBP_ENABLED
    WebPDemuxer *_webpSource;
#endif
    // 图片方向
    UIImageOrientation _orientation;
    dispatch_semaphore_t _framesLock;
    NSArray *_frames; ///< Array<GGImageDecoderFrame>, without image
    BOOL _needBlend;
    NSUInteger _blendFrameIndex;
    CGContextRef _blendCanvas;
}

- (void)dealloc
{
    if (_source)
    {
        CFRelease(_source);
    }
    if (_apngSource)
    {
        tyz_png_info_release(_apngSource);
    }
    
#if TYZIMAGE_WEBP_ENABLED
    if (_webpSource) WebPDemuxDelete(_webpSource);
#endif
    if (_blendCanvas)
    {
        CFRelease(_blendCanvas);
    }
    pthread_mutex_destroy(&_lock);
}

#pragma mark - public methods

/**
 Updates the incremental image with new data.
 
 @discussion You can use this method to decode progressive/interlaced/baseline
 image when you do not have the complete image data. The `data` was retained by
 decoder, you should not modify the data in other thread during decoding.
 
 @param data  The data to add to the image decoder. Each time you call this
 function, the 'data' parameter must contain all of the image file data
 accumulated so far.
 
 @param final  A value that specifies whether the data is the final set.
 Pass YES if it is, NO otherwise. When the data is already finalized, you can
 not update the data anymore.
 
 @return Whether succeed.
 */
- (BOOL)updateData:(nullable NSData *)data final:(BOOL)final
{
    BOOL result = NO;
    pthread_mutex_lock(&_lock);
    result = [self _updateData:data final:final];
    pthread_mutex_unlock(&_lock);
    return result;
}

/**
 Convenience method to create a decoder with specified data.
 @param data  Image data.
 @param scale Image's scale.
 @return A new decoder, or nil if an error occurs.
 */
+ (instancetype)decoderWithData:(NSData *)data scale:(CGFloat)scale
{
    if (!data)
    {
        return nil;
    }
    TYZImageDecoder *decoder = [[TYZImageDecoder alloc] initWithScale:scale];
    [decoder updateData:data final:YES];
    if (decoder.frameCount == 0)
    {
        return nil;
    }
    return decoder;
}

- (instancetype)init
{
    return [self initWithScale:[UIScreen mainScreen].scale];
}

- (instancetype)initWithScale:(CGFloat)scale
{
    self = [super init];
    if (scale <= 0)
    {
        scale = 1;
    }
    _scale = scale;
    _framesLock = dispatch_semaphore_create(1);
    // 创建一个互斥锁
    pthread_mutex_init_recursive(&_lock, true);
    return self;
}

/**
 Decodes and returns a frame from a specified index.
 @param index  Frame image index (zero-based).
 @param decodeForDisplay Whether decode the image to memory bitmap for display.
 If NO, it will try to returns the original frame data without blend.
 @return A new frame with image, or nil if an error occurs.
 */
- (TYZImageFrame *)frameAtIndex:(NSUInteger)index decodeForDisplay:(BOOL)decodeForDisplay
{
    TYZImageFrame *result = nil;
    pthread_mutex_lock(&_lock);
    result = [self _frameAtIndex:index decodeForDisplay:decodeForDisplay];
    pthread_mutex_unlock(&_lock);
    return result;
}

/**
 Returns the frame duration from a specified index.
 @param index  Frame image (zero-based).
 @return Duration in seconds.
 */
- (NSTimeInterval)frameDurationAtIndex:(NSUInteger)index
{
    NSTimeInterval result = 0;
    dispatch_semaphore_wait(_framesLock, DISPATCH_TIME_FOREVER);
    if (index < [_frames count])
    {
        result = ((_TYZImageDecoderFrame *)_frames[index]).duration;
    }
    dispatch_semaphore_signal(_framesLock);
    return result;
}

/**
 Returns the frame's properties. See "CGImageProperties.h" in ImageIO.framework
 for more information.
 
 @param index  Frame image index (zero-based).
 @return The ImageIO frame property.
 */
- (NSDictionary *)framePropertiesAtIndex:(NSUInteger)index
{
    NSDictionary *result = nil;
    pthread_mutex_lock(&_lock);
    result = [self _framePropertiesAtIndex:index];
    pthread_mutex_unlock(&_lock);
    return result;
}

/**
 Returns the image's properties. See "CGImageProperties.h" in ImageIO.framework
 for more information.
 */
- (NSDictionary *)imageProperties
{
    NSDictionary *result = nil;
    pthread_mutex_lock(&_lock);
    result = [self _imageProperties];
    pthread_mutex_unlock(&_lock);
    return result;
}

#pragma mark - private methods(wrap)
- (BOOL)_updateData:(NSData *)data final:(BOOL)final
{
    if (_finalized)
    {
        return NO;
    }
    if (data.length < _data.length)
    {
        return NO;
    }
    _finalized = final;
    _data = data;
    // 根据NSData数据得到图片的类型
    TYZImageType type = TYZImageDetectType((__bridge CFDataRef)data);
    if (_sourceTypeDetected)
    {// 需要源类型检测
        if (_type != type)
        {
            return NO;
        }
        else
        {
            [self _updateSource];
        }
    }
    else
    {
        if (_data.length > 16)
        {
            _type = type;
            // 设置需要类型检测
            _sourceTypeDetected = YES;
            [self _updateSource];
        }
    }
    
    return YES;
}

- (TYZImageFrame *)_frameAtIndex:(NSUInteger)index decodeForDisplay:(BOOL)decodeForDisplay
{
    if (index >= [_frames count])
    {
        return 0;
    }
    _TYZImageDecoderFrame *frame = [(_TYZImageDecoderFrame *)_frames[index] copy];
    BOOL decoded = NO;
    BOOL extendToCanvas = NO;
    if (_type != TYZImageTypeICO && decodeForDisplay)
    {// ICO contains multi-size frame and should not extend to canvas.
        extendToCanvas = YES;
    }
    
    if (!_needBlend)
    {
        CGImageRef imageRef = [self _newUnblendedImageAtIndex:index extendToCanvas:extendToCanvas decoded:&decoded];
        if (!imageRef)
        {
            return nil;
        }
        if (decodeForDisplay && !decoded)
        {
            CGImageRef imageRefDecoded = TYZCGImageCreateDecodedCopy(imageRef, YES);
            if (imageRefDecoded)
            {
                CFRelease(imageRef);
                imageRef = imageRefDecoded;
                decoded = YES;
            }
        }
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:_scale orientation:_orientation];
        CFRelease(imageRef);
        if (!image)
        {
            return nil;
        }
        image.isDecodedForDisplay = decoded;
        frame.image = image;
        return frame;
    }
    
    // blend
    if (![self _createBlendContextIfNeeded])
    {
        return nil;
    }
    CGImageRef imageRef = NULL;
    
    if ((_blendFrameIndex + 1) == frame.index)
    {
        imageRef = [self _newBlendedImageWithFrame:frame];
        _blendFrameIndex = index;
    }
    else
    {// should draw canvas from previous frame
        _blendFrameIndex = NSNotFound;
        CGContextClearRect(_blendCanvas, CGRectMake(0, 0, _width, _height));
        if (frame.blendFromIndex == frame.index)
        {
            CGImageRef unblendedImage = [self _newUnblendedImageAtIndex:index extendToCanvas:NO decoded:NULL];
            if (unblendedImage)
            {
                CGContextDrawImage(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height), unblendedImage);
                CFRelease(unblendedImage);
            }
            imageRef = CGBitmapContextCreateImage(_blendCanvas);
            if (frame.dispose == TYZImageDisposeBackground)
            {
                CGContextClearRect(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height));
            }
            _blendFrameIndex = index;
        }
        else
        {// canvas is not ready
            for (uint32_t i=(uint32_t)frame.blendFromIndex; i<=(uint32_t)frame.index; i++)
            {
                if (i == frame.index)
                {
                    if (!imageRef)
                    {
                        imageRef = [self _newBlendedImageWithFrame:frame];
                    }
                }
                else
                {
                    [self _blendImageWithFrame:_frames[i]];
                }
            }
            _blendFrameIndex = index;
        }
    }
    
    if (!imageRef)
    {
        return nil;
    }
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:_scale orientation:_orientation];
    CFRelease(imageRef);
    if (!image)
    {
        return nil;
    }
    
    image.isDecodedForDisplay = YES;
    frame.image = image;
    if (extendToCanvas)
    {
        frame.width = _width;
        frame.height = _height;
        frame.offsetX = 0;
        frame.offsetY = 0;
        frame.dispose = TYZImageDisposeNone;
        frame.blend = TYZImageBlendNone;
    }
    return frame;
}

- (NSDictionary *)_framePropertiesAtIndex:(NSUInteger)index
{
    if (index >= [_frames count])
    {
        return nil;
    }
    if (!_source)
    {
        return nil;
    }
    CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(_source, index, NULL);
    if (!properties)
    {
        return nil;
    }
    return CFBridgingRelease(properties);
}


- (NSDictionary *)_imageProperties
{
    if (!_source)
    {
        return nil;
    }
    CFDictionaryRef properties = CGImageSourceCopyProperties(_source, NULL);
    if (!properties)
    {
        return nil;
    }
    return CFBridgingRelease(properties);
}

#pragma mark - private
- (void)_updateSource
{
    switch (_type)
    {
        case TYZImageTypeWebP:
        {
            [self _updateSourceWebP];
        } break;
        case TYZImageTypePNG:
        {
            [self _updateSourceAPNG];
        } break;
        default:
        {
            [self _updateSourceImageIO];
        } break;
    }
}

- (void)_updateSourceWebP
{
#if TYZIMAGE_WEBP_ENABLED
    _width = 0;
    _height = 0;
    _loopCount = 0;
    if (_webpSource) WebPDemuxDelete(_webpSource);
    _webpSource = NULL;
    dispatch_semaphore_wait(_framesLock, DISPATCH_TIME_FOREVER);
    _frames = nil;
    dispatch_semaphore_signal(_framesLock);
    
    /*
     https://developers.google.com/speed/webp/docs/api
     The documentation said we can use WebPIDecoder to decode webp progressively,
     but currently it can only returns an empty image (not same as progressive jpegs),
     so we don't use progressive decoding.
     
     When using WebPDecode() to decode multi-frame webp, we will get the error
     "VP8_STATUS_UNSUPPORTED_FEATURE", so we first use WebPDemuxer to unpack it.
     */
    
    WebPData webPData = {0};
    webPData.bytes = _data.bytes;
    webPData.size = _data.length;
    WebPDemuxer *demuxer = WebPDemux(&webPData);
    if (!demuxer) return;
    
    uint32_t webpFrameCount = WebPDemuxGetI(demuxer, WEBP_FF_FRAME_COUNT);
    uint32_t webpLoopCount =  WebPDemuxGetI(demuxer, WEBP_FF_LOOP_COUNT);
    uint32_t canvasWidth = WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_WIDTH);
    uint32_t canvasHeight = WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_HEIGHT);
    if (webpFrameCount == 0 || canvasWidth < 1 || canvasHeight < 1)
    {
        WebPDemuxDelete(demuxer);
        return;
    }
    
    NSMutableArray *frames = [NSMutableArray new];
    BOOL needBlend = NO;
    uint32_t iterIndex = 0;
    uint32_t lastBlendIndex = 0;
    WebPIterator iter = {0};
    if (WebPDemuxGetFrame(demuxer, 1, &iter))
    { // one-based index...
        do {
            _TYZImageDecoderFrame *frame = [_TYZImageDecoderFrame new];
            [frames addObject:frame];
            if (iter.dispose_method == WEBP_MUX_DISPOSE_BACKGROUND)
            {
                frame.dispose = TYZImageDisposeBackground;
            }
            if (iter.blend_method == WEBP_MUX_BLEND)
            {
                frame.blend = TYZImageBlendOver;
            }
            
            int canvasWidth = WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_WIDTH);
            int canvasHeight = WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_HEIGHT);
            frame.index = iterIndex;
            frame.duration = iter.duration / 1000.0;
            frame.width = iter.width;
            frame.height = iter.height;
            frame.hasAlpha = iter.has_alpha;
            frame.blend = iter.blend_method == WEBP_MUX_BLEND;
            frame.offsetX = iter.x_offset;
            frame.offsetY = canvasHeight - iter.y_offset - iter.height;
            
            BOOL sizeEqualsToCanvas = (iter.width == canvasWidth && iter.height == canvasHeight);
            BOOL offsetIsZero = (iter.x_offset == 0 && iter.y_offset == 0);
            frame.isFullSize = (sizeEqualsToCanvas && offsetIsZero);
            
            if ((!frame.blend || !frame.hasAlpha) && frame.isFullSize)
            {
                frame.blendFromIndex = lastBlendIndex = iterIndex;
            }
            else
            {
                if (frame.dispose && frame.isFullSize)
                {
                    frame.blendFromIndex = lastBlendIndex;
                    lastBlendIndex = iterIndex + 1;
                }
                else
                {
                    frame.blendFromIndex = lastBlendIndex;
                }
            }
            if (frame.index != frame.blendFromIndex) needBlend = YES;
            iterIndex++;
        } while (WebPDemuxNextFrame(&iter));
        WebPDemuxReleaseIterator(&iter);
    }
    if (frames.count != webpFrameCount)
    {
        WebPDemuxDelete(demuxer);
        return;
    }
    
    _width = canvasWidth;
    _height = canvasHeight;
    _frameCount = frames.count;
    _loopCount = webpLoopCount;
    _needBlend = needBlend;
    _webpSource = demuxer;
    dispatch_semaphore_wait(_framesLock, DISPATCH_TIME_FOREVER);
    _frames = frames;
    dispatch_semaphore_signal(_framesLock);
#endif
}

- (void)_updateSourceAPNG
{
    debugMethod();
    /*
     APNG extends PNG format to support animation, it was supported by ImageIO
     since iOS 8.
     
     We use a custom APNG decoder to make APNG available in old system, so we
     ignore the ImageIO's APNG frame info. Typically the custom decoder is a bit
     faster than ImageIO.
     */
    tyz_png_info_release(_apngSource);
    _apngSource = nil;
    [self _updateSourceImageIO]; // decode first frame
    if (_frameCount == 0)
    {// png decode failed
        debugLog(@"png decode failed");
        return;
    }
    if (!_finalized)
    {// ignore multi-frame before finalized.
        debugLog(@"ignore multi-frame before finalized.");
        return;
    }
//    NSLog(@"data.len=%lld", (long long)_data.length);
    tyz_png_info *apng = tyz_png_info_create(_data.bytes, (uint32_t)_data.length);
    if (!apng)
    {// apng decode failed
        debugLog(@"apng decode failed");
        return;
    }
    if (apng->apng_frame_num == 0 || (apng->apng_frame_num == 1 && apng->apng_first_frame_is_cover))
    {
        tyz_png_info_release(apng);
        debugLog(@"no animation");
        return; // no animation
    }
    if (_source)
    {// apng decode succeed, no longer need image souce
        CFRelease(_source);
        _source = NULL;
    }
//    NSLog(@"44444");
    uint32_t canvasWidth = apng->header.width;
    uint32_t canvasHeight = apng->header.height;
    NSMutableArray *frames = [NSMutableArray new];
    BOOL needBlend = NO;
    uint32_t lastBlendIndex = 0;
    for (uint32_t i = 0; i < apng->apng_frame_num; i++)
    {
        _TYZImageDecoderFrame *frame = [_TYZImageDecoderFrame new];
        [frames addObject:frame];
        
        tyz_png_frame_info *fi = apng->apng_frames + i;
        frame.index = i;
        frame.duration = tyz_png_delay_to_seconds(fi->frame_control.delay_num, fi->frame_control.delay_den);
        frame.hasAlpha = YES;
        frame.width = fi->frame_control.width;
        frame.height = fi->frame_control.height;
        frame.offsetX = fi->frame_control.x_offset;
        frame.offsetY = canvasHeight - fi->frame_control.y_offset - fi->frame_control.height;
        
        BOOL sizeEqualsToCanvas = (frame.width == canvasWidth && frame.height == canvasHeight);
        BOOL offsetIsZero = (fi->frame_control.x_offset == 0 && fi->frame_control.y_offset == 0);
        frame.isFullSize = (sizeEqualsToCanvas && offsetIsZero);
        
        switch (fi->frame_control.dispose_op)
        {
            case TYZ_PNG_DISPOSE_OP_BACKGROUND:
            {
                frame.dispose = TYZImageDisposeBackground;
            } break;
            case TYZ_PNG_DISPOSE_OP_PREVIOUS:
            {
                frame.dispose = TYZImageDisposePrevious;
            } break;
            default:
            {
                frame.dispose = TYZImageDisposeNone;
            } break;
        }
        switch (fi->frame_control.blend_op)
        {
            case TYZ_PNG_BLEND_OP_OVER:
            {
                frame.blend = TYZImageBlendOver;
            } break;
                
            default:
            {
                frame.blend = TYZImageBlendNone;
            } break;
        }
        
        if (frame.blend == TYZImageBlendNone && frame.isFullSize)
        {
            frame.blendFromIndex  = i;
            if (frame.dispose != TYZImageDisposePrevious)
            {
                lastBlendIndex = i;
            }
        }
        else
        {
            if (frame.dispose == TYZImageDisposeBackground && frame.isFullSize)
            {
                frame.blendFromIndex = lastBlendIndex;
                lastBlendIndex = i + 1;
            }
            else
            {
                frame.blendFromIndex = lastBlendIndex;
            }
        }
        if (frame.index != frame.blendFromIndex)
        {
            needBlend = YES;
        }
    }
    
    NSLog(@"dffd");
    
    _width = canvasWidth;
    _height = canvasHeight;
    _frameCount = frames.count;
    _loopCount = apng->apng_loop_num;
    _needBlend = needBlend;
    _apngSource = apng;
    dispatch_semaphore_wait(_framesLock, DISPATCH_TIME_FOREVER);
    _frames = frames;
    dispatch_semaphore_signal(_framesLock);
}

- (void)_updateSourceImageIO
{
    _width = 0;
    _height = 0;
    _orientation = UIImageOrientationUp;
    _loopCount = 0;
    dispatch_semaphore_wait(_framesLock, DISPATCH_TIME_FOREVER);
    _frames = nil;
    dispatch_semaphore_signal(_framesLock);
    
    if (!_source)
    {
        if (_finalized)
        {
            _source = CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
        }
        else
        {
            _source = CGImageSourceCreateIncremental(NULL);
            if (_source)
            {
                CGImageSourceUpdateData(_source, (__bridge CFDataRef)_data, false);
            }
        }
    }
    else
    {
        CGImageSourceUpdateData(_source, (__bridge CFDataRef)_data, _finalized);
    }
    if (!_source) return;
    
    // 得到图片的帖数
    _frameCount = CGImageSourceGetCount(_source);
//    debugLog(@"frameCount=%d", (int)_frameCount);
    if (_frameCount == 0) return;
    
    if (!_finalized)
    { // ignore multi-frame before finalized
        _frameCount = 1;
    }
    else
    {
//        debugLog(@"else");
        if (_type == TYZImageTypePNG)
        { // use custom apng decoder and ignore multi-frame
//            debugLog(@"use custom apng");
            _frameCount = 1;
        }
        if (_type == TYZImageTypeGIF)
        { // get gif loop count
            CFDictionaryRef properties = CGImageSourceCopyProperties(_source, NULL);
            if (properties)
            {
                CFTypeRef loop = CFDictionaryGetValue(properties, kCGImagePropertyGIFLoopCount);
                if (loop) CFNumberGetValue(loop, kCFNumberNSIntegerType, &_loopCount);
                CFRelease(properties);
            }
        }
    }
    
    /*
     ICO, GIF, APNG may contains multi-frame.
     */
    NSMutableArray *frames = [NSMutableArray new];
    for (NSUInteger i = 0; i < _frameCount; i++)
    {
        _TYZImageDecoderFrame *frame = [_TYZImageDecoderFrame new];
        frame.index = i;
        frame.blendFromIndex = i;
        frame.hasAlpha = YES;
        frame.isFullSize = YES;
        [frames addObject:frame];
        
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(_source, i, NULL);
        if (properties)
        {
            NSTimeInterval duration = 0;
            NSInteger orientationValue = 0, width = 0, height = 0;
            CFTypeRef value = NULL;
            
            value = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
            if (value) CFNumberGetValue(value, kCFNumberNSIntegerType, &width);
            value = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
            if (value) CFNumberGetValue(value, kCFNumberNSIntegerType, &height);
            if (_type == TYZImageTypeGIF)
            {
                CFDictionaryRef gif = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
                if (gif)
                {
                    // Use the unclamped frame delay if it exists.
                    value = CFDictionaryGetValue(gif, kCGImagePropertyGIFUnclampedDelayTime);
                    if (!value)
                    {
                        // Fall back to the clamped frame delay if the unclamped frame delay does not exist.
                        value = CFDictionaryGetValue(gif, kCGImagePropertyGIFDelayTime);
                    }
                    if (value)
                    {
                        CFNumberGetValue(value, kCFNumberDoubleType, &duration);
                    }
                }
            }
            
            frame.width = width;
            frame.height = height;
            frame.duration = duration;
            
            if (i == 0 && _width + _height == 0)
            { // init first frame
                _width = width;
                _height = height;
                value = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
                if (value)
                {
                    CFNumberGetValue(value, kCFNumberNSIntegerType, &orientationValue);
                    _orientation = TYZUIImageOrientationFromEXIFValue(orientationValue);
                }
            }
            CFRelease(properties);
        }
    }
    dispatch_semaphore_wait(_framesLock, DISPATCH_TIME_FOREVER);
    _frames = frames;
    dispatch_semaphore_signal(_framesLock);
}

- (CGImageRef)_newUnblendedImageAtIndex:(NSUInteger)index extendToCanvas:(BOOL)extendToCanvas decoded:(BOOL *)decoded CF_RETURNS_RETAINED
{
    if (!_finalized && index > 0) return NULL;
    if (_frames.count <= index) return NULL;
    _TYZImageDecoderFrame *frame = _frames[index];
    
    if (_source)
    {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_source, index, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(YES)});
        if (imageRef && extendToCanvas)
        {
            size_t width = CGImageGetWidth(imageRef);
            size_t height = CGImageGetHeight(imageRef);
            if (width == _width && height == _height)
            {
                CGImageRef imageRefExtended = TYZCGImageCreateDecodedCopy(imageRef, YES);
                if (imageRefExtended)
                {
                    CFRelease(imageRef);
                    imageRef = imageRefExtended;
                    if (decoded) *decoded = YES;
                }
            }
            else
            {
                CGContextRef context = CGBitmapContextCreate(NULL, _width, _height, 8, 0, TYZCGColorSpaceGetDeviceRGB(), kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
                if (context)
                {
                    CGContextDrawImage(context, CGRectMake(0, _height - height, width, height), imageRef);
                    CGImageRef imageRefExtended = CGBitmapContextCreateImage(context);
                    CFRelease(context);
                    if (imageRefExtended)
                    {
                        CFRelease(imageRef);
                        imageRef = imageRefExtended;
                        if (decoded) *decoded = YES;
                    }
                }
            }
        }
        return imageRef;
    }
    
    if (_apngSource)
    {
        uint32_t size = 0;
        uint8_t *bytes = tyz_png_copy_frame_data_at_index(_data.bytes, _apngSource, (uint32_t)index, &size);
        if (!bytes) return NULL;
        CGDataProviderRef provider = CGDataProviderCreateWithData(bytes, bytes, size, TYZCGDataProviderReleaseDataCallback);
        if (!provider)
        {
            free(bytes);
            bytes = NULL;
            return NULL;
        }
        bytes = NULL; // hold by provider
        
        CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
        if (!source)
        {
            CFRelease(provider);
            provider = NULL;
            return NULL;
        }
        CFRelease(provider);
        provider = NULL;
        
        if(CGImageSourceGetCount(source) < 1)
        {
            CFRelease(source);
            source = NULL;
            return NULL;
        }
        
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(YES)});
        CFRelease(source);
        source = NULL;
        if (!imageRef) return NULL;
        if (extendToCanvas)
        {
            CGContextRef context = CGBitmapContextCreate(NULL, _width, _height, 8, 0, TYZCGColorSpaceGetDeviceRGB(), kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst); //bgrA
            if (context)
            {
                CGContextDrawImage(context, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height), imageRef);
                CFRelease(imageRef);
                imageRef = CGBitmapContextCreateImage(context);
                CFRelease(context);
                if (decoded) *decoded = YES;
            }
        }
        return imageRef;
    }
    
#if TYZIMAGE_WEBP_ENABLED
    if (_webpSource)
    {
        WebPIterator iter;
        if (!WebPDemuxGetFrame(_webpSource, (int)(index + 1), &iter)) return NULL; // demux webp frame data
        // frame numbers are one-based in webp -----------^
        
        int frameWidth = iter.width;
        int frameHeight = iter.height;
        if (frameWidth < 1 || frameHeight < 1) return NULL;
        
        int width = extendToCanvas ? (int)_width : frameWidth;
        int height = extendToCanvas ? (int)_height : frameHeight;
        if (width > _width || height > _height) return NULL;
        
        const uint8_t *payload = iter.fragment.bytes;
        size_t payloadSize = iter.fragment.size;
        
        WebPDecoderConfig config;
        if (!WebPInitDecoderConfig(&config))
        {
            WebPDemuxReleaseIterator(&iter);
            return NULL;
        }
        if (WebPGetFeatures(payload , payloadSize, &config.input) != VP8_STATUS_OK)
        {
            WebPDemuxReleaseIterator(&iter);
            return NULL;
        }
        
        size_t bitsPerComponent = 8;
        size_t bitsPerPixel = 32;
        size_t bytesPerRow = TYZImageByteAlign(bitsPerPixel / 8 * width, 32);
        size_t length = bytesPerRow * height;
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst; //bgrA
        
        void *pixels = calloc(1, length);
        if (!pixels)
        {
            WebPDemuxReleaseIterator(&iter);
            return NULL;
        }
        
        config.output.colorspace = MODE_bgrA;
        config.output.is_external_memory = 1;
        config.output.u.RGBA.rgba = pixels;
        config.output.u.RGBA.stride = (int)bytesPerRow;
        config.output.u.RGBA.size = length;
        VP8StatusCode result = WebPDecode(payload, payloadSize, &config); // decode
        if ((result != VP8_STATUS_OK) && (result != VP8_STATUS_NOT_ENOUGH_DATA))
        {
            WebPDemuxReleaseIterator(&iter);
            free(pixels);
            return NULL;
        }
        WebPDemuxReleaseIterator(&iter);
        
        if (extendToCanvas && (iter.x_offset != 0 || iter.y_offset != 0))
        {
            void *tmp = calloc(1, length);
            if (tmp)
            {
                vImage_Buffer src = {pixels, height, width, bytesPerRow};
                vImage_Buffer dest = {tmp, height, width, bytesPerRow};
                vImage_CGAffineTransform transform = {1, 0, 0, 1, iter.x_offset, -iter.y_offset};
                uint8_t backColor[4] = {0};
                vImage_Error error = vImageAffineWarpCG_ARGB8888(&src, &dest, NULL, &transform, backColor, kvImageBackgroundColorFill);
                if (error == kvImageNoError)
                {
                    memcpy(pixels, tmp, length);
                }
                free(tmp);
            }
        }
        
        CGDataProviderRef provider = CGDataProviderCreateWithData(pixels, pixels, length, TYZCGDataProviderReleaseDataCallback);
        if (!provider)
        {
            free(pixels);
            return NULL;
        }
        pixels = NULL; // hold by provider
        
        CGImageRef image = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, TYZCGColorSpaceGetDeviceRGB(), bitmapInfo, provider, NULL, false, kCGRenderingIntentDefault);
        CFRelease(provider);
        if (decoded) *decoded = YES;
        return image;
    }
#endif
    
    return NULL;
}

- (BOOL)_createBlendContextIfNeeded
{
    if (!_blendCanvas)
    {
        _blendFrameIndex = NSNotFound;
        _blendCanvas = CGBitmapContextCreate(NULL, _width, _height, 8, 0, TYZCGColorSpaceGetDeviceRGB(), kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
    }
    BOOL suc = (_blendCanvas != NULL);
    return suc;
}

- (void)_blendImageWithFrame:(_TYZImageDecoderFrame *)frame
{
    if (frame.dispose == TYZImageDisposePrevious)
    {
        // nothing
    }
    else if (frame.dispose == TYZImageDisposeBackground)
    {
        CGContextClearRect(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height));
    }
    else
    { // no dispose
        if (frame.blend == TYZImageBlendOver)
        {
            CGImageRef unblendImage = [self _newUnblendedImageAtIndex:frame.index extendToCanvas:NO decoded:NULL];
            if (unblendImage)
            {
                CGContextDrawImage(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height), unblendImage);
                CFRelease(unblendImage);
            }
        }
        else
        {
            CGContextClearRect(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height));
            CGImageRef unblendImage = [self _newUnblendedImageAtIndex:frame.index extendToCanvas:NO decoded:NULL];
            if (unblendImage)
            {
                CGContextDrawImage(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height), unblendImage);
                CFRelease(unblendImage);
            }
        }
    }
}

- (CGImageRef)_newBlendedImageWithFrame:(_TYZImageDecoderFrame *)frame CF_RETURNS_RETAINED
{
    CGImageRef imageRef = NULL;
    if (frame.dispose == TYZImageDisposePrevious)
    {
        if (frame.blend == TYZImageBlendOver)
        {
            CGImageRef previousImage = CGBitmapContextCreateImage(_blendCanvas);
            CGImageRef unblendImage = [self _newUnblendedImageAtIndex:frame.index extendToCanvas:NO decoded:NULL];
            if (unblendImage)
            {
                CGContextDrawImage(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height), unblendImage);
                CFRelease(unblendImage);
            }
            imageRef = CGBitmapContextCreateImage(_blendCanvas);
            CGContextClearRect(_blendCanvas, CGRectMake(0, 0, _width, _height));
            if (previousImage)
            {
                CGContextDrawImage(_blendCanvas, CGRectMake(0, 0, _width, _height), previousImage);
                CFRelease(previousImage);
            }
        }
        else
        {
            CGImageRef previousImage = CGBitmapContextCreateImage(_blendCanvas);
            CGImageRef unblendImage = [self _newUnblendedImageAtIndex:frame.index extendToCanvas:NO decoded:NULL];
            if (unblendImage)
            {
                CGContextClearRect(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height));
                CGContextDrawImage(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height), unblendImage);
                CFRelease(unblendImage);
            }
            imageRef = CGBitmapContextCreateImage(_blendCanvas);
            CGContextClearRect(_blendCanvas, CGRectMake(0, 0, _width, _height));
            if (previousImage)
            {
                CGContextDrawImage(_blendCanvas, CGRectMake(0, 0, _width, _height), previousImage);
                CFRelease(previousImage);
            }
        }
    }
    else if (frame.dispose == TYZImageDisposeBackground)
    {
        if (frame.blend == TYZImageBlendOver)
        {
            CGImageRef unblendImage = [self _newUnblendedImageAtIndex:frame.index extendToCanvas:NO decoded:NULL];
            if (unblendImage)
            {
                CGContextDrawImage(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height), unblendImage);
                CFRelease(unblendImage);
            }
            imageRef = CGBitmapContextCreateImage(_blendCanvas);
            CGContextClearRect(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height));
        }
        else
        {
            CGImageRef unblendImage = [self _newUnblendedImageAtIndex:frame.index extendToCanvas:NO decoded:NULL];
            if (unblendImage)
            {
                CGContextClearRect(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height));
                CGContextDrawImage(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height), unblendImage);
                CFRelease(unblendImage);
            }
            imageRef = CGBitmapContextCreateImage(_blendCanvas);
            CGContextClearRect(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height));
        }
    }
    else
    { // no dispose
        if (frame.blend == TYZImageBlendOver)
        {
            CGImageRef unblendImage = [self _newUnblendedImageAtIndex:frame.index extendToCanvas:NO decoded:NULL];
            if (unblendImage)
            {
                CGContextDrawImage(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height), unblendImage);
                CFRelease(unblendImage);
            }
            imageRef = CGBitmapContextCreateImage(_blendCanvas);
        }
        else
        {
            CGImageRef unblendImage = [self _newUnblendedImageAtIndex:frame.index extendToCanvas:NO decoded:NULL];
            if (unblendImage)
            {
                CGContextClearRect(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height));
                CGContextDrawImage(_blendCanvas, CGRectMake(frame.offsetX, frame.offsetY, frame.width, frame.height), unblendImage);
                CFRelease(unblendImage);
            }
            imageRef = CGBitmapContextCreateImage(_blendCanvas);
        }
    }
    return imageRef;
}


@end


#pragma mark - Encoder 编码
@implementation TYZImageEncoder
{
    NSMutableArray *_images;
    NSMutableArray *_durations;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"TYZImageEncoder init error" reason:@"TYZImageEncoder must be initialized with a type. Use 'initWithType:' instead." userInfo:nil];
    return [self initWithType:TYZImageTypeUnknown];
}

- (instancetype)initWithType:(TYZImageType)type
{
    if (type == TYZImageTypeUnknown || type >= TYZImageTypeOther) return nil;
    
#if !TYZIMAGE_WEBP_ENABLED
    if (type == TYZImageTypeWebP) return nil;
#endif
    
    self = [super init];
    if (!self) return nil;
    _type = type;
    _images = [NSMutableArray new];
    _durations = [NSMutableArray new];
    
    switch (type)
    {
        case TYZImageTypeJPEG:
        case TYZImageTypeJPEG2000:
        {
            _quality = 0.9;
        } break;
        case TYZImageTypeTIFF:
        case TYZImageTypeBMP:
        case TYZImageTypeGIF:
        case TYZImageTypeICO:
        case TYZImageTypeICNS:
        case TYZImageTypePNG:
        {
            _quality = 1;
            _lossless = YES;
        } break;
        case TYZImageTypeWebP:
        {
            _quality = 0.8;
        } break;
        default:
            break;
    }
    
    return self;
}

- (void)setQuality:(CGFloat)quality
{
    _quality = quality < 0 ? 0 : quality > 1 ? 1 : quality;
}

- (void)addImage:(UIImage *)image duration:(NSTimeInterval)duration
{
    if (!image.CGImage) return;
    duration = duration < 0 ? 0 : duration;
    [_images addObject:image];
    [_durations addObject:@(duration)];
}

- (void)addImageWithData:(NSData *)data duration:(NSTimeInterval)duration
{
    if (data.length == 0) return;
    duration = duration < 0 ? 0 : duration;
    [_images addObject:data];
    [_durations addObject:@(duration)];
}

- (void)addImageWithFile:(NSString *)path duration:(NSTimeInterval)duration
{
    if (path.length == 0) return;
    duration = duration < 0 ? 0 : duration;
    NSURL *url = [NSURL URLWithString:path];
    if (!url) return;
    [_images addObject:url];
    [_durations addObject:@(duration)];
}

- (BOOL)_imageIOAvaliable
{
    switch (_type)
    {
        case TYZImageTypeJPEG:
        case TYZImageTypeJPEG2000:
        case TYZImageTypeTIFF:
        case TYZImageTypeBMP:
        case TYZImageTypeICO:
        case TYZImageTypeICNS:
        case TYZImageTypeGIF:
        {
            return _images.count > 0;
        } break;
        case TYZImageTypePNG:
        {
            return _images.count == 1;
        } break;
        case TYZImageTypeWebP:
        {
            return NO;
        } break;
        default: return NO;
    }
}

- (CGImageDestinationRef)_newImageDestination:(id)dest imageCount:(NSUInteger)count CF_RETURNS_RETAINED
{
    if (!dest) return nil;
    CGImageDestinationRef destination = NULL;
    if ([dest isKindOfClass:[NSString class]])
    {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:dest];
        if (url)
        {
            destination = CGImageDestinationCreateWithURL((CFURLRef)url, TYZImageTypeToUTType(_type), count, NULL);
        }
    }
    else if ([dest isKindOfClass:[NSMutableData class]])
    {
        destination = CGImageDestinationCreateWithData((CFMutableDataRef)dest, TYZImageTypeToUTType(_type), count, NULL);
    }
    return destination;
}

- (void)_encodeImageWithDestination:(CGImageDestinationRef)destination imageCount:(NSUInteger)count
{
    if (_type == TYZImageTypeGIF)
    {
        NSDictionary *gifProperty = @{(__bridge id)kCGImagePropertyGIFDictionary:
                                          @{(__bridge id)kCGImagePropertyGIFLoopCount: @(_loopCount)}};
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperty);
    }
    
    for (int i = 0; i < count; i++)
    {
        @autoreleasepool {
            id imageSrc = _images[i];
            NSDictionary *frameProperty = NULL;
            if (_type == TYZImageTypeGIF && count > 1)
            {
                frameProperty = @{(NSString *)kCGImagePropertyGIFDictionary : @{(NSString *) kCGImagePropertyGIFDelayTime:_durations[i]}};
            }
            else
            {
                frameProperty = @{(id)kCGImageDestinationLossyCompressionQuality : @(_quality)};
            }
            
            if ([imageSrc isKindOfClass:[UIImage class]])
            {
                UIImage *image = imageSrc;
                if (image.imageOrientation != UIImageOrientationUp && image.CGImage)
                {
                    CGBitmapInfo info = CGImageGetBitmapInfo(image.CGImage) | CGImageGetAlphaInfo(image.CGImage);
                    CGImageRef rotated = TYZCGImageCreateCopyWithOrientation(image.CGImage, image.imageOrientation, info);
                    if (rotated)
                    {
                        image = [UIImage imageWithCGImage:rotated];
                        CFRelease(rotated);
                    }
                }
                if (image.CGImage) CGImageDestinationAddImage(destination, ((UIImage *)imageSrc).CGImage, (CFDictionaryRef)frameProperty);
            }
            else if ([imageSrc isKindOfClass:[NSURL class]])
            {
                CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)imageSrc, NULL);
                if (source)
                {
                    CGImageDestinationAddImageFromSource(destination, source, i, (CFDictionaryRef)frameProperty);
                    CFRelease(source);
                }
            }
            else if ([imageSrc isKindOfClass:[NSData class]])
            {
                CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)imageSrc, NULL);
                if (source)
                {
                    CGImageDestinationAddImageFromSource(destination, source, i, (CFDictionaryRef)frameProperty);
                    CFRelease(source);
                }
            }
        }
    }
}

- (CGImageRef)_newCGImageFromIndex:(NSUInteger)index decoded:(BOOL)decoded CF_RETURNS_RETAINED
{
    UIImage *image = nil;
    id imageSrc= _images[index];
    if ([imageSrc isKindOfClass:[UIImage class]])
    {
        image = imageSrc;
    }
    else if ([imageSrc isKindOfClass:[NSURL class]])
    {
        image = [UIImage imageWithContentsOfFile:((NSURL *)imageSrc).absoluteString];
    }
    else if ([imageSrc isKindOfClass:[NSData class]])
    {
        image = [UIImage imageWithData:imageSrc];
    }
    if (!image) return NULL;
    CGImageRef imageRef = image.CGImage;
    if (!imageRef) return NULL;
    if (image.imageOrientation != UIImageOrientationUp)
    {
        return TYZCGImageCreateCopyWithOrientation(imageRef, image.imageOrientation, kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
    }
    if (decoded)
    {
        return TYZCGImageCreateDecodedCopy(imageRef, YES);
    }
    return (CGImageRef)CFRetain(imageRef);
}

- (NSData *)_encodeWithImageIO
{
    NSMutableData *data = [NSMutableData new];
    NSUInteger count = _type == TYZImageTypeGIF ? _images.count : 1;
    CGImageDestinationRef destination = [self _newImageDestination:data imageCount:count];
    BOOL suc = NO;
    if (destination)
    {
        [self _encodeImageWithDestination:destination imageCount:count];
        suc = CGImageDestinationFinalize(destination);
        CFRelease(destination);
    }
    if (suc && data.length > 0)
    {
        return data;
    }
    else
    {
        return nil;
    }
}

- (BOOL)_encodeWithImageIO:(NSString *)path
{
    NSUInteger count = _type == TYZImageTypeGIF ? _images.count : 1;
    CGImageDestinationRef destination = [self _newImageDestination:path imageCount:count];
    BOOL suc = NO;
    if (destination)
    {
        [self _encodeImageWithDestination:destination imageCount:count];
        suc = CGImageDestinationFinalize(destination);
        CFRelease(destination);
    }
    return suc;
}

- (NSData *)_encodeAPNG
{
    // encode APNG (ImageIO doesn't support APNG encoding, so we use a custom encoder)
    NSMutableArray *pngDatas = [NSMutableArray new];
    NSMutableArray *pngSizes = [NSMutableArray new];
    NSUInteger canvasWidth = 0, canvasHeight = 0;
    for (int i = 0; i < _images.count; i++)
    {
        CGImageRef decoded = [self _newCGImageFromIndex:i decoded:YES];
        if (!decoded) return nil;
        CGSize size = CGSizeMake(CGImageGetWidth(decoded), CGImageGetHeight(decoded));
        [pngSizes addObject:[NSValue valueWithCGSize:size]];
        if (canvasWidth < size.width) canvasWidth = size.width;
        if (canvasHeight < size.height) canvasHeight = size.height;
        CFDataRef frameData = TYZCGImageCreateEncodedData(decoded, TYZImageTypePNG, 1);
        CFRelease(decoded);
        if (!frameData) return nil;
        [pngDatas addObject:(__bridge id)(frameData)];
        CFRelease(frameData);
        if (size.width < 1 || size.height < 1) return nil;
    }
    CGSize firstFrameSize = [(NSValue *)[pngSizes firstObject] CGSizeValue];
    if (firstFrameSize.width < canvasWidth || firstFrameSize.height < canvasHeight)
    {
        CGImageRef decoded = [self _newCGImageFromIndex:0 decoded:YES];
        if (!decoded) return nil;
        CGContextRef context = CGBitmapContextCreate(NULL, canvasWidth, canvasHeight, 8,
                                                     0, TYZCGColorSpaceGetDeviceRGB(), kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
        if (!context)
        {
            CFRelease(decoded);
            return nil;
        }
        CGContextDrawImage(context, CGRectMake(0, canvasHeight - firstFrameSize.height, firstFrameSize.width, firstFrameSize.height), decoded);
        CFRelease(decoded);
        CGImageRef extendedImage = CGBitmapContextCreateImage(context);
        CFRelease(context);
        if (!extendedImage) return nil;
        CFDataRef frameData = TYZCGImageCreateEncodedData(extendedImage, TYZImageTypePNG, 1);
        if (!frameData)
        {
            CFRelease(extendedImage);
            return nil;
        }
        pngDatas[0] = (__bridge id)(frameData);
        CFRelease(frameData);
    }
    
    NSData *firstFrameData = pngDatas[0];
    tyz_png_info *info = tyz_png_info_create(firstFrameData.bytes, (uint32_t)firstFrameData.length);
    if (!info) return nil;
    NSMutableData *result = [NSMutableData new];
    BOOL insertBefore = NO, insertAfter = NO;
    uint32_t apngSequenceIndex = 0;
    
    uint32_t png_header[2];
    png_header[0] = TYZ_FOUR_CC(0x89, 0x50, 0x4E, 0x47);
    png_header[1] = TYZ_FOUR_CC(0x0D, 0x0A, 0x1A, 0x0A);
    
    [result appendBytes:png_header length:8];
    
    for (int i = 0; i < info->chunk_num; i++)
    {
        tyz_png_chunk_info *chunk = info->chunks + i;
        
        if (!insertBefore && chunk->fourcc == TYZ_FOUR_CC('I', 'D', 'A', 'T'))
        {
            insertBefore = YES;
            // insert acTL (APNG Control)
            uint32_t acTL[5] = {0};
            acTL[0] = tyz_swap_endian_uint32(8); //length
            acTL[1] = TYZ_FOUR_CC('a', 'c', 'T', 'L'); // fourcc
            acTL[2] = tyz_swap_endian_uint32((uint32_t)pngDatas.count); // num frames
            acTL[3] = tyz_swap_endian_uint32((uint32_t)_loopCount); // num plays
            acTL[4] = tyz_swap_endian_uint32((uint32_t)crc32(0, (const Bytef *)(acTL + 1), 12)); //crc32
            [result appendBytes:acTL length:20];
            
            // insert fcTL (first frame control)
            tyz_png_chunk_fcTL chunk_fcTL = {0};
            chunk_fcTL.sequence_number = apngSequenceIndex;
            chunk_fcTL.width = (uint32_t)firstFrameSize.width;
            chunk_fcTL.height = (uint32_t)firstFrameSize.height;
            tyz_png_delay_to_fraction([(NSNumber *)_durations[0] doubleValue], &chunk_fcTL.delay_num, &chunk_fcTL.delay_den);
            chunk_fcTL.delay_num = chunk_fcTL.delay_num;
            chunk_fcTL.delay_den = chunk_fcTL.delay_den;
            chunk_fcTL.dispose_op = TYZ_PNG_DISPOSE_OP_BACKGROUND;
            chunk_fcTL.blend_op = TYZ_PNG_BLEND_OP_SOURCE;
            
            uint8_t fcTL[38] = {0};
            *((uint32_t *)fcTL) = tyz_swap_endian_uint32(26); //length
            *((uint32_t *)(fcTL + 4)) = TYZ_FOUR_CC('f', 'c', 'T', 'L'); // fourcc
            tyz_png_chunk_fcTL_write(&chunk_fcTL, fcTL + 8);
            *((uint32_t *)(fcTL + 34)) = tyz_swap_endian_uint32((uint32_t)crc32(0, (const Bytef *)(fcTL + 4), 30));
            [result appendBytes:fcTL length:38];
            
            apngSequenceIndex++;
        }
        
        if (!insertAfter && insertBefore && chunk->fourcc != TYZ_FOUR_CC('I', 'D', 'A', 'T'))
        {
            insertAfter = YES;
            // insert fcTL and fdAT (APNG frame control and data)
            
            for (int i = 1; i < pngDatas.count; i++)
            {
                NSData *frameData = pngDatas[i];
                tyz_png_info *frame = tyz_png_info_create(frameData.bytes, (uint32_t)frameData.length);
                if (!frame)
                {
                    tyz_png_info_release(info);
                    return nil;
                }
                
                // insert fcTL (first frame control)
                tyz_png_chunk_fcTL chunk_fcTL = {0};
                chunk_fcTL.sequence_number = apngSequenceIndex;
                chunk_fcTL.width = frame->header.width;
                chunk_fcTL.height = frame->header.height;
                tyz_png_delay_to_fraction([(NSNumber *)_durations[0] doubleValue], &chunk_fcTL.delay_num, &chunk_fcTL.delay_den);
                chunk_fcTL.delay_num = chunk_fcTL.delay_num;
                chunk_fcTL.delay_den = chunk_fcTL.delay_den;
                chunk_fcTL.dispose_op = TYZ_PNG_DISPOSE_OP_BACKGROUND;
                chunk_fcTL.blend_op = TYZ_PNG_BLEND_OP_SOURCE;
                
                uint8_t fcTL[38] = {0};
                *((uint32_t *)fcTL) = tyz_swap_endian_uint32(26); //length
                *((uint32_t *)(fcTL + 4)) = TYZ_FOUR_CC('f', 'c', 'T', 'L'); // fourcc
                tyz_png_chunk_fcTL_write(&chunk_fcTL, fcTL + 8);
                *((uint32_t *)(fcTL + 34)) = tyz_swap_endian_uint32((uint32_t)crc32(0, (const Bytef *)(fcTL + 4), 30));
                [result appendBytes:fcTL length:38];
                
                apngSequenceIndex++;
                
                // insert fdAT (frame data)
                for (int d = 0; d < frame->chunk_num; d++)
                {
                    tyz_png_chunk_info *dchunk = frame->chunks + d;
                    if (dchunk->fourcc == TYZ_FOUR_CC('I', 'D', 'A', 'T'))
                    {
                        uint32_t length = tyz_swap_endian_uint32(dchunk->length + 4);
                        [result appendBytes:&length length:4]; //length
                        uint32_t fourcc = TYZ_FOUR_CC('f', 'd', 'A', 'T');
                        [result appendBytes:&fourcc length:4]; //fourcc
                        uint32_t sq = tyz_swap_endian_uint32(apngSequenceIndex);
                        [result appendBytes:&sq length:4]; //data (sq)
                        [result appendBytes:(((uint8_t *)frameData.bytes) + dchunk->offset + 8) length:dchunk->length]; //data
                        uint8_t *bytes = ((uint8_t *)result.bytes) + result.length - dchunk->length - 8;
                        uint32_t crc = tyz_swap_endian_uint32((uint32_t)crc32(0, bytes, dchunk->length + 8));
                        [result appendBytes:&crc length:4]; //crc
                        
                        apngSequenceIndex++;
                    }
                }
                tyz_png_info_release(frame);
            }
        }
        
        [result appendBytes:((uint8_t *)firstFrameData.bytes) + chunk->offset length:chunk->length + 12];
    }
    tyz_png_info_release(info);
    return result;
}

- (NSData *)_encodeWebP
{
#if TYZIMAGE_WEBP_ENABLED
    // encode webp
    NSMutableArray *webpDatas = [NSMutableArray new];
    for (NSUInteger i = 0; i < _images.count; i++)
    {
        CGImageRef image = [self _newCGImageFromIndex:i decoded:NO];
        if (!image) return nil;
        CFDataRef frameData = TYZCGImageCreateEncodedWebPData(image, _lossless, _quality, 4, TYZImagePresetDefault);
        CFRelease(image);
        if (!frameData) return nil;
        [webpDatas addObject:(__bridge id)frameData];
        CFRelease(frameData);
    }
    if (webpDatas.count == 1)
    {
        return webpDatas.firstObject;
    }
    else
    {
        // multi-frame webp
        WebPMux *mux = WebPMuxNew();
        if (!mux) return nil;
        for (NSUInteger i = 0; i < _images.count; i++)
        {
            NSData *data = webpDatas[i];
            NSNumber *duration = _durations[i];
            WebPMuxFrameInfo frame = {0};
            frame.bitstream.bytes = data.bytes;
            frame.bitstream.size = data.length;
            frame.duration = (int)(duration.floatValue * 1000.0);
            frame.id = WEBP_CHUNK_ANMF;
            frame.dispose_method = WEBP_MUX_DISPOSE_BACKGROUND;
            frame.blend_method = WEBP_MUX_NO_BLEND;
            if (WebPMuxPushFrame(mux, &frame, 0) != WEBP_MUX_OK)
            {
                WebPMuxDelete(mux);
                return nil;
            }
        }
        
        WebPMuxAnimParams params = {(uint32_t)0, (int)_loopCount};
        if (WebPMuxSetAnimationParams(mux, &params) != WEBP_MUX_OK)
        {
            WebPMuxDelete(mux);
            return nil;
        }
        
        WebPData output_data;
        WebPMuxError error = WebPMuxAssemble(mux, &output_data);
        WebPMuxDelete(mux);
        if (error != WEBP_MUX_OK)
        {
            return nil;
        }
        NSData *result = [NSData dataWithBytes:output_data.bytes length:output_data.size];
        WebPDataClear(&output_data);
        return result.length ? result : nil;
    }
#else
    return nil;
#endif
}
- (NSData *)encode
{
    if (_images.count == 0) return nil;
    
    if ([self _imageIOAvaliable]) return [self _encodeWithImageIO];
    if (_type == TYZImageTypePNG) return [self _encodeAPNG];
    if (_type == TYZImageTypeWebP) return [self _encodeWebP];
    return nil;
}

- (BOOL)encodeToFile:(NSString *)path
{
    if (_images.count == 0 || path.length == 0) return NO;
    
    if ([self _imageIOAvaliable]) return [self _encodeWithImageIO:path];
    NSData *data = [self encode];
    if (!data) return NO;
    return [data writeToFile:path atomically:YES];
}

+ (NSData *)encodeImage:(UIImage *)image type:(TYZImageType)type quality:(CGFloat)quality
{
    TYZImageEncoder *encoder = [[TYZImageEncoder alloc] initWithType:type];
    encoder.quality = quality;
    [encoder addImage:image duration:0];
    return [encoder encode];
}

+ (NSData *)encodeImageWithDecoder:(TYZImageDecoder *)decoder type:(TYZImageType)type quality:(CGFloat)quality
{
    if (!decoder || decoder.frameCount == 0) return nil;
    TYZImageEncoder *encoder = [[TYZImageEncoder alloc] initWithType:type];
    encoder.quality = quality;
    for (int i = 0; i < decoder.frameCount; i++)
    {
        UIImage *frame = [decoder frameAtIndex:i decodeForDisplay:YES].image;
        [encoder addImageWithData:UIImagePNGRepresentation(frame) duration:[decoder frameDurationAtIndex:i]];
    }
    return encoder.encode;
}



@end


@implementation UIImage (TYZImageCoder)

- (instancetype)imageByDecoded
{
    if (self.isDecodedForDisplay) return self;
    CGImageRef imageRef = self.CGImage;
    if (!imageRef) return self;
    CGImageRef newImageRef = TYZCGImageCreateDecodedCopy(imageRef, YES);
    if (!newImageRef) return self;
    UIImage *newImage = [[self.class alloc] initWithCGImage:newImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(newImageRef);
    if (!newImage) newImage = self; // decode failed, return self.
    newImage.isDecodedForDisplay = YES;
    return newImage;
}

- (BOOL)isDecodedForDisplay
{
    if (self.images.count > 1) return YES;
    NSNumber *num = objc_getAssociatedObject(self, @selector(isDecodedForDisplay));
    return [num boolValue];
}

- (void)setIsDecodedForDisplay:(BOOL)isDecodedForDisplay
{
    objc_setAssociatedObject(self, @selector(isDecodedForDisplay), @(isDecodedForDisplay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)saveToAlbumWithCompletionBlock:(void(^)(NSURL *assetURL, NSError *error))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [self _imageDataRepresentationForSystem:YES];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error){
            if (!completionBlock) return;
            if (pthread_main_np())
            {
                completionBlock(assetURL, error);
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(assetURL, error);
                });
            }
        }];
    });
}

- (NSData *)imageDataRepresentation
{
    return [self _imageDataRepresentationForSystem:NO];
}

/// @param forSystem YES: used for system album (PNG/JPEG/GIF), NO: used for TYZImage (PNG/JPEG/GIF/WebP)
- (NSData *)_imageDataRepresentationForSystem:(BOOL)forSystem
{
    NSData *data = nil;
    if ([self isKindOfClass:[TYZImage class]])
    {
        TYZImage *image = (id)self;
        if (image.animatedImageData)
        {
            if (forSystem)
            { // system only support GIF and PNG
                if (image.animatedImageType == TYZImageTypeGIF ||
                    image.animatedImageType == TYZImageTypePNG)
                {
                    data = image.animatedImageData;
                }
            }
            else
            {
                data = image.animatedImageData;
            }
        }
    }
    if (!data)
    {
        CGImageRef imageRef = self.CGImage ? (CGImageRef)CFRetain(self.CGImage) : nil;
        if (imageRef)
        {
            CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
            CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
            BOOL hasAlpha = NO;
            if (alphaInfo == kCGImageAlphaPremultipliedLast ||
                alphaInfo == kCGImageAlphaPremultipliedFirst ||
                alphaInfo == kCGImageAlphaLast ||
                alphaInfo == kCGImageAlphaFirst)
            {
                hasAlpha = YES;
            }
            if (self.imageOrientation != UIImageOrientationUp)
            {
                CGImageRef rotated = TYZCGImageCreateCopyWithOrientation(imageRef, self.imageOrientation, bitmapInfo | alphaInfo);
                if (rotated)
                {
                    CFRelease(imageRef);
                    imageRef = rotated;
                }
            }
            @autoreleasepool {
                UIImage *newImage = [UIImage imageWithCGImage:imageRef];
                if (newImage)
                {
                    if (hasAlpha)
                    {
                        data = UIImagePNGRepresentation([UIImage imageWithCGImage:imageRef]);
                    }
                    else
                    {
                        data = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 0.9); // same as Apple's example
                    }
                }
            }
            CFRelease(imageRef);
        }
    }
    if (!data)
    {
        data = UIImagePNGRepresentation(self);
    }
    return data;
}

@end











