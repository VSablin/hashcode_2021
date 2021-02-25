# script to extract the


################################################################################
# %% ---------------------------------------------------------------------------
# file to read

time_start <- Sys.time()

str_data_set <- "a"
filename <- paste0(str_data_set, ".txt")
str_path <- file.path("data-in", filename)

dir_out <- file.path("data_out", str_data_set)


################################################################################
# %% ---------------------------------------------------------------------------
# get first line
str_first_line <- readLines(str_path, 1)

str_quantities <- unlist(str_split(string = str_first_line,
                                   pattern = " "))

D <- as.integer(str_quantities[1])
I <- as.integer(str_quantities[2])
S <- as.integer(str_quantities[3])
V <- as.integer(str_quantities[4])
F <- as.integer(str_quantities[5])


################################################################################
# %% ---------------------------------------------------------------------------
# Streets
cat("\n Processing streets")

str_streets <- readLines(str_path, n = S + 1)
str_streets <- tail(x = str_streets, n = S)

df_streets <- data.frame(inter_in = rep(NA, S),
                         inter_out = rep(NA, S),
                         streetcode = rep(NA, S),
                         L = rep(NA, S))
df_streets_codename <- data.frame(streetname = rep(NA, S),
                                  streetcode = rep(NA, S))

x <- 1
for (x in 1:S) {

    y <- str_streets[[x]]
    str <- unlist(str_split(string = y, pattern = " "))

    df_streets[x, "inter_in"] <- as.numeric(str[1])
    df_streets[x, "inter_out"] <- as.numeric(str[2])
    df_streets[x, "streetcode"] <- x
    df_streets[x, "L"] <- as.numeric(str[4])

    df_streets_codename[x, "streetname"] <- as.character(str[3])
    df_streets_codename[x, "streetcode"] <- x
}


file_out <- file.path(dir_out, "streets.csv")
data.table::fwrite(df_streets, file_out)


df_streets$streetcode <- seq(from = 1, to = S, by = 1)

file_out <- file.path(dir_out, "streets_code_and_names.csv")
data.table::fwrite(df_streets_codename, file_out)
file_out <- gsub(x = file_out, pattern = ".csv", replacement = ".rds")
saveRDS(df_streets_codename, file_out)

file_out <- file.path(dir_out, "streets.csv")
data.table::fwrite(df_streets, file_out)
file_out <- gsub(x = file_out, pattern = ".csv", replacement = ".rds")
saveRDS(df_streets, file_out)


################################################################################
# %% ---------------------------------------------------------------------------
# Cars
cat("\n Processing Cars")

str_cars <- readLines(str_path, n = V + S + 1)
str_cars <- tail(x = str_cars, n = V)

df_cars <- data.frame(streets = rep(NA, V))
x <- 1
for (x in 1:V) {

    y <- str_cars[[x]]
    str <- unlist(str_split(string = y, pattern = " "))
    df_str <- data.frame(streetname = str[-1], stringsAsFactors = FALSE)
    df_car_streets <- df_streets_codename %>%
                      right_join(df_str, by = "streetname") %>%
                      select(streetcode)

    df_cars[x, "streets"] <- paste(df_car_streets$streetcode, collapse = "_")
}

file_out <- file.path(dir_out, "cars.csv")
data.table::fwrite(df_cars, file_out)
file_out <- gsub(x = file_out, pattern = ".csv", replacement = ".rds")
saveRDS(df_cars, file_out)

################################################################################
# %% ---------------------------------------------------------------------------

time_end <- Sys.time()
dt <- difftime(time_end, time_start, unit = "mins")
cat("\nTime: ", dt, "\n")
