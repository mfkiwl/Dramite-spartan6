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

    Description: 32-bit X86 CPU core

    Copyright (C) 2018 Wenting Zhang
    Copyright (C) 2018 Kanta Mori

*******************************************************************************/
#include "cpucore.h"

void CPUCORE::init(uint32_t eip, uint32_t esp) {
  // initialize general purpose registers
  memset(this->registers, 0, sizeof(this->registers));
  this->registers[4] = esp;

  // initialize eflags register
  this->eflags = 0;

  // initialize instruction pointer
  this->eip = eip;

  this->init_instructions();
  this->init_modrm();
}

void CPUCORE::init_instructions(){
  memset(this->instructions, 0, sizeof(this->instructions));

  this->instructions[0x01] = &CPUCORE::add_rm32_r32;
  this->instructions[0x03] = &CPUCORE::add_r32_rm32;
  this->instructions[0x05] = &CPUCORE::add_eax_imm32;
  this->instructions[0x09] = &CPUCORE::or_rm32_r32;
  this->instructions[0x0b] = &CPUCORE::or_r32_rm32;
  this->instructions[0x0d] = &CPUCORE::or_eax_imm32;
  this->instructions[0x11] = &CPUCORE::adc_rm32_r32;
  this->instructions[0x13] = &CPUCORE::adc_r32_rm32;
  this->instructions[0x15] = &CPUCORE::adc_eax_imm32;
  this->instructions[0x19] = &CPUCORE::sbb_rm32_r32;
  this->instructions[0x1b] = &CPUCORE::sbb_r32_rm32;
  this->instructions[0x1d] = &CPUCORE::sbb_eax_imm32;
  this->instructions[0x21] = &CPUCORE::and_rm32_r32;
  this->instructions[0x23] = &CPUCORE::and_r32_rm32;
  this->instructions[0x25] = &CPUCORE::and_eax_imm32;
  this->instructions[0x29] = &CPUCORE::sub_rm32_r32;
  this->instructions[0x2b] = &CPUCORE::sub_r32_rm32;
  this->instructions[0x2d] = &CPUCORE::sub_eax_imm32;
  this->instructions[0x31] = &CPUCORE::xor_rm32_r32;
  this->instructions[0x33] = &CPUCORE::xor_r32_rm32;
  this->instructions[0x35] = &CPUCORE::xor_eax_imm32;
  this->instructions[0x39] = &CPUCORE::cmp_rm32_r32;
  this->instructions[0x3b] = &CPUCORE::cmp_rm32_r32;
  this->instructions[0x3d] = &CPUCORE::cmp_eax_imm32;
  this->instructions[0x40] = &CPUCORE::inc_eax;
  this->instructions[0x41] = &CPUCORE::inc_ecx;
  this->instructions[0x42] = &CPUCORE::inc_edx;
  this->instructions[0x43] = &CPUCORE::inc_ebx;
  this->instructions[0x44] = &CPUCORE::inc_esp;
  this->instructions[0x45] = &CPUCORE::inc_ebp;
  this->instructions[0x46] = &CPUCORE::inc_esi;
  this->instructions[0x47] = &CPUCORE::inc_edi;
  this->instructions[0x48] = &CPUCORE::dec_eax;
  this->instructions[0x49] = &CPUCORE::dec_ecx;
  this->instructions[0x4a] = &CPUCORE::dec_edx;
  this->instructions[0x4b] = &CPUCORE::dec_ebx;
  this->instructions[0x4c] = &CPUCORE::dec_esp;
  this->instructions[0x4d] = &CPUCORE::dec_ebp;
  this->instructions[0x4e] = &CPUCORE::dec_esi;
  this->instructions[0x4f] = &CPUCORE::dec_edi;
  this->instructions[0x50] = &CPUCORE::push_eax;
  this->instructions[0x51] = &CPUCORE::push_ecx;
  this->instructions[0x52] = &CPUCORE::push_edx;
  this->instructions[0x53] = &CPUCORE::push_ebx;
  this->instructions[0x54] = &CPUCORE::push_esp;
  this->instructions[0x55] = &CPUCORE::push_ebp;
  this->instructions[0x56] = &CPUCORE::push_esi;
  this->instructions[0x57] = &CPUCORE::push_edi;
  this->instructions[0x58] = &CPUCORE::pop_eax;
  this->instructions[0x59] = &CPUCORE::pop_ecx;
  this->instructions[0x5a] = &CPUCORE::pop_edx;
  this->instructions[0x5b] = &CPUCORE::pop_ebx;
  this->instructions[0x5c] = &CPUCORE::pop_esp;
  this->instructions[0x5d] = &CPUCORE::pop_ebp;
  this->instructions[0x5e] = &CPUCORE::pop_esi;
  this->instructions[0x5f] = &CPUCORE::pop_edi;
  this->instructions[0x68] = &CPUCORE::push_imm32;
  this->instructions[0x6a] = &CPUCORE::push_imm8;
  this->instructions[0x74] = &CPUCORE::je_imm8;
  this->instructions[0x75] = &CPUCORE::jne_imm8;
  this->instructions[0x81] = &CPUCORE::opcode_81;
  this->instructions[0x83] = &CPUCORE::opcode_83;
  this->instructions[0x89] = &CPUCORE::mov_rm32_r32;
  this->instructions[0x8b] = &CPUCORE::mov_r32_rm32;
  this->instructions[0x90] = &CPUCORE::nop;
  for(int i=0;i<7;i++){
    this->instructions[0x91+i] = &CPUCORE::xchg_eax_r32;
  }
  this->instructions[0xb8] = &CPUCORE::mov_eax_imm32;
  this->instructions[0xb9] = &CPUCORE::mov_ecx_imm32;
  this->instructions[0xba] = &CPUCORE::mov_edx_imm32;
  this->instructions[0xbb] = &CPUCORE::mov_ebx_imm32;
  this->instructions[0xbc] = &CPUCORE::mov_esp_imm32;
  this->instructions[0xbd] = &CPUCORE::mov_ebp_imm32;
  this->instructions[0xbe] = &CPUCORE::mov_esi_imm32;
  this->instructions[0xbf] = &CPUCORE::mov_edi_imm32;
  this->instructions[0xc3] = &CPUCORE::ret;
  this->instructions[0xc9] = &CPUCORE::leave;
  this->instructions[0xe8] = &CPUCORE::call_imm32;
  this->instructions[0xe9] = &CPUCORE::jmp_imm32;
  this->instructions[0xeb] = &CPUCORE::jmp_imm8;
  this->instructions[0xf4] = &CPUCORE::hlt;
  this->instructions[0xff] = &CPUCORE::opcode_ff;

  this->instructions[0x66] = &CPUCORE::nop;
  this->instructions[0x67] = &CPUCORE::nop;
}

