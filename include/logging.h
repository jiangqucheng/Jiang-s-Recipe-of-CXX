/**
 * @file logging.h
 * @author QUCHENG JIANG (jiang.qu@northeastern.edu)
 * @brief 
 * Qucheng Jiang's personal lib and include.
 * NUID - 001569593
 * @version 0.1
 * @date 2022-02-15
 * @copyright Copyright (c) 2022
 * @details 
 * Define "-D USE_LIB_MULTI_THREAD" in CXX_FLAGS to activate the multi thread safe printout lines. 
 * Otherwise, every item inside MTSF_PRINT(...) will be printed as same as PRINT(...), 
 * which is not safe in multi-thread, and can be seperated and corrupted together.
 * 
 */

#pragma once

#include <iostream>
#include <sstream>
#include <stdio.h>

/**
 * @brief simple cutting function for __PERFECT_FUNCTION__ defination, in order to cut out the class and function(method) part out from the whole info.
 * 
 * @param pfStr the string from GNU standard __PRETTY_FUNCTION__ output.
 * @return std::string 
 */
static std::string __cut_parent_heses_n_tail__(std::string&& pfStr)
{
    auto pos = pfStr.find('('); if(pos!=std::string::npos) pfStr.erase(pfStr.begin()+pos, pfStr.end());
    pos = pfStr.rfind(' '); if(pos!=std::string::npos) pfStr.erase(pfStr.begin(), pfStr.begin()+pos+1);
    return std::move(pfStr);
}

/**
 * @brief __PERFECT_FUNCTION__ generate the perfect function name string, and add class name in front (if applicable).
 * 
 */
#define __PERFECT_FUNCTION__ __cut_parent_heses_n_tail__(std::string(__PRETTY_FUNCTION__))


/**
 * @brief __POSITION__ generates the logging style of each log is presented.
 * @details component are:
 *  __FILE__ : the file name where the call is made;
 *  __LINE__ : the line number in such file;
 *  __FUNCTION__ : the C++ standard provided defination to tell the name of where the code belong to.
 *  __PERFECT_FUNCTION__ : a comprehensive name that is the greater version that shows the function name, 
 *                         including class name if the function is a method in a class.
 */
#define __POSITION__ "["<< __FILE__ << ":" << (int)__LINE__ << " " << __PERFECT_FUNCTION__ << "]\t"


/**
 * @brief the normal print that is NO garenteened to be thread safe.
 *  e.g. PRINT( "aaa" << iterIndex ) 
 *        equals to (=)
 *       std::cout << "aaa" << iterIndex ;
 * 
 */
#define PRINT(M) {std::cout<< M ;}
#define ERR_PRINT(M) {std::cerr << M ;}


/**
 * @brief multi thread safe print. 
 *  MTSF_PRINT( <put every thing you need to output here, just as the std::cout dees.> )
 *  e.g. MTSF_PRINT( "aaa" << iterIndex ) 
 *        equals to (=)
 *       std::cout << "aaa" << iterIndex ; (in thread safe approach, if applicable)
 * 
 */
#ifdef USE_LIB_MULTI_THREAD
  #include <mutex>
  static std::mutex __mtsf_opt_lock_mutex_;
  // TODO: Just uses a print lock to protect. A better approach may be applied here, need further consideration.
  #define MTSF_PRINT(M) {std::unique_lock<std::mutex> __mtsf_opt_lock_(__mtsf_opt_lock_mutex_); PRINT(M)}
#else
  #define MTSF_PRINT(M) { std::stringstream ss; ss << M;  PRINT(ss) }
#endif


#define CTRACE(x, format) printf(#x " = %" #format " ", x)  