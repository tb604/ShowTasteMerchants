//
//  TYZFileHash.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZFileHash.h"
#include <CommonCrypto/CommonCrypto.h>
#include <zlib.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#define BUF_SIZE (1024 * 512) // 512KB per read
#define BLOCK_LOOP_FACTOR 16 // 8MB (0.5MB*16) per block callback
#define BUF_SIZE_NO_PROGRESS (1024 * 1024) // 1MB
#else
#define BUF_SIZE (1024 * 1024 * 16) // 16MB per read
#define BLOCK_LOOP_FACTOR 16 // 64MB (16MB*16) per block callback
#define BUF_SIZE_NO_PROGRESS (1024 * 1024 * 16) // 16MB
#endif

@implementation TYZFileHash

/**
 Start calculate file hash and return the result.(开始文件哈希计算并返回结果。)
 
 @discussion The calling thread is blocked until the asynchronous hash progress finished.
 
 @param filePath The path to the file to access.
 
 @param types File hash algorithm types.
 
 @return File hash result, or nil when an error occurs.
 */
+ (TYZFileHash *)hashForFile:(NSString *)filePath types:(TYZFileHashType)types
{
    return [self hashForFile:filePath types:types usingBlock:nil];
}

/**
 *  Start calculate file hash and return the result.
 *
 *  @discussion The calling thread is blocked until the asynchronous hash progress finished or cancelled.
 *
 *  @param filePath The path to the file to access.
 *  @param types    File hash algorithm types.
 *  @param block    A block which is called in progress. The block takes 3 arguments:
 'totalSize' is the total file size in bytes;
 'processedSize' is the processed file size in bytes.
 'stop' is a reference to a Boolean value, which can be set to YES to stop further processing. If the block stop the processing, it just returns nil.
 *
 *  @return File hash result, or nil when an error occurs.
 */