void CPUCORE::init_modrm(){
  this->modrm = 0;
  this->mod   = 0;
  this->R     = 0;
  this->M     = 0;
}

void CPUCORE::calc_modrm(){
  this->mod = (this->modrm & 0xc0) >> 6;
  this->R   = (this->modrm & 0x38) >> 3;
  this->M   =  this->modrm & 0x07;
}

void CPUCORE::dump_registers(){
  printf("eax = 0x%08x (%d)\n", registers[0], registers[0]);
  printf("ecx = 0x%08x (%d)\n", registers[1], registers[1]);
  printf("edx = 0x%08x (%d)\n", registers[2], registers[2]);
  printf("ebx = 0x%08x (%d)\n", registers[3], registers[3]);
  printf("esp = 0x%08x (%d)\n", registers[4], registers[4]);
  printf("ebp = 0x%08x (%d)\n", registers[5], registers[5]);
  printf("esi = 0x%08x (%d)\n", registers[6], registers[6]);
  printf("edi = 0x%08x (%d)\n", registers[7], registers[7]);
  printf("eip = 0x%08x (%d)\n", eip,          eip);
}

void CPUCORE::run(){
  printf("CPU thread start running. EIP = %08x\n", this->eip);
  while(this->eip != 0x00) {
    uint8_t opcode = cpubus->read_uint8(eip++);
    if (opcode == 0x00) {
      printf("Invalid opcode!\n");
      break;
    }
    printf("Opcode %02x\n", opcode);
    execute_opcode(opcode);
    dump_registers();
  }
  //dump_registers();
}

void CPUCORE::execute_opcode(uint8_t opcode){
  (this->*instructions[opcode])();
}

