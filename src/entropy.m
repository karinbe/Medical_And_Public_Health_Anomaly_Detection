function entropyArray = entropy(data, rows, columns)

maxColumnsArray = zeros(1, columns-1); % Contains the highest value of each column
for i = 1:columns-1
    maxVal = max(data(:,i));
    maxColumnsArray(i) = maxVal;
end

entropyArray = zeros(1,rows+1);
Hx = zeros(1,rows); % Contains the entropy of each row

% Calculating entropy for esch row:
for i = 1:rows
    for j = 1:columns-1
        number = data(i,j);
        px = ProbabilityCalculation(number, maxColumnsArray(j));
        if px ~= 0
            Hx(i) = Hx(i) + (px * log10(px));
        end
        
    end
    Hx(i) = Hx(i) * (-1);
end

n = 10; % Arbitrary selection of the amount of training data

% Finding the split rule:
found = 0; % counter for Training data 
sum = 0; % Sum of the Training data entropy values
i = 1;

while found < n
    if data(i,columns) == 1
        sum = sum + Hx(i);
        found = found + 1;
    end
    i = i + 1;
end

average = sum / n; % Average of the n first healthy

% Standard deviation
standardDev = 0; 
for x = 1:i
    if data(x,columns) == 1
        standardDev = standardDev + power(Hx(x)-average ,2);
    end
end
standardDev = sqrt(standardDev / n);

% Finding anomalies
for i = 1:length(Hx)
    if Hx(i) > average + (1 * standardDev)
        entropyArray(i+1) = 1;
    end
end
end

% -------------------------------------------------------------------------
% Function that get a number, check its range
% and return the probability to be anomaly.
function p = ProbabilityCalculation(number, maxVal)
p = number / maxVal;
end