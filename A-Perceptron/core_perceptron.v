module core_perceptron (
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

  input clk;
  input rst;
  input [3:0] control;

  input [15:0] x1_in, x2_in, label_in;
  input [9:0] x1_cnt, x2_cnt, label_cnt;
  // output reg[15:0] x1_out , x2_out , label_out;
  output reg x1_en, x2_en, label_en;
  output reg x1_w, x2_w, label_w;

  input [15:0] w_in;
  output  [15:0] w_out;
  output reg [5:0] w_cnt;
  output reg w_en;
  output reg w_w;

  reg end_of_cal;
  reg end_of_up;
  reg end_of_rd;

  reg signed [15:0] my_x1, my_x2, my_label;
  reg signed [15:0] my_w1, my_w2, my_bias;
  reg [15:0] w1_out, w2_out, bias_out, w_out;
  reg signed [31:0] sum;
  reg signed [31:0] mult;
  reg signed [15:0] differ;
  reg F;

  reg [5:0] state;
  reg [5:0] read_state;
  reg [8:0] calculate_state;
  reg [6:0] update_state;

  parameter start     =5'b00001,
            read      =5'b00010,
            calculate =5'b00100,
            update    = 5'b01000,
            finish    = 5'b10000,

            read_init   = 5'b00001,
            read_p1     = 5'b00010,
            read_p2     = 5'b00100,
            read_bias   = 5'b01000,
            read_end    = 5'b10000,
         
            cal_init  = 8'b00000001,
            cal_part1 = 8'b00000010,
            cal_part2 = 8'b00000100,
            cal_sum   = 8'b00001000,
            cal_bias  = 8'b00010000,
            cal_F     = 8'b00100000,
            cal_differ= 8'b01000000,
            cal_end   = 8'b10000000,
            
            upd_init  = 6'b000001,
            upd_bias  = 6'b000010,
            upd_part2 = 6'b000100,
            upd_part1 = 6'b001000,
            upd_wr    = 6'b010000,
            upd_end   = 6'b100000;

  always @(posedge clk) begin
    if (rst) begin
      state           <= start;
      read_state     <= 6'bxxxxxx;
      calculate_state<= 9'bxxxxxxxxx;
      update_state   <= 7'bxxxxxxx;

      end_of_rd       <= 0;
      end_of_cal      <= 0;
      end_of_up       <= 0;
      w_cnt           <= 0;
      x1_en           <= 1;
      x2_en           <= 1;
      label_en        <= 1;
      w_en            <= 1;
      x1_w            <= 0;
      x2_w            <= 0;
      label_w         <= 0;
      w_w             <= 0;
      my_x1           <= x1_in;
      my_x2           <= x2_in;
      my_label        <= label_in / 512;

    end else begin
      case (state)
        start: begin
          if (control[0] == 1) begin
            state <= read;
          end else begin
            state <= start;
          end
        end

        read: begin
          if (control[1] == 1 && end_of_rd) begin
            state <= calculate;
          end else begin
            state <= read;
            read_state <= read_init;
            case (read_state)
              read_init: begin
                end_of_rd <= 0;
                read_state <= read_p1;
                w_cnt <= w_cnt + 1;
              end
              read_p1: begin
                read_state <= read_p2;
                my_w1 <= w_in;
                w_cnt <= w_cnt + 1;
              end
              read_p2: begin
                my_w2 <= w_in;
                // w_cnt <= w_cnt + 1;
                read_state <= read_bias;
              end
              read_bias: begin
                my_bias <= w_in;
                read_state <= read_end;
              end
              read_end: begin
                end_of_rd  <= 1;
                read_state <= read_init;
              end
              default: begin
                read_state <= read_init;
              end
            endcase
          end
        end

        calculate: begin
          if (control[2] == 1 && end_of_cal) begin
            state <= update;
          end else begin
            state <= calculate;
            calculate_state <= cal_init;
            case (calculate_state)
              cal_init: begin
                sum <= 32'b0;
                differ <= 32'b0;
                mult <= 32'b0;
                end_of_cal <= 0;
                calculate_state <= cal_part1;
              end
              cal_part1: begin
                mult <= my_w1 * my_x1;
                calculate_state <= cal_part2;
              end
              cal_part2: begin
                sum <= sum + mult;
                mult <= my_w2 * my_x2;
                calculate_state <= cal_sum;
              end
              cal_sum: begin
                sum <= sum + mult;
                calculate_state <= cal_bias;
              end
              cal_bias: begin
                sum <= sum + my_bias;
                calculate_state <= cal_F;
              end
              cal_F: begin
                F <= (sum >= 0) ? 1 : 0;
                calculate_state <= cal_differ;
              end
              cal_differ: begin
                differ <= my_label - F;
                calculate_state <= cal_end;
              end
              cal_end: begin
                calculate_state <= cal_init;
                end_of_cal <= 1;
              end
              default: begin
                calculate_state <= cal_init;
              end
            endcase
          end
        end
        
        update: begin
          if (control[3] == 1 && end_of_up) begin
            state <= finish;
          end else begin
            state <= update;
            update_state <= upd_init;
            case (update_state)
              upd_init: begin
                end_of_up <= 0;
                update_state <= upd_bias;
                w_w <= 1;
              end
              upd_bias: begin
                bias_out <= my_bias + differ * 512;
                update_state <= upd_part2;
              end
              upd_part2: begin
                w2_out <= my_w2 + differ * my_x2;
                w_out <= bias_out;
                update_state <= upd_part1;
              end
              upd_part1: begin
                w1_out <= my_w1 + differ * my_x1;
                w_cnt <= w_cnt - 1;
                w_out <= w2_out;
                update_state <= upd_wr;
              end
              upd_wr: begin
                w_cnt <= w_cnt - 1;
                w_out <= w1_out;
                update_state <= upd_end;
              end
              upd_end: begin
                end_of_up <= 1;
                w_w <= 0;
                update_state <= upd_init;
              end
              default: begin
                update_state <= upd_init;
              end
            endcase
          end
        end

        finish: begin
          // my_w1 <= w1_out;
          // my_w2 <= w2_out;
          // my_bias <= bias_out;
          state <= start;
        end
        default: begin
          state <= start;
        end
      endcase
    end
  end
endmodule
