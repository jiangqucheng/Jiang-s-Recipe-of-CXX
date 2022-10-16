/**
 * @file MutexLock.h
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
#include <pthread.h>

/**
 * @brief you should first introduce a mutex, and then use this class to lock,
 *  e.g. pthread_mutex_t m_mutex; MutexLock(m_mutex);
 * unlock should be done automatically at the end of a section.
 * 
 */
class MutexLock
{
public:
    MutexLock(pthread_mutex_t *pMutex):m_pMutex(pMutex) { pthread_mutex_lock(m_pMutex); }
    ~MutexLock() { pthread_mutex_unlock(m_pMutex); }
private:
    pthread_mutex_t *m_pMutex;
};

