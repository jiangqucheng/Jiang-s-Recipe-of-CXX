/**
 * @file debug.h
 * @author QUCHENG JIANG (jiang.qu@northeastern.edu)
 * @brief 
 * Qucheng Jiang's personal lib and include.
 * NUID - 001569593
 * @version 0.1
 * @date 2022-02-15
 * @copyright Copyright (c) 2022
 * @details 
 * Define "-D DEBUG" in CXX_FLAGS to activate the debug lines. 
 * Otherwise, every instruction inside IN_DEBUG(...) will not been compiled and executed.
 * 
 */

#pragma once


/**
 * @brief defines for runtime debugging. 
 *  things only occer when debug is defined.
 * 
 */
#ifdef DEBUG 
    #define IN_DEBUG(M) M;
    #define NOTIN_DEBUG(M) ;
#else
    #define IN_DEBUG(M) ;
    #define NOTIN_DEBUG(M) M;
#endif

