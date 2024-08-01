function [packeted_stream] = make_backets(instream,packet_size,gap)
packeted_stream=[];
counter=0;
array_size=length(instream);
for i=1:array_size
    packeted_stream=[packeted_stream,instream(i)];
    counter=counter+1;
    if(counter==packet_size)
         packeted_stream=[packeted_stream,gap];
         counter=0;
    end
end
new_size=length(packeted_stream);

while mod(new_size,packet_size)
    packeted_stream=[packeted_stream,0];
    new_size=length(packeted_stream);
end

end