void CPUCORE::template_rm32_r32(int calc_type){
  //printf("template_rm32_r32 called.\n");
  uint32_t addr, dst, imm32;
  uint8_t imm8;

  this->modrm = cpubus->read_uint8(this->eip);
  this->calc_modrm();

  switch (this->mod) {
    case 0:
      // operation [M], R
      // addr : M
      this->eip++;
      addr = this->registers[this->M];
      // dst : data of [M]
      dst = cpubus->read_uint32(addr);
      calc_rm32_r32_case0to2(addr, dst, calc_type);
      break;
    case 1:
      // operation [M+imm8], R
      this->eip++;
      imm8 = cpubus->read_uint8(this->eip);
      // addr : M
      addr = this->registers[this->M];
      // dst : data of [M+imm8]
      dst = cpubus->read_uint32(addr + imm8);
      calc_rm32_r32_case0to2(addr + imm8, dst, calc_type);
      this->eip++;
      break;
    case 2:
      // operation [M+imm32], R
      this->eip++;
      imm32 = cpubus->read_uint32(this->eip);
      imm32 = swap_endian32(imm32);
      // addr : M
      addr = this->registers[this->M];
      // dst : data of [M+imm32]
      dst = cpubus->read_uint32(addr + imm32);
      calc_rm32_r32_case0to2(addr + imm32, dst, calc_type);
      this->eip += 4;
      break;
    default:
      // case mod == 3
      // operation M, R
      this->eip++;
      calc_r32_rm32(&this->registers[this->M], &this->registers[this->R], calc_type);
      break;
  }
}

void CPUCORE::calc_rm32_r32_case0to2(uint32_t addr, uint32_t dst, int calc_type){
  switch (calc_type) {
    case ADD: cpubus->write_uint32(addr, dst + this->registers[this->R]); break;
    case OR:  cpubus->write_uint32(addr, dst | this->registers[this->R]); break;
    case ADC: cpubus->write_uint32(addr, dst + this->registers[this->R] + get_flag(CF)); break;
    case SBB: cpubus->write_uint32(addr, dst - (this->registers[this->R] + get_flag(CF))); break;
    case AND: cpubus->write_uint32(addr, dst & this->registers[this->R]); break;
    case SUB: cpubus->write_uint32(addr, dst - this->registers[this->R]); break;
    case XOR: cpubus->write_uint32(addr, dst ^ this->registers[this->R]); break;
    case CMP: set_flag(!(dst - this->registers[this->R]), ZF); break;
    default: break;
  }
}

void CPUCORE::template_r32_rm32(int calc_type){
  uint32_t addr, src, imm32;
  uint8_t imm8;

  this->modrm = cpubus->read_uint8(this->eip);
  this->calc_modrm();

  switch (this->mod) {
    case 0:
      // operation R, [M]
      // addr : M
      this->eip++;
      addr = this->registers[this->M];
      // src : data of [M]
      src = cpubus->read_uint32(addr);
      calc_r32_rm32(&this->registers[this->R], &src, calc_type);
      break;
    case 1:
      // operation R, [M+imm8]
      this->eip++;
      imm8 = cpubus->read_uint8(this->eip);
      // addr : M
      addr = this->registers[this->M];
      // src : data of [M+imm8]
      src = cpubus->read_uint32(addr + imm8);
      calc_r32_rm32(&this->registers[this->R], &src, calc_type);
      this->eip++;
      break;
    case 2:
      // operation R, [M+imm32]
      this->eip++;
      imm32 = cpubus->read_uint32(this->eip);
      imm32 = swap_endian32(imm32);
      // addr : M
      addr = this->registers[this->M];
      // src : data of [M+imm32]
      src = cpubus->read_uint32(addr + imm32);
      calc_r32_rm32(&this->registers[this->R], &src, calc_type);
      this->eip += 4;
      break;
    default:
      // case mod == 3
      // operation R, M
      this->eip++;
      calc_r32_rm32(&this->registers[this->R], &this->registers[this->M], calc_type);
      break;
  }
}

void CPUCORE::calc_r32_rm32(uint32_t *dst, uint32_t *src, int calc_type){
  switch (calc_type) {
    case ADD: *dst += *src; break;
    case OR:  *dst |= *src; break;
    case ADC: *dst += *src + get_flag(CF); break;
    case SBB: *dst -= *src + get_flag(CF); break;
    case AND: *dst &= *src; break;
    case SUB: *dst -= *src; break;
    case XOR: *dst ^= *src; break;
    case CMP: set_flag(!(dst - this->registers[this->R]), ZF); break;
    default: break;
  }
}

