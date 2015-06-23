#####extract the data from .lis and dump it into the txt for matlab analysis#####

##### tianheng tu  ########
##### 10/14/13     ########
##### UCLA EDA LAB ########

##### save as .csv easy for matlab process
##### differ from the 4_cell.py with mark different here

import os
import re
import pdb
import csv
import inspect

filename = inspect.getfile(inspect.currentframe())
filename1 = filename.split('\\')
filename2 = filename1[-1];
filename3 = filename2.split('.')
filename4 = filename3[0]
##print(filename2)

CurrentPath = os.getcwd();
os.chdir(CurrentPath);


## different here
dirt = str(filename4)+".lis"
##ListData = open("n_one.lis","r")
ListData = open(dirt,"r")

Content = []

for line in ListData:
    Content.append(line)

ListData.close()

# from line 198 to line 897
# from line 84 to 783

voltage = [];
current = [];

#test for starting and ending points of the content in list file

##for i in range(0,len(Content)):
##    if(Content[i] == "x\n"):
##        print("hahahahahha")
##    if(Content[i] == "y\n"):
##        print("xixiixxixi")
##
##pdb.set_trace()

startFlag = False
lineNumber = float('inf')

for i in range(0,len(Content)):
    
    #if comes to an end stop parsing right now
    if(Content[i] == "y\n"):
        startFlag = False
        
    #parsing the line
    if(startFlag == True and i >= lineNumber + 4):
        
        tempLine = Content[i]
        
##        print(tempLine)
        
        #remove the duplicated spaces in a line
        tempLine = re.sub(' +',' ',tempLine)
        tempData = tempLine.split(" ")

        #extract the current and voltage in a line
        TempC = tempData[-2]
        TempV = tempData[-3]

        #if m in a C/V divided by 1000
        #if u in a C/V divided by 1000000
        #if n in a C/V divided by 1000000000
        #if k in a C/V multiply by 1000
        if("m" in TempC):
            current.append(float(TempC.split('m')[0])/1000)
        else:
            if("u" in TempC):
                current.append(float(TempC.split('u')[0])/1000000)
            else:
                if("n" in TempC):
                    current.append(float(TempC.split('n')[0])/1000000000)
                else:
                    if("k" in TempC):
                        current.append(float(TempC.split('k')[0])*1000)
                    else:
                        current.append(float(TempC))

        if("m" in TempV):
            voltage.append(float(TempV.split('m')[0])/1000)
        else:
            if("u" in TempV):
                voltage.append(float(TempV.split('u')[0])/1000000)
            else:
                if("n" in TempV):
                    voltage.append(float(TempV.split('n')[0])/1000000000)
                else:
                    if("k" in TempV):
                        voltage.append(float(TempV.split('k')[0])*1000)
                    else:
                        voltage.append(float(TempV))


                
    #put it here to cause 1 i delay
    #otherwise excute parsing during the line "x\n"
    # still need a counter to count the current line number
    if(Content[i] == "x\n"):
##        print(Content[i])
##        pdb.set_trace()
        startFlag = True
        lineNumber = i
        
    
##    voltage.append(tempData[1].strip())
##    current.append(tempData[2].strip())

##output = open("curve.txt","w")
##
##for i in range(0, len(voltage)):
##    if(float(current[i]) >= 0):
####        print(current[i])
##        output.write(str(voltage[i])+"\t"+str(current[i])+"\n")
##
##output.close()

## writing into the csv easy for matlab to read
tempCurrent = []
tempVoltage = []

for i in range(0,len(current)):
    if(current[i] >= 0):
        tempCurrent.append(current[i])
        tempVoltage.append(voltage[i])

result = []
result.append(tempVoltage)
result.append(tempCurrent)
result = zip(*result)


## different here
outputfile = "output_"+str(filename4)+".csv"
print(outputfile)
##resultFile = open("output_n_one.csv",'wb')
resultFile = open(outputfile,'wb')

wr = csv.writer(resultFile, dialect = 'excel')
wr.writerows(result)
resultFile.close()
print('data has been successfully dumped!')
