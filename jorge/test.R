str_data_set <- "f"


################################################################################
# %% ---------------------------------------------------------------------------

time_start <- Sys.time()

dir_in <- file.path("data_out", str_data_set)

file_streets <- file.path(dir_in, "streets.rds")
df_streets <- readRDS(file_streets)

file_streets <- file.path(dir_in, "streets_code_and_names.rds")
df_street_codes <- readRDS(file_streets)


# in
filename <- paste0(str_data_set, ".txt")
str_path <- file.path("data-in", filename)
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
# get number of intersections

df_inter <- df_streets %>% distinct(inter_out)
int_num_inter <- df_inter %>% nrow()

df_streets <- df_streets %>%
              select(inter_out, streetcode)


################################################################################
# %% ---------------------------------------------------------------------------
# get streets on each intersection

dir_out <- "solutions"
file_out <- paste0("solution-", str_data_set, ".txt")
file_out <- file.path(dir_out, file_out)
fileConn <- file(file_out, open = "wt")

# write number of intersections
writeLines(as.character(int_num_inter), fileConn)
loop_inter <- df_inter[2, ]

for (loop_inter in df_inter$inter_out) {

    # write inter_out
    writeLines(as.character(loop_inter), fileConn)

    # write number of green lights
    writeLines(as.character(1), fileConn)

    streets <- df_streets %>%
               dplyr::filter(inter_out == loop_inter) %>%
               select(streetcode)
    street_loop <- streets[1, 1]

    street_loop_name <- df_street_codes %>%
                        dplyr::filter(streetcode == street_loop) %>%
                        select(streetname)
    street_loop_name <- street_loop_name[1, 1]

    # write inter_out
    street_out <- paste(street_loop_name, D)
    writeLines(street_out, fileConn)
}

close(fileConn)


################################################################################
# %% ---------------------------------------------------------------------------

time_end <- Sys.time()
dt <- difftime(time_end, time_start, unit = "mins")
cat("\nTime: ", dt, " mins\n")