void CPUCORE::template_eax_imm32(int calc_type){
  this->eip++;
  uint32_t imm32 = cpubus->read_uint32(this->eip);
  imm32 = swap_endian32(imm32);

  switch (calc_type) {
    case ADD: this->registers[0] += imm32; break;
    case OR:  this->registers[0] |= imm32; break;
    case ADC: this->registers[0] += imm32 + get_flag(CF); break;
    case SBB: this->registers[0] -= imm32 + get_flag(CF); break;
    case AND: this->registers[0] &= imm32; break;
    case SUB: this->registers[0] -= imm32; break;
    case XOR: this->registers[0] ^= imm32; break;
    case CMP: set_flag(!(this->registers[0] - imm32), ZF); break;
    default: break;
  }
}

void CPUCORE::add_rm32_r32() { this->template_rm32_r32(ADD);  }
void CPUCORE::add_r32_rm32() { this->template_r32_rm32(ADD);  }
void CPUCORE::add_eax_imm32(){ this->template_eax_imm32(ADD); }

void CPUCORE::or_rm32_r32()  { this->template_rm32_r32(OR);   }
void CPUCORE::or_r32_rm32()  { this->template_r32_rm32(OR);   }
void CPUCORE::or_eax_imm32() { this->template_eax_imm32(OR);  }

void CPUCORE::adc_rm32_r32() { this->template_rm32_r32(ADC);  }
void CPUCORE::adc_r32_rm32() { this->template_r32_rm32(ADC);  }
void CPUCORE::adc_eax_imm32(){ this->template_eax_imm32(ADC); }

void CPUCORE::sbb_rm32_r32() { this->template_rm32_r32(SBB);  }
void CPUCORE::sbb_r32_rm32() { this->template_r32_rm32(SBB);  }
void CPUCORE::sbb_eax_imm32(){ this->template_eax_imm32(SBB); }

void CPUCORE::and_rm32_r32() { this->template_rm32_r32(AND);  }
void CPUCORE::and_r32_rm32() { this->template_r32_rm32(AND);  }
void CPUCORE::and_eax_imm32(){ this->template_eax_imm32(AND); }

void CPUCORE::sub_rm32_r32() { this->template_rm32_r32(SUB);  }
void CPUCORE::sub_r32_rm32() { this->template_r32_rm32(SUB);  }
void CPUCORE::sub_eax_imm32(){ this->template_eax_imm32(SUB); }

void CPUCORE::xor_rm32_r32() { this->template_rm32_r32(XOR);  }
void CPUCORE::xor_r32_rm32() { this->template_r32_rm32(XOR);  }
void CPUCORE::xor_eax_imm32(){ this->template_eax_imm32(XOR); }

void CPUCORE::cmp_rm32_r32() { this->template_rm32_r32(CMP);  }
void CPUCORE::cmp_eax_imm32(){ this->template_eax_imm32(CMP); }

void CPUCORE::inc_eax(){ this->registers[0]++; }
void CPUCORE::inc_ecx(){ this->registers[1]++; }
void CPUCORE::inc_edx(){ this->registers[2]++; }
void CPUCORE::inc_ebx(){ this->registers[3]++; }
void CPUCORE::inc_esp(){ this->registers[4]++; }
void CPUCORE::inc_ebp(){ this->registers[5]++; }
void CPUCORE::inc_esi(){ this->registers[6]++; }
void CPUCORE::inc_edi(){ this->registers[7]++; }

void CPUCORE::dec_eax(){ this->registers[0]--; }
void CPUCORE::dec_ecx(){ this->registers[1]--; }
void CPUCORE::dec_edx(){ this->registers[2]--; }
void CPUCORE::dec_ebx(){ this->registers[3]--; }
void CPUCORE::dec_esp(){ this->registers[4]--; }
void CPUCORE::dec_ebp(){ this->registers[5]--; }
void CPUCORE::dec_esi(){ this->registers[6]--; }
void CPUCORE::dec_edi(){ this->registers[7]--; }

void CPUCORE::push_eax(){
  //printf("push_eax called.\n");
  this->registers[4] -= 4;
  cpubus->write_uint32(this->registers[4], this->registers[0]);
}

void CPUCORE::push_ecx(){
  //printf("push_ecx called.\n");
  this->registers[4] -= 4;
  cpubus->write_uint32(this->registers[4], this->registers[1]);
}

void CPUCORE::push_edx(){
  //printf("push_edx called.\n");
  this->registers[4] -= 4;
  cpubus->write_uint32(this->registers[4], this->registers[2]);
}

void CPUCORE::push_ebx(){
  //printf("push_ebx called.\n");
  this->registers[4] -= 4;
  cpubus->write_uint32(this->registers[4], this->registers[3]);
}

