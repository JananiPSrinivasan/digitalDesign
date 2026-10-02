class uart_transaction;

    rand bit [7:0] data;

    function void display(syting name); 
        $display ("[%s] Data: 0x%0h", name, data);
    endfunction

endclass

class uart_partity extends uart_transaction; 
    rand bit parity;
endclass