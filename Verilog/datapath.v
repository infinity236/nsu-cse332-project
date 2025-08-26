// file: Datapath.v


`include "adder.v"
`include "alu32.v"
`include "flopr_param.v"
`include "mux2.v"
`include "mux4.v"
`include "regfile32.v"
`include "signext.v"
`include "sl2.v"

`timescale 1ns / 1ns

module Datapath (
    input clk,
    input reset,
    input RegDst,
    input RegWrite,
    input ALUSrc,
    input Jump,
    input JAL,
    input JR,
    input MemtoReg,
    input PCSrc,
    input [3:0] ALUControl,
    input [31:0] ReadData,
    input [31:0] Instr,
    output [31:0] PC,
    output ZeroFlag,
    output [31:0] datatwo,
    output [31:0] ALUResult
);


  wire [31:0] PCNext, PCplus4, PCbeforeBranch, PCBranch, resultjumpmux; //Added: New wire for mux output
  wire [31:0] extendedimm, extendedimmafter, MUXresult, dataone, aluop2, writedata; //Added: New wire RF write data
  wire [4:0] writereg;

  // PC
  flopr_param #(32) PCregister (
      .clk(clk),
      .rst(reset),
      .q  (PC),
      .d  (PCNext)
  );
  adder #(32) pcadd4 (
      .a(PC),
      .b(32'd4),
      .y(PCplus4)
  );
  slt2 shifteradd2 (
      .a(extendedimm),
      .y(extendedimmafter)
  );
  adder #(32) pcaddsigned (
      .a(extendedimmafter),
      .b(PCplus4),
      .y(PCbeforeBranch)
  );
  mux2 #(32) branchmux (
      .d0(PCplus4),
      .d1(PCbeforeBranch),
      .s (PCSrc),
      .y (PCBranch)
  );

  //Added: Redirect Mux input
  mux2 #(32) jumpmux (
      .d0(PCBranch),
      .d1({PCplus4[31:28], Instr[25:0], 2'b00}),
      .s (Jump | JAL),
      .y (resultjumpmux)
  );


  // Added: Mux
  mux2 #(32) pcmux (
      .d0(resultjumpmux),
      .d1(dataone),
      .s (JR),
      .y (PCNext)
  );



  // Register File 
  registerfile32 RF (
      .clk(clk),
      .we(RegWrite),
      .reset(reset),
      .ra1(Instr[25:21]),
      .ra2(Instr[20:16]),
      .wa(writereg),
      .wd(writedata),
      .rd1(dataone),
      .rd2(datatwo)
  );


  wire [4:0] rd_rs;
  mux2 #(5) writeopmux (
      .d0(Instr[20:16]),
      .d1(Instr[15:11]),
      .s (RegDst),
      .y (rd_rs)
  );

  mux2 #(5) writeback31 (
      .d0(rd_rs),
      .d1(5'd31),
      .s (JAL),
      .y (writereg)
  );
  mux2 #(32) resultmux (
      .d0(ALUResult),
      .d1(ReadData),
      .s (MemtoReg),
      .y (MUXresult)
  );

  // Added: MUX; write-back data to register file
  mux2 #(32) writedatamux (
      .d0(MUXresult),
      .d1(PCplus4),
      .s (JAL),
      .y (writedata)
  );


  // ALU
  alu32 alucomp (
      .a(dataone),
      .b(aluop2),
      .f(ALUControl),
      .shamt(Instr[10:6]),
      .y(ALUResult),
      .zero(ZeroFlag)
  );
  signext immextention (
      .a(Instr[15:0]),
      .y(extendedimm)
  );
  mux2 #(32) aluop2sel (
      .d0(datatwo),
      .d1(extendedimm),
      .s (ALUSrc),
      .y (aluop2)
  );


endmodule
