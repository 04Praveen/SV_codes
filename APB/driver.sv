class driver;

  virtual apb_if vif;
  mailbox #(apb_transaction) mbx;

  function new(virtual apb_if vif,
               mailbox #(apb_transaction) mbx);
    this.vif = vif;
    this.mbx = mbx;
  endfunction

  task run();
    apb_transaction tr;

    forever begin
      mbx.get(tr);

      if(tr.pwrite)
        apb_write(tr.addr, tr.data);
      else
        apb_read(tr.addr);
    end
  endtask

  task apb_write(bit [4:0] addr, bit [4:0] data);
    @(posedge vif.PCLK);
    vif.PADDR   <= addr;
    vif.PWDATA  <= data;
    vif.PWRITE  <= 1;
    vif.PSEL    <= 1;
    vif.PENABLE <= 0;

    @(posedge vif.PCLK);
    vif.PENABLE <= 1;

    wait(vif.PREADY);

    @(posedge vif.PCLK);
    vif.PSEL    <= 0;
    vif.PENABLE <= 0;
    vif.PWRITE  <= 0;
  endtask

  task apb_read(bit [4:0] addr);
    @(posedge vif.PCLK);
    vif.PADDR   <= addr;
    vif.PWRITE  <= 0;
    vif.PSEL    <= 1;
    vif.PENABLE <= 0;

    @(posedge vif.PCLK);
    vif.PENABLE <= 1;

    wait(vif.PREADY);

    @(posedge vif.PCLK);
    vif.PSEL    <= 0;
    vif.PENABLE <= 0;
  endtask

endclass
