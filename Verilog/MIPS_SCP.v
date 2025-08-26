// file: MIPS_SCP.v

`include "datapath.v"
`include "ram.v"
`include "rom.v"
`include "control.v"

`timescale 1ns / 1ns


module MIPS_SCP (
    input clk,
    input reset
);

  wire [31:0] PC, Instr, ReadData, WriteData, ALUResult;
  wire RegDst, RegWrite, ALUSrc, Jump, JAL, JR, MemtoReg, PCSrc, Zero, MemWrite;
  wire [3:0] ALUControl;

  Datapath datapathcomp (
      .clk(clk),
      .reset(reset),
      .RegDst(RegDst),
      .RegWrite(RegWrite),
      .ALUSrc(ALUSrc),
      .Jump(Jump),
      .JAL(JAL),
      .JR(JR),
      .MemtoReg(MemtoReg),
      .PCSrc(PCSrc),
      .ALUControl(ALUControl),
      .ReadData(ReadData),
      .Instr(Instr),
      .PC(PC),
      .ZeroFlag(Zero),
      .datatwo(WriteData),
      .ALUResult(ALUResult)
  );


  Controlunit controller (
      .Opcode(Instr[31:26]),
      .Func(Instr[5:0]),
      .Zero(Zero),
      .MemtoReg(MemtoReg),
      .MemWrite(MemWrite),
      .ALUSrc(ALUSrc),
      .RegDst(RegDst),
      .RegWrite(RegWrite),
      .Jump(Jump),
      .JAL(JAL),
      .JR(JR),
      .PCSrc(PCSrc),
      .ALUControl(ALUControl)
  );


  ram dmem (
      .clk (clk),
      .we  (MemWrite),
      .adr (ALUResult),
      .din (WriteData),
      .dout(ReadData)
  );

  rom imem (
      .adr (PC),
      .dout(Instr)
  );

endmodule
