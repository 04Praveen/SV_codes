interface apb_if(input logic PCLK);

  logic PRESETn;

  logic PSEL;
  logic PENABLE;
  logic PWRITE;

  logic [4:0] PADDR;
  logic [4:0] PWDATA;
  logic [4:0] PRDATA;

  logic PREADY;
  logic PSLVERR;

endinterface