+ (TYZFileHash *)hashForFile:(NSString *)filePath types:(TYZFileHashType)types usingBlock:(void(^)(UInt64 totalSize, UInt64 processedSize, BOOL *stop))block
{
    TYZFileHash *hash = nil;
    BOOL stop = NO, done = NO;
    int64_t file_size = 0, readed = 0, loop = 0;
    const char *path = 0;
    FILE *fd = NULL;
    char *buf = NULL;
    
    int hash_type_total = 10;
    void *ctx[hash_type_total];
    int(*ctx_init[hash_type_total])(void *);
    int(*ctx_update[hash_type_total])(void *, const void *, CC_LONG);
    int(*ctx_final[hash_type_total])(unsigned char *, void *);
    long digist_length[hash_type_total];
    unsigned char *digest[hash_type_total];
    
    for (int i=0; i<hash_type_total; i++)
    {
        ctx[i] = NULL;
        ctx_init[i] = NULL;
        ctx_update[i] = NULL;
        ctx_final[i] = NULL;
        digist_length[i] = 0;
        digest[i] = 0;
    }
    
#define init_hash(Type,Init,Update,Final,Length) \
ctx[ctx_index] = malloc(sizeof(Type)); \
ctx_init[ctx_index] = (int (*)(void *))Init; \
ctx_update[ctx_index] = (int (*)(void *, const void *, CC_LONG))Update; \
ctx_final[ctx_index] = (int (*)(unsigned char *, void *))Final; \
digist_length[ctx_index] = Length;
    
    int ctx_index = 0;
    if (types & TYZFileHashTypeMD2)
    {
        init_hash(CC_MD2_CTX, CC_MD2_Init, CC_MD2_Update, CC_MD2_Final, CC_MD2_DIGEST_LENGTH);
    }
    ctx_index++;
    if (types & TYZFileHashTypeMD4)
    {
        init_hash(CC_MD4_CTX, CC_MD4_Init, CC_MD4_Update, CC_MD4_Final, CC_MD4_DIGEST_LENGTH);
    }
    ctx_index++;
    if (types & TYZFileHashTypeMD5)
    {
        init_hash(CC_MD5_CTX, CC_MD5_Init, CC_MD5_Update, CC_MD5_Final, CC_MD5_DIGEST_LENGTH);
    }
    ctx_index++;
    if (types & TYZFileHashTypeSHA1)
    {
        init_hash(CC_SHA1_CTX, CC_SHA1_Init, CC_SHA1_Update, CC_SHA1_Final, CC_SHA1_DIGEST_LENGTH);
    }
    ctx_index++;
    if (types & TYZFileHashTypeSHA224)
    {
        init_hash(CC_SHA256_CTX, CC_SHA224_Init, CC_SHA224_Update, CC_SHA224_Final, CC_SHA224_DIGEST_LENGTH);
    }
    ctx_index++;
    if (types & TYZFileHashTypeSHA256)
    {
        init_hash(CC_SHA256_CTX, CC_SHA256_Init, CC_SHA256_Update, CC_SHA256_Final, CC_SHA256_DIGEST_LENGTH);
    }
    ctx_index++;
    if (types & TYZFileHashTypeSHA384)
    {
        init_hash(CC_SHA512_CTX, CC_SHA384_Init, CC_SHA384_Update, CC_SHA384_Final, CC_SHA384_DIGEST_LENGTH);
    }
    ctx_index++;
    if (types & TYZFileHashTypeSHA512)
    {
        init_hash(CC_SHA512_CTX, CC_SHA512_Init, CC_SHA512_Update, CC_SHA512_Final, CC_SHA512_DIGEST_LENGTH);
    }
    ctx_index++;
    if (types & TYZFileHashTypeCRC32)
    {
        init_hash(uLong, crc32_init, crc32_update, crc32_final, sizeof(uint32_t));
    }
    ctx_index++;
    if (types & TYZFileHashTypeAdler32)
    {
        init_hash(uLong, adler32_init, adler32_update, adler32_final, sizeof(uint32_t));
    }
    
#undef init_hash
    
    int hash_type_this = 0;
    for (int i = 0; i < hash_type_total; i++)
    {
        if (digist_length[i])
        {
            hash_type_this++;
            digest[i] = malloc(digist_length[i]);
            if (digest[i] == NULL || ctx[i] == NULL) goto cleanup;
        }
    }
    if (hash_type_this == 0) goto cleanup;
    
    buf = malloc(block ? BUF_SIZE : BUF_SIZE_NO_PROGRESS);
    if (!buf) goto cleanup;
    
    if (filePath.length == 0) goto cleanup;
    path = [filePath cStringUsingEncoding:NSUTF8StringEncoding];
    fd = fopen(path, "rb");
    if (!fd) goto cleanup;
    
    if (fseeko(fd, 0, SEEK_END) != 0) goto cleanup;
    file_size = ftell(fd);
    if (fseeko(fd, 0, SEEK_SET) != 0) goto cleanup;
    if (file_size < 0) goto cleanup;
    
    // init hash context
    for (int i = 0; i < hash_type_total; i++)
    {
        if (ctx[i]) ctx_init[i](ctx[i]);
    }
    
    // read stream and calculate checksum in a single loop
    // 'dispatch_io' has better performance, I will rewrite it later...
    if (block)
    {
        while (!done && !stop)
        {
            size_t size = fread(buf, 1, BUF_SIZE, fd);
            if (size < BUF_SIZE)
            {
                if (feof(fd)) done = YES;    // finish
                else { stop = YES; break; }  // error
            }
            for (int i = 0; i < hash_type_total; i++)
            {
                if (ctx[i]) ctx_update[i](ctx[i], buf, (CC_LONG)size);
            }
            readed += size;
            if (!done)
            {
                loop++;
                if ((loop % BLOCK_LOOP_FACTOR) == 0)
                {
                    block(file_size, readed, &stop);
                }
            }
        }
    }
    else
    {
        while (!done && !stop)
        {
            size_t size = fread(buf, 1, BUF_SIZE_NO_PROGRESS, fd);
            if (size < BUF_SIZE_NO_PROGRESS)
            {
                if (feof(fd)) done = YES;    // finish
                else { stop = YES; break; }  // error
            }
            for (int i = 0; i < hash_type_total; i++)
            {
                if (ctx[i]) ctx_update[i](ctx[i], buf, (CC_LONG)size);
            }
            readed += size;
        }
    }
    
    
    // collect result
    if (done && !stop)
    {
        hash = [TYZFileHash new];
        hash->_types = types;
        for (int i = 0; i < hash_type_total; i++)
        {
            if (ctx[i])
            {
                ctx_final[i](digest[i], ctx[i]);
                NSUInteger type = 1 << i;
                NSData *data = [NSData dataWithBytes:digest[i] length:digist_length[i]];
                NSMutableString *str = [NSMutableString string];
                unsigned char *bytes = (unsigned char *)data.bytes;
                for (NSUInteger d = 0; d < data.length; d++)
                {
                    [str appendFormat:@"%02x", bytes[d]];
                }
                switch (type)
                {
                    case TYZFileHashTypeMD2:
                    {
                        hash->_md2Data = data;
                        hash->_md2String = str;
                    } break;
                    case TYZFileHashTypeMD4:
                    {
                        hash->_md4Data = data;
                        hash->_md4String = str;
                    } break;
                    case TYZFileHashTypeMD5:
                    {
                        hash->_md5Data = data;
                        hash->_md5String = str;
                    } break;
                    case TYZFileHashTypeSHA1:
                    {
                        hash->_sha1Data = data;
                        hash->_sha1String = str;
                    } break;
                    case TYZFileHashTypeSHA224:
                    {
                        hash->_sha224Data = data;
                        hash->_sha224String = str;
                    } break;
                    case TYZFileHashTypeSHA256:
                    {
                        hash->_sha256Data = data;
                        hash->_sha256String = str;
                    } break;
                    case TYZFileHashTypeSHA384:
                    {
                        hash->_sha384Data = data;
                        hash->_sha384String = str;
                    } break;
                    case TYZFileHashTypeSHA512:
                    {
                        hash->_sha512Data = data;
                        hash->_sha512String = str;
                    } break;
                    case TYZFileHashTypeCRC32:
                    {
                        uint32_t hash32 = *((uint32_t *)bytes);
                        hash->_crc32 = hash32;
                        hash->_crc32String = [NSString stringWithFormat:@"%08x", hash32];
                    } break;
                    case TYZFileHashTypeAdler32:
                    {
                        uint32_t hash32 = *((uint32_t *)bytes);
                        hash->_adler32 = hash32;
                        hash->_adler32String = [NSString stringWithFormat:@"%08x", hash32];
                    } break;
                    default:
                        break;
                }
            }
        }
    }
    
cleanup: // do cleanup when canceled of finished
    if (buf) free(buf);
    if (fd) fclose(fd);
    for (int i = 0; i < hash_type_total; i++)
    {
        if (ctx[i]) free(ctx[i]);
        if (digest[i]) free(digest[i]);
    }
    
    return hash;
}

#pragma mark - crc32 callback

static int crc32_init(uLong *c)
{
    *c = crc32(0L, Z_NULL, 0);
    return 0;
}

static int crc32_update(uLong *c, const void *data, CC_LONG len)
{
    *c = crc32(*c, data, len);
    return 0;
}

static int crc32_final(unsigned char *buf, uLong *c)
{
    *((uint32_t *)buf) = (uint32_t)*c;
    return 0;
}

#pragma mark - adler32 callback

static int adler32_init(uLong *c)
{
    *c = adler32(0L, Z_NULL, 0);
    return 0;
}

static int adler32_update(uLong *c, const void *data, CC_LONG len)
{
    *c = adler32(*c, data, len);
    return 0;
}

static int adler32_final(unsigned char *buf, uLong *c)
{
    *((uint32_t *)buf) = (uint32_t)*c;
    return 0;
}


@end































