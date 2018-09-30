/*******************************************************************************
    This program is free software (firmware): you can redistribute it and/or
    modify it under the terms of  the GNU General Public License as published
    by the Free Software Foundation, either version 3 of the License, or (at
    your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License along
    with this program.  (It's in the $(ROOT)/doc directory.  Run make with no
    target there if the PDF file isn't present.)  If not, see
    <http://www.gnu.org/licenses/> for a copy.

    Description: CPU Bus interface

    Copyright (C) 2018 Wenting Zhang
    Copyright (C) 2018 Kanta Mori

*******************************************************************************/
#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <mutex>
#include <condition_variable>

class CPUBUS {
public:
    std::mutex& m_mutex;
    std::condition_variable& m_cond;
    bool& m_bus_request;
    bool& m_bus_completed;
    uint32_t& m_bus_req_addr;
    uint16_t& m_bus_req_data;
    bool& m_bus_req_wr;
    bool& m_bus_req_mio;
    
    CPUBUS(std::mutex& mutex, std::condition_variable& cond, bool& bus_request, bool& bus_completed, uint32_t& bus_req_addr, uint16_t& bus_req_data, bool& bus_req_wr, bool& bus_req_mio): m_mutex(mutex), m_cond(cond), m_bus_request(bus_request), m_bus_completed(bus_completed), m_bus_req_addr(bus_req_addr), m_bus_req_data(bus_req_data), m_bus_req_wr(bus_req_wr), m_bus_req_mio(bus_req_mio) {};

    uint16_t start_transaction(uint32_t addr, uint16_t data, bool wr, bool mio);
    uint8_t read_uint8(uint32_t addr);
    int8_t read_int8(uint32_t addr);
    uint32_t read_uint32(uint32_t addr);
    int32_t read_int32(uint32_t addr);
    void write_uint8(uint32_t addr, uint8_t data);
    void write_uint32(uint32_t addr, uint32_t data);
};
