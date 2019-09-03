java -jar target/tabula-1.0.2-jar-with-dependencies.jar ../../../Akshay_Form16_PartA.pdf 

#Reading a section flag: -a 
java -jar target/tabula-1.0.2-jar-with-dependencies.jar -a 388,7,544,589 ../../../Akshay_Form16_PartA.pdf 


#Reading a section of a password protected file with password NEE0306  flag: -s
java -jar target/tabula-1.0.2-jar-with-dependencies.jar  -s NEE0306 -a 560,7,760,589 ../../../documents/HDFC_ContractNote_20161024_NEE0306.pdf 


#Reading first page of a document with a section
java -jar target/tabula-1.0.2-jar-with-dependencies.jar --lattice -a 68,18,791,573 ~/Downloads/Akshay_Form16_PartA_FY201718.pdf >~/Downloads/Akshay_Form16_PartA_FY201718.csv
