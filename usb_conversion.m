function [outstream] = usb_conversion(instream)
counter_for_ones=0; %A counter variable to count if the data manipulated ends at five ones 
distance=0;% A variable to shift the data array

MAX_SIZE=length(instream);
outstream=[];
outstream(1)=instream(1);
for i=2:MAX_SIZE
    if (counter_for_ones==5)
        outstream(i+distance)=0;
        distance=distance+1;
        outstream(i+distance)=instream(i);
        counter_for_ones=0;
        continue
    end
    if(instream(i)==0)
        outstream(i+distance)=~outstream(i-1+distance);
    elseif (instream(i)==1)
        outstream(i+distance)=outstream(i-1+distance);   
    end
    if(outstream(i)==0)
        counter_for_ones=0;
    end
    if(outstream(i)==1)
        counter_for_ones=counter_for_ones+1;
    end
  
end
end

