class apb_transaction;

  bit        pwrite;
  bit [4:0]  addr;
  bit [4:0]  data;

  function void display(string tag="TRANS");
    $display("[%s] write=%0d addr=%0d data=%0d",
              tag, pwrite, addr, data);
  endfunction

endclass
