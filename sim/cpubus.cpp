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
#include <functional>
#include "cpubus.h"

uint16_t CPUBUS::start_transaction(uint32_t addr, uint16_t data, bool wr, bool mio) {
    std::unique_lock<std::mutex> lock(m_mutex);
    m_bus_request = true;
    m_bus_completed = false;
    m_bus_req_addr = addr;
    m_bus_req_data = data;
    m_bus_req_wr = wr;
    m_bus_req_mio = mio;
    m_cond.wait(lock, [this]{return m_bus_completed;});
    return m_bus_req_data;
}

uint8_t CPUBUS::read_uint8(uint32_t addr){
    uint32_t addr_aligned = addr & ~(0x01); // lower bit cleared
    uint16_t data = start_transaction(addr_aligned, 0, false, true);
    if (addr & 0x01)
        return (uint8_t)(data >> 8);
    else
        return (uint8_t)(data & 0xFF);
}

int8_t CPUBUS::read_int8(uint32_t addr){
    return (int8_t)read_uint8(addr);
}

uint32_t CPUBUS::read_uint32(uint32_t addr){
    uint32_t addr_aligned = addr & ~(0x03); // lower 2 bits cleared
    uint16_t data_low = start_transaction(addr_aligned, 0, false, true);
    uint16_t data_high = start_transaction(addr_aligned | 0x02, 0, false, true);
    uint32_t data = ((uint32_t)data_high << 16) | ((uint32_t)data_low);
    return data;
}

int32_t CPUBUS::read_int32(uint32_t addr){
    return (int32_t)read_uint32(addr);
}

// FIX ME: always clear other 8 bits
void CPUBUS::write_uint8(uint32_t addr, uint8_t data){
    uint32_t addr_aligned = addr & ~(0x01); // lower bit cleared
    if (addr & 0x01)
        data = ((uint16_t)data << 8);
    else
        data = (uint16_t)data;
    start_transaction(addr_aligned, data, true, true);
}

void CPUBUS::write_uint32(uint32_t addr, uint32_t data){
    uint32_t addr_aligned = addr & ~(0x03); // lower 2 bits cleared
    uint16_t data_low = (uint16_t)(data & 0xFFFF);
    uint16_t data_high = (uint16_t)(data >> 16);
    start_transaction(addr_aligned, data_low, true, true);
    start_transaction(addr_aligned | 0x02, data_high, true, true);
}

