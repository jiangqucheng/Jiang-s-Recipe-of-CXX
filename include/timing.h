/**
 * @file timing.h
 * @author QUCHENG JIANG (jiang.qu@northeastern.edu)
 * @brief 
 * Qucheng Jiang's personal lib and include.
 * NUID - 001569593
 * @version 0.1
 * @date 2022-02-15
 * @copyright Copyright (c) 2022
 * @details  
 * timeToStr() translate time object to a string.
 * getNowTime() get the current timestamp, in global scale.
 * 
 */

#pragma once

#include <iostream>
#include <chrono>


static std::string timeToStr(std::chrono::system_clock::time_point &t)
{
    std::time_t time = std::chrono::system_clock::to_time_t(t);
    auto tm_info = localtime(&time);
    char tt[18];
    strftime(tt, 18, "%Y%m%d_%H%M%S", tm_info);
    std::string rr(tt);
    return rr;
}

static std::chrono::system_clock::time_point getNowTime()
{
    return std::chrono::system_clock::now();
}


static std::chrono::_V2::system_clock::time_point __test_time_start;
static std::chrono::microseconds __test_time_duration;
#define TT_START {__test_time_start=getNowTime();};
#define TT_STOP {__test_time_duration=std::chrono::duration_cast<std::chrono::microseconds>(getNowTime() - __test_time_start);};
#define TT_SHOW (double(__test_time_duration.count()) * std::chrono::microseconds::period::num / std::chrono::microseconds::period::den)
