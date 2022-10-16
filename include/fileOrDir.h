/**
 * @file fileOrDir.h
 * @author QUCHENG JIANG (jiang.qu@northeastern.edu)
 * @brief 
 * Qucheng Jiang's personal lib and include.
 * NUID - 001569593
 * @version 0.1
 * @date 2022-09-21
 * @copyright Copyright (c) 2022
 * @details 
 * Test if a position is refering a dirctory or a file.
 */

#pragma once

#include <sys/stat.h>
#include <string>

/**
 * 判断是否是一个文件
 */
static bool is_file(std::string filename) {
    struct stat   buffer;
    return (stat (filename.c_str(), &buffer) == 0 && S_ISREG(buffer.st_mode));
}

/**
 * 判断是否是一个文件夹,
 * */
static bool is_dir(std::string filefodler) {
    struct stat   buffer;
    return (stat (filefodler.c_str(), &buffer) == 0 && S_ISDIR(buffer.st_mode));
}
