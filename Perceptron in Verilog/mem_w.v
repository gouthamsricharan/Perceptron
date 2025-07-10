module mem_w (
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
    input [15:0] data_in;
    output reg [15:0] data_out;
    input [5:0] addr;

  reg [15:0] mem[2:0];
  integer file, flag, j;
  real f;

  initial begin
    file = $fopen("w.txt", "r");
    flag = $fscanf(file, "%f", f);
    j = 0;
    while (j <= 2 && flag != 0) begin
      mem[j] = f * 512;
      flag   = $fscanf(file, "%f", f);
      $display("input:%d,j=%d,flag=%d", mem[j], j, flag);
      j = j + 1;
    end
    $fclose(file);
  end

  always @(posedge clk) begin
    if (mem_ena) begin
      if (wr_rd) mem[addr] <= data_in;
      else data_out <= mem[addr];
    end
  end

endmodule

