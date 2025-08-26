// file: MIPS_SCP_tb.v
// Testbench for MIPS_SCP

`timescale 1ns / 1ns

module MIPS_SCP_tb;

  //Inputs
  reg clk;
  reg reset;

  //Outputs

  //Instantiation of Unit Under Test
  MIPS_SCP uut (
      .clk  (clk),
      .reset(reset)
  );

  always #50 clk = !clk;
  initial begin
    clk   = 0;
    reset = 1;
    #100;  //cycle 1
    repeat (10) begin
      reset = 0;
      #100;
    end
    #10;
  end

  // Lightweight runtime monitor for branch debugging
  integer cycle = 0;
  always @(posedge clk) begin
    cycle = cycle + 1;
    $display(
        "[%0t] C%0d PC=%h Instr=%h Zero=%b PCSrc=%b ALUSrc=%b ALUCtrl=%b Jump=%b JR=%b RegWrite=%b MemWrite=%b",
        $time, cycle, uut.PC, uut.Instr, uut.Zero, uut.PCSrc, uut.ALUSrc, uut.ALUControl, uut.Jump,
        uut.JR, uut.RegWrite, uut.MemWrite);
    if (uut.PCSrc) begin
      // Show the computed branch target when branch is taken
      $display("          Branch to: %h (PC+4=%h, off<<2=%h)", uut.datapathcomp.PCbeforeBranch,
               uut.datapathcomp.PCplus4, uut.datapathcomp.extendedimmafter);
    end
    if ($time > 200 && (uut.PC === 32'bx || uut.PC === 32'bz || uut.Instr === 32'bx || uut.Instr === 32'bz)) begin
      $display("Simulation finished - PC or Instruction became unknown");
      $finish;
    end
  end
endmodule