void CPUCORE::push_esp(){
  //printf("push_esp called.\n");
  this->registers[4] -= 4;
  cpubus->write_uint32(this->registers[4], this->registers[4]);
}

void CPUCORE::push_ebp(){
  //printf("push_ebp called.\n");
  this->registers[4] -= 4;
  cpubus->write_uint32(this->registers[4], this->registers[5]);
}

void CPUCORE::push_esi(){
  //printf("push_esi called.\n");
  this->registers[4] -= 4;
  cpubus->write_uint32(this->registers[4], this->registers[6]);
}

void CPUCORE::push_edi(){
  //printf("push_edi called.\n");
  this->registers[4] -= 4;
  cpubus->write_uint32(this->registers[4], this->registers[7]);
}

void CPUCORE::pop_eax(){
  //printf("pop_eax called.\n");
  this->registers[0] = cpubus->read_uint32(this->registers[4]);
  this->registers[0] = swap_endian32(this->registers[0]);
  this->registers[4] += 4;
}

void CPUCORE::pop_ecx(){
  //printf("pop_ecx called.\n");
  this->registers[1] = cpubus->read_uint32(this->registers[4]);
  this->registers[1] = swap_endian32(this->registers[1]);
  this->registers[4] += 4;
}

void CPUCORE::pop_edx(){
  //printf("pop_edx called.\n");
  this->registers[2] = cpubus->read_uint32(this->registers[4]);
  this->registers[2] = swap_endian32(this->registers[2]);
  this->registers[4] += 4;
}

void CPUCORE::pop_ebx(){
  //printf("pop_ebx called.\n");
  this->registers[3] = cpubus->read_uint32(this->registers[4]);
  this->registers[3] = swap_endian32(this->registers[3]);
  this->registers[4] += 4;
}

void CPUCORE::pop_esp(){
  //printf("pop_esp called.\n");
  this->registers[4] = cpubus->read_uint32(this->registers[4]);
  this->registers[4] = swap_endian32(this->registers[4]);
  this->registers[4] += 4;
}

void CPUCORE::pop_ebp(){
  //printf("pop_ebp called.\n");
  this->registers[5] = cpubus->read_uint32(this->registers[4]);
  this->registers[5] = swap_endian32(this->registers[5]);
  this->registers[4] += 4;
}

void CPUCORE::pop_esi(){
  //printf("pop_esi called.\n");
  this->registers[6] = cpubus->read_uint32(this->registers[4]);
  this->registers[6] = swap_endian32(this->registers[6]);
  this->registers[4] += 4;
}

void CPUCORE::pop_edi(){
  //printf("pop_esi called.\n");
  this->registers[7] = cpubus->read_uint32(this->registers[4]);
  this->registers[7] = swap_endian32(this->registers[7]);
  this->registers[4] += 4;
}

void CPUCORE::push_imm32(){
  //printf("push_imm32 called.\n");
  uint32_t imm32 = cpubus->read_uint32(this->eip);
  imm32 = swap_endian32(imm32);
  this->registers[4] -= 4; // esp -= 4
  cpubus->write_uint32(this->registers[4], imm32);
  this->eip += 4;
}

void CPUCORE::push_imm8(){
  //printf("push_imm8 called.\n");
  uint8_t imm8 = cpubus->read_uint8(this->eip);
  this->registers[4] -= 4; // esp -= 4
  cpubus->write_uint8(this->registers[4], imm8);
  this->eip++;
}

void CPUCORE::je_imm8(){
  //printf("je_imm8 called.\n");

  int8_t imm8 = cpubus->read_int8(this->eip);

  int zero_flag = this->get_flag(ZF);
  if (zero_flag){
    this->eip += imm8;
  }
  this->eip++;
}

void CPUCORE::jne_imm8(){
  //printf("jne_imm8 called.\n");

  int8_t imm8 = cpubus->read_int8(this->eip);
  printf("imm8 = %d\n", imm8);
  int zero_flag = this->get_flag(ZF);
  printf("ZF = %d\n", zero_flag);
  if (!zero_flag){
    this->eip += imm8;
  }
  this->eip++;
}

void CPUCORE::opcode_81(){
  //printf("opcode_81 called.\n");

  this->modrm = cpubus->read_uint8(this->eip);
  this->calc_modrm();

  switch (this->R) {
    case 0: add_rm32_imm(IMM32); break;
    case 1:  or_rm32_imm(IMM32); break;
    case 2: adc_rm32_imm(IMM32); break;
    case 3: sbb_rm32_imm(IMM32); break;
    case 4: and_rm32_imm(IMM32); break;
    case 5: sub_rm32_imm(IMM32); break;
    case 6: xor_rm32_imm(IMM32); break;
    case 7: cmp_rm32_imm(IMM32); break;
    default: break;
  }
}

