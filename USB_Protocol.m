clear
clc
MAX_SIZE=2000; %Start MAX_SIZE of received bytes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%opening the input file
data_file_name="input.txt";
%data_file_name="data.txt";
data_file_id=fopen(data_file_name,'r');
%if we need to make an input file:
%data_file_id=data_file_generator(data_file_name,MAX_SIZE);

 if data_file_id==-1 %if it is not opened
     disp("Error Opening the data file");
     return;
 end
%read from the file
random_data=load(data_file_name);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start_byte=[0 0 0 0 0 0 0 1];
random_data=[start_byte,random_data];
usb_array=usb_conversion(random_data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
packeted_usb_array=make_packets(usb_array,32,[0,0,0]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("The remainder of USB Protocol data by 32 :")
disp(rem(length(packeted_usb_array),32))

% Open the conversion file
conversion_file_id="conversion.txt";
conversion_file_id = fopen(conversion_file_id, 'w');

if conversion_file_id ==-1 % it is not opened
    disp("Error Opening the conversion file");
    return;
end

% Write on the file the bit_stream after conversion
fprintf(conversion_file_id,'%s\n',num2str(packeted_usb_array));

% Close the file
fclose(conversion_file_id);


%display bit stream before and after conversion at two rows
for i=length(random_data):length(packeted_usb_array)  
    random_data(i)=0;
end
    random_data(2,:)=packeted_usb_array;
