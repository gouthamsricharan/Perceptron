module core_perceptron_top();

  reg clk;
  reg rst;
  reg [3:0] control;
  wire x1_w,x2_w,label_w,w_w;
  wire x1_en,  x2_en, label_en, w_en;
  wire[15:0] x1_in, x2_in, label_in, w_in, w_out;
  reg[9:0] x1_cnt, x2_cnt, label_cnt;
  wire[5:0] w_cnt;
  reg[15:0] x1_out, x2_out, label_out;

  core_perceptron core(
    clk,
    rst,
    control,
    x1_in,
    x2_in,
    label_in,
    x1_cnt,
    x2_cnt,
    label_cnt,
    // x1_out,
    // x2_out,
    // label_out,
    x1_en,
    x2_en,
    label_en,
    x1_w,
    x2_w,
    label_w,
    w_en,
    w_w,
    w_in,
    w_out,
    w_cnt
    );

mem_label label(clk,label_en,label_w,label_cnt,label_out, label_in);

mem_x1 x1(clk,x1_en, x1_w, x1_cnt, x1_out, x1_in);

mem_x2 x2(clk,x2_en, x2_w, x2_cnt, x2_out, x2_in);

mem_w w(clk,w_en, w_w, w_cnt, w_out, w_in);


  always
    begin
      clk=1; #5; clk=0; #5;
    end

initial 
    begin
      rst            <= 0;
      control        <= 0;
      #10;
      rst            <= 1;
      x1_cnt    <= 0;
      x2_cnt    <= 0;
      label_cnt <= 0;
      #50;
      rst            <= 0;
      control        <= 4'b1111;
      #300;
      repeat(500) begin
      rst            <= 0;
      control        <= 0;
      #10;
      rst            <= 1;
      x1_cnt    <= x1_cnt+1;
      x2_cnt    <= x2_cnt+1;
      label_cnt <= label_cnt+1;
      #50;
      rst            <= 0;
      control        <= 4'b1111;
      #800;
      end
      $finish;
    end

  initial 
    begin
      $dumpfile("perceptron.vcd");
      $dumpvars(0,core_perceptron_top);
    end

endmodule