void CPUCORE::opcode_83(){
  //printf("opcode_83 called.\n");

  this->modrm = cpubus->read_uint8(this->eip);
  this->calc_modrm();

  switch (this->R) {
    case 0: add_rm32_imm(IMM8); break;
    case 1:  or_rm32_imm(IMM8); break;
    case 2: adc_rm32_imm(IMM8); break;
    case 3: sbb_rm32_imm(IMM8); break;
    case 4: and_rm32_imm(IMM8); break;
    case 5: sub_rm32_imm(IMM8); break;
    case 6: xor_rm32_imm(IMM8); break;
    case 7: cmp_rm32_imm(IMM8); break;
    default: break;
  }
}

void CPUCORE::mov_rm32_r32(){
  //printf("mov_rm32_r32 called.\n");
  uint32_t addr, imm32;
  uint8_t imm8;

  this->modrm = cpubus->read_uint8(this->eip);
  this->calc_modrm();

  switch (this->mod) {
    case 0:
      // mov [M], R
      // addr : M
      this->eip++;
      addr = this->registers[this->M];
      cpubus->write_uint32(addr, this->registers[this->R]);
      break;
    case 1:
      // mov [M+imm8], R
      this->eip++;
      imm8 = cpubus->read_uint8(this->eip);
      // addr : M
      addr = this->registers[this->M];
      cpubus->write_uint32(addr + imm8, this->registers[this->R]);
      this->eip++;
      break;
    case 2:
      // mov [M+imm32], R
      this->eip++;
      imm32 = cpubus->read_uint32(this->eip);
      imm32 = swap_endian32(imm32);
      // addr : M
      addr = this->registers[this->M];
      cpubus->write_uint32(addr, this->registers[this->R]);
      this->eip += 4;
      break;
    default:
      // case mod == 3
      // mov M, R
      this->eip++;
      this->registers[this->M] = this->registers[this->R];
      break;
  }
}

void CPUCORE::mov_r32_rm32(){
  //printf("mov_r32_rm32 called.\n");
  uint32_t addr, dst, imm32;
  uint8_t imm8;

  this->modrm = cpubus->read_uint8(this->eip);
  this->calc_modrm();

  switch (this->mod) {
    case 0:
      // mov R, [M]
      // addr : M
      this->eip++;
      addr = this->registers[this->M];
      // dst : data of [M]
      dst = cpubus->read_uint32(addr);
      this->registers[this->R] = dst;
      break;
    case 1:
      // mov R, [M+imm8]
      this->eip++;
      imm8 = cpubus->read_uint8(this->eip);
      // addr : M
      addr = this->registers[this->M];
      // dst : data of [M+imm8]
      dst = cpubus->read_uint32(addr + imm8);
      this->registers[this->R] = dst;
      this->eip++;
      break;
    case 2:
      // mov R, [M+imm32]
      this->eip++;
      imm32 = cpubus->read_uint32(this->eip);
      imm32 = swap_endian32(imm32);
      // addr : M
      addr = this->registers[this->M];
      // dst : data of [M+imm32]
      dst = cpubus->read_uint32(addr + imm32);
      this->registers[this->R] = dst;
      this->eip += 4;
      break;
    default:
      // case mod == 3
      // mov R, M
      this->eip++;
      this->registers[this->R] = this->registers[this->M];
      break;
  }
}

void CPUCORE::nop(){
  //printf("nop called.\n");
}

void CPUCORE::xchg_eax_r32(){
  //printf("xchg_eax_r32 called.\n");
  uint8_t opcode = cpubus->read_uint8(this->eip - 1);
  this->registers[0] ^= this->registers[opcode - 0x90];
  this->registers[opcode - 0x90] ^= this->registers[0];
  this->registers[0] ^= this->registers[opcode - 0x90];
}

void CPUCORE::mov_eax_imm32(){
  //printf("mov_eax_imm32 called.\n");

  uint32_t imm32 = cpubus->read_uint32(this->eip);
  imm32 = swap_endian32(imm32);
  this->registers[0] = imm32;
  this->eip += 4;
}

