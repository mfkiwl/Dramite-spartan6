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

    Description: A memory simulation model with simple delay control

    Copyright (C) 2018 Wenting Zhang
    Copyright (C) 2018 Kanta Mori

*******************************************************************************/
#include "emulator.h"

/*
#include <iostream>
#include <string>
#include "include/emulator.h"

const size_t MEMORY_SIZE = 1*KB;

int main(int argc, char *argv[]){
  FILE *bin;
  bin = fopen(argv[1], "rb");

  Emulator emulator;
  emulator.init(MEMORY_SIZE, bin);
  fclose(bin);

  while(emulator.get_eip() < MEMORY_SIZE) {
    uint8_t opcode = emulator.read_next_opcode();
    emulator.exec(opcode);

    if (emulator.get_eip() == 0x00) break;
  }

  emulator.dump_registers();

  emulator.free();

  return 0;
}
*/


void Emulator::init(size_t memorysize, FILE *bin){
  memory.init(memorysize);
  memory.load_binary(bin);
  instructions.init(0, (int)memorysize, memory);
}

void Emulator::free(){
  memory.free_memory();
}

void Emulator::exec(uint8_t opcode){
  instructions.execute_opcode(opcode);
}

void Emulator::dump_registers(){
  printf("eax = 0x%08x (%d)\n", instructions.registers[0], instructions.registers[0]);
  printf("ecx = 0x%08x (%d)\n", instructions.registers[1], instructions.registers[1]);
  printf("edx = 0x%08x (%d)\n", instructions.registers[2], instructions.registers[2]);
  printf("ebx = 0x%08x (%d)\n", instructions.registers[3], instructions.registers[3]);
  printf("esp = 0x%08x (%d)\n", instructions.registers[4], instructions.registers[4]);
  printf("ebp = 0x%08x (%d)\n", instructions.registers[5], instructions.registers[5]);
  printf("esi = 0x%08x (%d)\n", instructions.registers[6], instructions.registers[6]);
  printf("edi = 0x%08x (%d)\n", instructions.registers[7], instructions.registers[7]);
  printf("eip = 0x%08x (%d)\n", instructions.eip, instructions.eip);
}

uint8_t Emulator::read_next_opcode(){
  uint8_t opcode = memory.read_uint8(instructions.eip);
  instructions.eip++;

  return opcode;
}

uint8_t Emulator::read_uint8(uint32_t addr){
  uint8_t data = memory.read_uint8(addr);
  return data;
}

uint32_t Emulator::get_eip(){
  return instructions.eip;
}
