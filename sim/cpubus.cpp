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

// This implementation currently assumes SX bus (16b DATA)
// Would need some rework if going to use DX bus in the future

uint16_t CPUBUS::bus_transaction(uint32_t addr, uint16_t data, bool bhe, 
        bool ble, bool wr, bool mio) {
    std::unique_lock<std::mutex> lock(m_mutex);
    m_bus_request = true;
    m_bus_completed = false;
    m_bus_req_addr = addr;
    m_bus_req_data = data;
    m_bus_req_bhe = bhe;
    m_bus_req_ble = ble;
    m_bus_req_wr = wr;
    m_bus_req_mio = mio;
    m_cond.wait(lock, [this]{return m_bus_completed;});
    return m_bus_req_data;
}

uint8_t CPUBUS::read_uint8(uint32_t addr){
    uint32_t addr_aligned = addr & ~(0x01); // lower bit cleared
    uint16_t data = bus_transaction(addr_aligned, 0, true, false, 
            REQ_RD, REQ_MEM);
    printf("Access %08x, got %02x\n", addr, data);
    if (addr & 0x01)
        return (uint8_t)(data >> 8);
    else
        return (uint8_t)(data & 0xFF);
}

int8_t CPUBUS::read_int8(uint32_t addr){
    return (int8_t)read_uint8(addr);
}

uint32_t CPUBUS::read_uint32(uint32_t addr){
    uint32_t data;
    // need to check if RW is aligned
    //if (addr & 0x3) {
        // Unaligned access
        // So far because there is no pre-fetch queue, the performance is really
        // messed up
        // LE read
        /*data = read_uint8(addr);
        data |= read_uint8(addr + 1) << 8;
        data |= read_uint8(addr + 2) << 16;
        data |= read_uint8(addr + 3) << 24;*/
        // BE read
        data = read_uint8(addr + 3);
        data |= read_uint8(addr + 2) << 8;
        data |= read_uint8(addr + 1) << 16;
        data |= read_uint8(addr) << 24;
    /*}
    else {
        uint32_t addr_aligned = addr & ~(0x03); // lower 2 bits cleared
        uint16_t data_low = bus_transaction(addr_aligned, 0, true, true,
                REQ_RD, REQ_MEM);
        uint16_t data_high = bus_transaction(addr_aligned | 0x02, 0, true, true,
                REQ_RD, REQ_MEM);
        data = ((uint32_t)data_high << 16) | ((uint32_t)data_low);
    }*/
    
    return data;
}

int32_t CPUBUS::read_int32(uint32_t addr){
    return (int32_t)read_uint32(addr);
}

void CPUBUS::write_uint8(uint32_t addr, uint8_t data){
    uint32_t addr_aligned = addr & ~(0x01); // lower bit cleared
    bool bhe, ble;
    if (addr & 0x01) {
        data = ((uint16_t)data << 8);
        bhe = true;
        ble = false;
    }
    else {
        data = (uint16_t)data;
        bhe = false;
        ble = true;
    }
    bus_transaction(addr_aligned, data, bhe, ble, REQ_WR, REQ_MEM);
}

void CPUBUS::write_uint32(uint32_t addr, uint32_t data){
    uint32_t addr_aligned = addr & ~(0x03); // lower 2 bits cleared
    uint16_t data_low = (uint16_t)(data & 0xFFFF);
    uint16_t data_high = (uint16_t)(data >> 16);
    bus_transaction(addr_aligned, data_low, true, true, REQ_WR, REQ_MEM);
    bus_transaction(addr_aligned | 0x02, data_high, true, true, REQ_WR, 
            REQ_MEM);
}