void CPUCORE::mov_ecx_imm32(){
  //printf("mov_ecx_imm32 called.\n");

  uint32_t imm32 = cpubus->read_uint32(this->eip);
  imm32 = swap_endian32(imm32);
  this->registers[1] = imm32;
  this->eip += 4;
}

void CPUCORE::mov_edx_imm32(){
  //printf("mov_edx_imm32 called.\n");

  uint32_t imm32 = cpubus->read_uint32(this->eip);
  imm32 = swap_endian32(imm32);
  this->registers[2] = imm32;
  this->eip += 4;
}

void CPUCORE::mov_ebx_imm32(){
  //printf("mov_ebx_imm32 called.\n");

  uint32_t imm32 = cpubus->read_uint32(this->eip);
  imm32 = swap_endian32(imm32);
  this->registers[3] = imm32;
  this->eip += 4;
}

void CPUCORE::mov_esp_imm32(){
  //printf("mov_esp_imm32 called.\n");

  uint32_t imm32 = cpubus->read_uint32(this->eip);
  imm32 = swap_endian32(imm32);
  this->registers[4] = imm32;
  this->eip += 4;
}

void CPUCORE::mov_ebp_imm32(){
  //printf("mov_ebp_imm32 called.\n");

  uint32_t imm32 = cpubus->read_uint32(this->eip);
  imm32 = swap_endian32(imm32);
  this->registers[5] = imm32;
  this->eip += 4;
}

void CPUCORE::mov_esi_imm32(){
  //printf("mov_esi_imm32 called.\n");

  uint32_t imm32 = cpubus->read_uint32(this->eip);
  imm32 = swap_endian32(imm32);
  this->registers[6] = imm32;
  this->eip += 4;
}

void CPUCORE::mov_edi_imm32(){
  //printf("mov_edi_imm32 called.\n");

  uint32_t imm32 = cpubus->read_uint32(this->eip);
  imm32 = swap_endian32(imm32);
  this->registers[7] = imm32;
  this->eip += 4;
}

void CPUCORE::ret(){
  //printf("ret called.\n");
  this->eip = cpubus->read_uint32(this->registers[4]);
  this->eip = swap_endian32(this->eip);
}

void CPUCORE::leave(){
  //printf("leave called.\n");

  // mov esp, ebp
  this->registers[4] = this->registers[5];
  // pop ebp
  this->pop_ebp();
}

void CPUCORE::call_imm32(){
  //printf("call_imm32 called.\n");

  int32_t imm32 = cpubus->read_int32(this->eip);
  imm32 = (int32_t)swap_endian32((uint32_t)imm32);
  // push eip
  this->registers[4] -= 4; // esp -= 4
  cpubus->write_uint32(this->registers[4], this->eip);
  // jmp imm32
  this->eip += imm32;
  this->eip++;
}

void CPUCORE::jmp_imm32(){
  //printf("jmp_imm32 called.\n");

  int32_t imm32 = cpubus->read_int32(this->eip);
  imm32 = (int32_t)swap_endian32((uint32_t)imm32);
  this->eip += imm32;
  this->eip++;
}

void CPUCORE::jmp_imm8() {
  //printf("jmp_imm8 called.\n");

  int8_t imm8 = cpubus->read_int8(this->eip);
  this->eip += imm8;
  this->eip++;
}

void CPUCORE::hlt(){
  printf("hlt called.\n");
  this->eip = 0x00;
}

void CPUCORE::opcode_ff(){
  //printf("opcode_ff called.\n");

  this->modrm = cpubus->read_uint8(this->eip);
  this->calc_modrm();

  switch (this->R) {
    case 0:
      this->execute_opcode(0x40+this->M); // inc r32
      this->eip++;
      break;
    case 1:
      this->execute_opcode(0x48+this->M); // dec r32
      this->eip++;
      break;
    default:
      break;
  }
}

void CPUCORE::add_rm32_imm(int imm_flag){
  //printf("add_rm32_imm called.\n");

  this->eip++;

  if(imm_flag == IMM8){
    uint8_t imm8 = cpubus->read_uint8(this->eip);
    this->registers[this->M] += imm8;
  } else if(imm_flag == IMM32){
    uint32_t imm32 = cpubus->read_uint32(this->eip);
    imm32 = swap_endian32(imm32);
    this->registers[this->M] += imm32;
  } else {
  }

  this->eip++;
}

