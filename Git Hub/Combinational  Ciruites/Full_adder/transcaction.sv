//Transaction class : just declare all the signals of interface/dut 
class transaction; // packet class
  rand bit a;
  rand bit b;
  rand bit c;
  
	   bit sum;  //outputs so dont randomize
  	   bit carry;
  
  //Display function to get a, b , sum , carry in all classes
  
  function void display (string name);// just a display function to cal from all TB Components and Display values
    $display("__________ %s _________", name);
    $display("a = %0b, b=%0b, c=%0b,  sum = %0b, carry = %0b", a,b,c,sum,carry);
    $display(".......................");
    
  endfunction
  
endclass
