function  data_file_generator(file_name,stream_size)
out_file_id=fopen(file_name,'w');

%creating the bit stream
bit_stream=randi([0, 1], 1, stream_size);

%writing the bit stream on the file
fprintf(out_file_id,'%s\n',num2str(bit_stream));

%close the file
fclose(out_file_id);
end

