module mem_x1 (
    clk,
    mem_ena,
    wr_rd,
    addr,
    data_in,
    data_out
);

  input clk;
  input mem_ena;
  input wr_rd;
  input [9:0] addr;
  input [15:0] data_in;
  output reg [15:0] data_out;

  reg [15:0] mem[1023:0];

  integer file, j, flag;
  real f;
  initial begin
    file = $fopen("x1.txt", "r");
    flag = $fscanf(file, "%f", f);
    j = 0;
    while (j <= 1023 && flag != 0) begin
      mem[j] = f * 512;
      flag   = $fscanf(file, "%f", f);
      $display("input:%d,j=%d,flag=%d", mem[j], j, flag);
      j = j + 1;
    end
    $fclose(file);
  end

  always @(posedge clk)

    if (mem_ena)
      if (wr_rd) begin
        mem[addr] <= data_in;
      end else begin
        data_out <= mem[addr];
      end
endmodule
