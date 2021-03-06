warning ('off','all')

t0 = clock;
rng default; % For reproducibility

% Import the data:
[~, ~, raw] = xlsread('C:\Users\�����\Desktop\Developing-Variety-Of-Methods-For-Identifying-Anomalies-\Tables\Diabeteswith01.xls','Sheet1','A2:I769');

R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % Find non-numeric cells
raw(R) = {2.0}; % Replace non-numeric cells

% Create output variable:
data = reshape([raw{:}],size(raw));

% Find out data size:
[rows, columns] = size(data);

counter = 0;
for i = 1:rows
    if data(i, columns) == 1
        counter = counter + 1;
    end
    if counter == 25
        break;
    end
end

disp ("Calculation Results:");
fprintf(1, '\n');

if counter ~= 25
    disp("Error - small database");
    return
end

entropyArray = entropy(data, rows, columns);
fprintf(1, '\n');
LZArray = LZ(data, rows, columns);
fprintf(1, '\n');
MLarray = ML(data, rows, columns);
fprintf(1, '\n');

counterSS = 0;
counterHS = 0;
counterSH = 0;
counterHH = 0;

for i = 1:length(MLarray)-1
    if MLarray(i) + entropyArray(i) + LZArray(i) >= 2 % Anomaly
        %disp(i + " is anomaly.")
        if data(i,columns) == 0
            counterSS = counterSS + 1;
        else
            counterHS = counterHS + 1;
        end
    else
        if data(i,columns) == 0
            counterSH = counterSH + 1;
        else
            counterHH = counterHH + 1;
        end
    end
end

% In what we were right and wrong:
disp("-> Majorty Vote <-");
PercentageOfSuccess = (counterSS + counterHH) / rows;
PercentageOfSuccess = PercentageOfSuccess * 100;
disp ("Success Percentage of the Method: "+PercentageOfSuccess + "%");
good = counterSS + counterHH;
bad = counterHS + counterSH;

ms = round(etime(clock,t0) * 1000);
disp("Run time of majority vote (ms): " + ms);
