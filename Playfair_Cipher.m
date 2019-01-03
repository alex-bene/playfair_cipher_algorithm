clc
clear all
close all
disp('Playfair Cipher Algorithm')
fprintf('\n');
key='ASSIGNMENTKEYWORD';
fprintf('KEY WORD for playfair cipher : %s', key);

% Playfair Table Construction
key_len=length(key);
playfair_table=zeros(5,5);
alphabet_exist=zeros(1,26); % a table that, if the letter c (==char) isfound the it (the table) has 1 in index c-'A'+1 else it has 0
alphabet_exist(10)=1; % index 10 is letter J which is the same (for the algorithm) to I, so I don't want it in my Playfair table
j=1;
for i=1:key_len
    num=double(key(i));
    if(alphabet_exist((num-'A')+1)==0)
        playfair_table(floor((j-1)/5)+1, mod(j-1,5)+1)=num;
        alphabet_exist((num-'A')+1)=1;
        j=j+1;
    end
end
for i=1:26
    if(alphabet_exist(i)==0)
        playfair_table(floor((j-1)/5)+1, mod((j-1),5)+1)=i+'A'-1;
        alphabet_exist(i)=1;
        j=j+1;
    end
end
playfair_table
display(char(playfair_table));
fprintf('\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
sentence='thisballisunderthegreentable';
sentence=upper(sentence); %????? ??? ????????
s_len=length(sentence);

% I place an X between any 2 consecutive same latter while also in the end
% of the word if its length (after the additions of X's) is odd
prev=sentence(1);
i=2;
while(i<=s_len)
    current=sentence(i);
    if(prev==current)
        sentence=insertAfter(sentence,i-1,'X');
        s_len = s_len+1;
        i = i+1;
    end
    prev=current;
    i = i+1;
end
if(mod(s_len,2)==1)
    sentence=insertAfter(sentence,i-1,'X');
    s_len=s_len+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% I create the inverse of Playfair by the sense that if Playfair has the
% letter c (==char) on index i then the inverse has i on index c-'A'+1
inverse = zeros(1, 25);
for i=1:25
    inverse(playfair_table(floor((i-1)/5)+1,mod(i-1,5)+1)-'A'+1)=i;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

encrypted_sentence=zeros(1,s_len);
decrypted_sentence=zeros(1,s_len);
 for i=1:s_len/2
     %encryption
     if(same_line(sentence(i*2-1), sentence(i*2), inverse))
         k=inverse(sentence(i*2-1)-'A'+1);
         encrypted_sentence(i*2-1) = playfair_table(floor((k-1)/5)+1,mod(mod(k-1,5)+1,5)+1);
         k=inverse(sentence(i*2)-'A'+1);
         encrypted_sentence(i*2) = playfair_table(floor((k-1)/5)+1,mod(mod(k-1,5)+1,5)+1);
     elseif(same_row(sentence(i*2-1), sentence(i*2), inverse))
         k=inverse(sentence(i*2-1)-'A'+1);
         encrypted_sentence(i*2-1) = playfair_table(mod(floor((k-1)/5)+1,5)+1,mod(k-1,5)+1);
         k=inverse(sentence(i*2)-'A'+1);
         encrypted_sentence(i*2) = playfair_table(mod(floor((k-1)/5)+1,5)+1,mod(k-1,5)+1);
     else
         k=inverse(sentence(i*2-1)-'A'+1);
         k_2=inverse(sentence(i*2)-'A'+1);
         encrypted_sentence(i*2-1) = playfair_table(floor((k-1)/5)+1,mod(k_2-1,5)+1);
         encrypted_sentence(i*2) = playfair_table(floor((k_2-1)/5)+1,mod(k-1,5)+1);
     end
     %decryption
     if(same_line(encrypted_sentence(i*2-1), encrypted_sentence(i*2), inverse))
         k=inverse(encrypted_sentence(i*2-1)-'A'+1);
         decrypted_sentence(i*2-1) = playfair_table(floor((k-1)/5)+1,mod(mod(k-1,5)-1,5)+1);
         k=inverse(encrypted_sentence(i*2)-'A'+1);
         decrypted_sentence(i*2) = playfair_table(floor((k-1)/5)+1,mod(mod(k-1,5)-1,5)+1);
     elseif(same_row(encrypted_sentence(i*2-1), encrypted_sentence(i*2), inverse))
         k=inverse(encrypted_sentence(i*2-1)-'A'+1);
         decrypted_sentence(i*2-1) = playfair_table(mod(floor((k-1)/5)-1,5)+1,mod(k-1,5)+1);
         k=inverse(encrypted_sentence(i*2)-'A'+1);
         decrypted_sentence(i*2) = playfair_table(mod(floor((k-1)/5)-1,5)+1,mod(k-1,5)+1);
     else
         k=inverse(encrypted_sentence(i*2-1)-'A'+1);
         k_2=inverse(encrypted_sentence(i*2)-'A'+1);
         decrypted_sentence(i*2-1) = playfair_table(floor((k-1)/5)+1,mod(k_2-1,5)+1);
         decrypted_sentence(i*2) = playfair_table(floor((k_2-1)/5)+1,mod(k-1,5)+1);
     end
 end
 fprintf('Original Sentence (after adding X''s): %s',sentence);
 fprintf('\nEncrypted Sentence: %s',encrypted_sentence);
 fprintf('\nDecrypted Sentence: %s',decrypted_sentence);
 fprintf('\n');
 
 
 function[answer]=same_line(a,b,inverse)
    answer = ((floor((inverse(a-'A'+1)-1)/5)+1) == (floor((inverse(b-'A'+1)-1)/5)+1));
    return
 end
 function[answer]=same_row(a,b,inverse)
    answer = ((mod(inverse(a-'A'+1)-1,5)+1) == (mod(inverse(b-'A'+1)-1,5)+1));
    return
 end
% We tend to use instead of 2 for loop from 1:m and from 1:n, 1 for loop
% fron 1:m*n to accesss tables of m lines and n rows.
% The reason that we can do that is because i (in the case of m*n access)
% connects to the row and line number with the equation:
% line_number=floor((i-1)/m)+1, row_number=mod(i-1,n)+1