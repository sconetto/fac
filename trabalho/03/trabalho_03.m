x = 0.12;
k = 0; 
an = 0; 
S = 0;
while (k <= 82)
an = ((factorial((2*k)))/((4^k)*((factorial(k))^2)*((2*k)+1)))*(x^((2*k)+1))
S = S + an;
k = k + 1;
end
fprintf('arcsin(%f) = %f',x,S)
fprintf('\n The number of terms used is: %i \n',k)
