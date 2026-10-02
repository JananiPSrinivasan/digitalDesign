//The main objective of this class is to drive the data in the data pin.

class uart_driver;

// so he interface is the starting point. so that should be referred.

// the handle or the reference to the pointer is created from the interface class 
// but its defined with virtual type?
// Why?
// Any change in the driver should immediately reflect on the interface
// So we create it with virtual

// This class will have its own pointer say vif
// That will contain the value passed in the object

virtual uart_if vif; // virtual handle

//so whenever the new function is called in the obeject with a value passed, 
// it gets assigned to vif.

function new(virtual uart_if pif) 
    this.vif = pif;
endfunction

// How do we drive the data?
// creating tasks 

task drive (uart_transaction tx);
    @(posedge vif.clk); 

    vif.tx_hold_register <= tx.data;
    vif.tx_valid <= 1'b1;

    @(posedge vif.clk)

    vif.tx_valid <= 1'b0;
    tx.display("DRIVER");

endtask

endclass