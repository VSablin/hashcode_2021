# %% -------------------------------------------------------------------
# read input and create output dir
str_data_set <- "a"

dir_in <- file.path("data_out", str_data_set)

df_cars <- data.table::fread(file.path(dir_in, "cars.csv"))
df_streets <- data.table::fread(file.path(dir_in, "streets.csv"))
df_streetcode <- data.table::fread(file.path(dir_in, "streets_code_and_names.csv"))

dir_out <- file.path("data_out/shortest_path", str_data_set)
if (!dir.exists(dir_out)) {
    dir.create(dir_out)
}

# %% -------------------------------------------------------------------
# read input and create output dir

df_car_time <- data.frame(cars = 1:nrow(df_cars),
                          time = rep(NA, nrow(df_cars)))

for (n in 1:length(df_car_time)) {
    int_streets <- str_split(df_cars[n, 1], "_") %>% unlist() %>% as.integer()
    df_car_time[n, "time"] <- dplyr::filter(df_streets, streetcode %in% int_streets)$L %>% sum()
}

df_car_time <- dplyr::arrange(df_car_time, time)

# %% -------------------------------------------------------------------
# 

df_inter_out <- data.frame(inter_out = unique(df_streets$inter_out),
                           included = FALSE)

conn <- file(description = file.path(dir_out, "out.txt"),
             open = "wt")

n <- df_car_time$cars[1]
for (n in df_car_time$cars) {
    int_streets <- str_split(df_cars[n, 1], "_") %>%
        unlist() %>%
        as.integer()
    m <- int_streets[1]
    for (m in int_streets) {
        int_inter_out <-
            dplyr::filter(df_streets, streetcode == m)$inter_out
        if (!df_inter_out[df_inter_out$inter_out == int_inter_out, "included"]) {
            df_inter_out[df_inter_out$inter_out == int_inter_out, "included"] <-
                TRUE
            writeLines(as.character(int_inter_out), conn)
            writeLines(df_streetcode$streetname[df_streetcode$streetcode == m], conn)
        }
    }
}

close(conn)