void CPUCORE::or_rm32_imm(int imm_flag){
  //printf("or_rm32_imm called.\n");

  this->eip++;

  if(imm_flag == IMM8){
    uint8_t imm8 = cpubus->read_uint8(this->eip);
    this->registers[this->M] |= imm8;
  } else if(imm_flag == IMM32){
    uint32_t imm32 = cpubus->read_uint32(this->eip);
    imm32 = swap_endian32(imm32);
    this->registers[this->M] |= imm32;
  } else {
  }

  this->eip++;
}

void CPUCORE::adc_rm32_imm(int imm_flag){
  //printf("adc_rm32_imm called.\n");

  this->eip++;

  if(imm_flag == IMM8){
    uint8_t imm8 = cpubus->read_uint8(this->eip);
    this->registers[this->M] += imm8 + get_flag(CF);
  } else if(imm_flag == IMM32){
    uint32_t imm32 = cpubus->read_uint32(this->eip);
    imm32 = swap_endian32(imm32);
    this->registers[this->M] += imm32 + get_flag(CF);
  } else {
  }

  this->eip++;
}

void CPUCORE::sbb_rm32_imm(int imm_flag){
  //printf("sbb_rm32_imm called.\n");

  this->eip++;

  if(imm_flag == IMM8){
    uint8_t imm8 = cpubus->read_uint8(this->eip);
    this->registers[this->M] -= imm8 + get_flag(CF);
  } else if(imm_flag == IMM32){
    uint32_t imm32 = cpubus->read_uint32(this->eip);
    imm32 = swap_endian32(imm32);
    this->registers[this->M] -= imm32 + get_flag(CF);
  } else {
  }

  this->eip++;
}

void CPUCORE::and_rm32_imm(int imm_flag){
  //printf("and_rm32_imm called.\n");

  this->eip++;

  if(imm_flag == IMM8){
    uint8_t imm8 = cpubus->read_uint8(this->eip);
    this->registers[this->M] &= imm8;
  } else if(imm_flag == IMM32){
    uint32_t imm32 = cpubus->read_uint32(this->eip);
    imm32 = swap_endian32(imm32);
    this->registers[this->M] &= imm32;
  } else {
  }

  this->eip++;
}

void CPUCORE::sub_rm32_imm(int imm_flag){
  //printf("sub_rm32_imm called.\n");

  this->eip++;

  if(imm_flag == IMM8){
    uint8_t imm8 = cpubus->read_uint8(this->eip);
    this->registers[this->M] -= imm8;
  } else if(imm_flag == IMM32){
    uint32_t imm32 = cpubus->read_uint32(this->eip);
    imm32 = swap_endian32(imm32);
    this->registers[this->M] -= imm32;
  } else {
  }

  this->eip++;
}

void CPUCORE::xor_rm32_imm(int imm_flag){
  //printf("xor_rm32_imm called.\n");

  this->eip++;

  if(imm_flag == IMM8){
    uint8_t imm8 = cpubus->read_uint8(this->eip);
    this->registers[this->M] ^= imm8;
  } else if(imm_flag == IMM32){
    uint32_t imm32 = cpubus->read_uint32(this->eip);
    imm32 = swap_endian32(imm32);
    this->registers[this->M] ^= imm32;
  } else {
  }

  this->eip++;
}

void CPUCORE::cmp_rm32_imm(int imm_flag){
  //printf("cmp_rm32_imm called.\n");

  this->eip++;

  if(imm_flag == IMM8){
    uint8_t imm8 = cpubus->read_uint8(this->eip);
    set_flag(!(this->registers[this->M] - imm8), ZF);
  } else if(imm_flag == IMM32){
    uint32_t imm32 = cpubus->read_uint32(this->eip);
    imm32 = swap_endian32(imm32);
    set_flag(!(this->registers[this->M] - imm32), ZF);
  } else {
  }

  this->eip++;
}

void CPUCORE::set_flag(int flag, uint32_t flag_type){
  if (flag) {
    this->eflags |= flag_type;
  } else {
    this->eflags &= ~flag_type;
  }
}

int CPUCORE::get_flag(uint32_t flag_type){
  int flag_status = 0;

  if ((this->eflags & flag_type) == 0) {
    flag_status = 0;
  } else {
    flag_status = 1;
  }

  return flag_status;
}

uint32_t CPUCORE::swap_endian32(uint32_t data) {
  uint32_t swapped = 0x00;

  swapped += (data & 0xff000000) >> 24;
  swapped += (data & 0x00ff0000) >>  8;
  swapped += (data & 0x0000ff00) <<  8;
  swapped += (data & 0x000000ff) << 24;

  return swapped;
}
