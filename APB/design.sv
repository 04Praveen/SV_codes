module apb(
    input        PCLK, PRESETn,
    input        PSEL, PENABLE,
    input        PWRITE,
    input  [4:0] PADDR,
    input  [4:0] PWDATA,
    output reg        PREADY, PSLVERR,
    output reg [4:0]  PRDATA
);

  parameter IDLE  = 2'b00,
            SETUP = 2'b01,
            ACCESS= 2'b10;

  reg [1:0] state;
  reg [4:0] mem [0:31];
  integer i;

  always @(posedge PCLK or negedge PRESETn) begin
    if(!PRESETn) begin
      state   <= IDLE;
      PREADY  <= 0;
      PSLVERR <= 0;
      PRDATA  <= 0;

      for(i=0;i<32;i=i+1)
        mem[i] <= 0;
    end
    else begin
      case(state)

        IDLE: begin
          PREADY <= 0;
          if(PSEL && !PENABLE)
            state <= SETUP;
        end

        SETUP: begin
          if(PSEL && PENABLE)
            state <= ACCESS;
          else if(!PSEL)
            state <= IDLE;
        end

        ACCESS: begin
          PREADY <= 1;

          if(PWRITE)
            mem[PADDR] <= PWDATA;
          else
            PRDATA <= mem[PADDR];

          state <= IDLE;
        end

        default: state <= IDLE;

      endcase
    end
  end

endmodule
