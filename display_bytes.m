function   display_bytes(bitstream,byteSize)
bytenum=1;
for i=0:byteSize:length(bitstream)-byteSize %byte by byte
    fprintf("\nThe %i %ibyte:\n",bytenum,byteSize); 
    disp(bitstream(1,i+1:i+byteSize));
    bytenum=bytenum+1;
end
end

