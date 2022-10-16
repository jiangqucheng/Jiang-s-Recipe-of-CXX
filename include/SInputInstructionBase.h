/**
 * @file SInputInstructionBase.h
 * @author QUCHENG JIANG (jiang.qu@northeastern.edu)
 * @brief 
 * Qucheng Jiang's personal lib and include.
 * NUID - 001569593
 * @version 0.1
 * @date 2022-09-21
 * @copyright Copyright (c) 2022
 * @details 
 * The base of SInputInstruction.
 * Contains the 3 methods and no attributes, 
 * Use .load(argc, argv) to read cfg file,  .load_from_file() will sync mem with file. 
 * Rewrite update_key_value() in the subclasses.
 */

#pragma once

#include <sstream>
#include <fstream>
#include <iostream>
#include <unistd.h>
#include <string>
#include <stddef.h>

#include <strAssign.h>
#include <logging.h>
#include <fileOrDir.h>


/** 
 * CHECK_ASSIGN_STR_VAL is only for this func. 
 * do not use it outside!
 * 
 * CHECK_ASSIGN_STR_VAL(KEYSTR, VALSTR, TYP, OBJ, CHECKFUNC)
 * KEYSTR: key string that need to determine if match to OBJ name or not.  
 * VALSTR: value string that need to convert and insert if key matches.  
 * TYP: the type of object.
 * OBJ: the object that will insert value to.
 * CHECKFUNC: a lambda function that check before inserting to value. 
 *              It use x to represent the value that will be inserted. 
 *              Return true if the value is suitable, 
 *              then it will update to the OBJ, 
 *              otherwize, when return false, 
 *              the function will stop and return -1 meaning the check didn't pass.
 * 
 * Example
 * CHECK_ASSIGN_STR_VAL(key, value, uint, dataset_size, {auto cc = x+1>1; cc=!cc; return cc;})
 * **/
#define CHECK_ASSIGN_STR_VAL(KEYSTR, VALSTR, TYP, OBJ, CHECKFUNC) \
if (KEYSTR == #OBJ){ \
    TYP t_##OBJ; \
    ASSIGN_STR_VAL( t_##OBJ, VALSTR ); \
    if (!([](TYP x) -> bool { CHECKFUNC }(t_##OBJ))) \
        return -1; \
    OBJ = t_##OBJ; \
}

class SInputInstructionBase
{
    // demo
    // ushort bin_count = 0; 
    // uint omp_threads = 0; 
    // bool show_distribution = true ;  

    public:

    explicit SInputInstructionBase(){ }
    
    SInputInstructionBase(int argc, char *argv[]){
        // NO, this will not work, since constructor func in sub classes hasn't run yet, the load will not find any attributes.
        load(argc, argv);
    }

    virtual short update_key_value(std::string key, std::string value)
    {
        if (false) {}
        // demo
        // else CHECK_ASSIGN_STR_VAL(key, value, ushort, bin_count, {return x>0;})
        // else CHECK_ASSIGN_STR_VAL(key, value, bool, show_distribution, {return true;})
        // else CHECK_ASSIGN_STR_VAL(key, value, uint, omp_threads, {return x>0;})
        else {return -2;}  // this -2 means key not found.
        return 0;
    }

    virtual short load_from_file(std::string fileLocation, std::string default_filename) 
    {
        // location is a dir and it contains slash in the end --> pop it.
        if (fileLocation.back() == '/' || fileLocation.back() == '\\')
            fileLocation.pop_back(); 
        // if location is a dir, redirect fileLocation to find default filename in that dir.
        if (is_dir(fileLocation))
            fileLocation += "/" + default_filename;

        // start a input file stream to read file loc at fileLocation
        std::ifstream cfg_file_stream(fileLocation);

        // if the file didn't exist, print and return -1.
        if (cfg_file_stream.fail())
        {
            ERR_PRINT(__POSITION__ << " cannot locate config file from: \"" << fileLocation << "\". \n")
            return -1;
        }
        
        // cfg file is loaded
        PRINT(__POSITION__ << " use config file @ " << fileLocation << "\n")

        std::string line;
        while( std::getline(cfg_file_stream, line) )
        {
            // skip comment line
            if (line.front() == '#' || line.front() == ';') continue;
            std::istringstream line_stream(line);
            std::string key, value;
            if( std::getline(line_stream, key, '=') )
            {
                // delete space before and after key part
                while ( key.length()>0 && key.back() == ' ' ) key.pop_back();
                while ( key.length()>0 && key.front() == ' ' ) key=key.substr(1);
                if( std::getline(line_stream, value) ) 
                {
                    // maybe value part need the spaces in front and end if object is string. 
                    // while ( value.length()>0 && value.back() == ' ' ) value.pop_back();
                    // while ( value.length()>0 && value.front() == ' ' ) value=value.substr(1);
                }
                update_key_value(key, value);
            }
        }
        return 0;
    }

    virtual short load(int argc, char *argv[]) {
        int opt; 
        const char *optstring = "f:"; 

        std::string config_file_path("./");
        std::string default_cfg_filename(argv[0]);
        default_cfg_filename += ".conf";

        while (default_cfg_filename.find('/') != std::string::npos 
            || default_cfg_filename.find('\\') != std::string::npos 
        ) default_cfg_filename = default_cfg_filename.substr(1);  // .erase(0, 1) should also works
        
        config_file_path = config_file_path + default_cfg_filename;

        while ((opt = getopt(argc, argv, optstring)) != -1) 
        {
            switch (opt)
            {
            case 'f':
            {
                ASSIGN_STR_VAL( config_file_path, optarg );
                if (config_file_path.length()<=0)
                    return -2;
            }
                break;
            default:
                break;
            }
        }

        return load_from_file(config_file_path, default_cfg_filename);
    }
};


