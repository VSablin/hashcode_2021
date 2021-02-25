# script to extract the 

str_path <- paste0("data-in/",
                   "a.txt")

str_first_line <- readLines(str_path, 1)

str_quantities <- unlist(str_split(string = str_first_line,
                                   pattern = " "))

D <- str_quantities[1]
I <- str_quantities[2]
S <- str_quantities[3]
V <- str_quantities[4]
F <- str_quantities[5]
