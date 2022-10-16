/**
 * @file strAssign.h
 * @author QUCHENG JIANG (jiang.qu@northeastern.edu)
 * @brief 
 * Qucheng Jiang's personal lib and include.
 * NUID - 001569593
 * @version 0.1
 * @date 2022-09-21
 * @copyright Copyright (c) 2022
 * @details 
 * Used for assigning values from string, eg. command line input.
 * Usage: ASSIGN_STR_VAL(m_someNum, inputValStr)
 */

#pragma once

#include <sstream>

#define ASSIGN_STR_VAL(TO, FROM) {std::stringstream ss; ss << FROM; ss >> TO ;}
#define SS_CONVERT(TO_CONTAINER, FROM) {std::stringstream ss; ss << FROM; ss >> TO_CONTAINER ;}
