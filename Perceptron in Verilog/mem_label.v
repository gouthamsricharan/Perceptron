module mem_label (
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
  integer file, flag, j;
  real f;

  initial begin
    file = $fopen("z.txt", "r");
    flag = $fscanf(file, "%f", f);
    j = 0;
    while (j <= 1023 && flag != 0) begin
      mem[j] = f*512;  
      $display("input:%d,j=%d,flag=%d", mem[j],j,flag);
      flag = $fscanf(file, "%f", f);
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
