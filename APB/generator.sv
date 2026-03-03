class generator;

  mailbox #(apb_transaction) mbx;

  int num_trans = 10;
  bit [4:0] saved_addr [10];
  bit [4:0] saved_data [10];

  function new(mailbox #(apb_transaction) mbx);
    this.mbx = mbx;
  endfunction

  task write_phase();
    apb_transaction tr;

    for(int i=0; i<num_trans; i++) begin
      tr = new();
      tr.pwrite = 1;
      tr.addr   = i;
      tr.data   = $urandom_range(1,31);

      saved_addr[i] = tr.addr;
      saved_data[i] = tr.data;

      tr.display("GEN-WRITE");
      mbx.put(tr);
    end
  endtask

  task read_phase();
    apb_transaction tr;

    for(int i=0; i<num_trans; i++) begin
      tr = new();
      tr.pwrite = 0;
      tr.addr   = saved_addr[i];
      tr.data   = 0;

      tr.display("GEN-READ");
      mbx.put(tr);
    end
  endtask

  task run();
    write_phase();
    #20;
    read_phase();
  endtask

endclass
